#!/bin/bash dry-wit
# Copyright 2015-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3

function usage() {
cat <<EOF
$SCRIPT_NAME [[-u|--userId=userId] [-g|--groupId=groupId]]? folder script
$SCRIPT_NAME [[-u|--userId=userId] [-g|--groupId=groupId]]? folder command args
$SCRIPT_NAME [-h|--help]
(c) 2016-today ACM-SL
    Distributed this under the GNU General Public License v3.

Runs a command within given folder, under certain user/group.
If userId and groupId are omitted, those values are taken from the ownership information
of the folder parameter.

Where:
  * -u | --userId: The user id. Optional.
  * -g | --groupId: The group id. Optional.
  * folder: the folder where the command will be run.
  * script: The script to run.
  * command: anything to run.
  * args: Additional arguments to the command.
Common flags:
    * -h | --help: Display this message.
    * -v: Increase the verbosity.
    * -vv: Increase the verbosity further.
    * -q | --quiet: Be silent.
EOF
}

## Defines the errors.
## dry-wit hook
function defineErrors() {
  addError "INVALID_OPTION" "Unrecognized option";
  addError "NO_FOLDER_SPECIFIED" "No folder specified";
  addError "NO_SCRIPT_OR_COMMAND_SPECIFIED" "Neither script nor command are specified";
  addError "CANNOT_CHANGE_UID" "Cannot change the uid of ";
  addError "CANNOT_RETRIEVE_USER_UID_OF_FOLDER" "Cannot retrieve the user uid of ";
  addError "CANNOT_RETRIEVE_GROUP_GID_OF_FOLDER" "Cannot retrieve the group gid of ";
}

## Validates the input.
## dry-wit hook
function checkInput() {

  local _flags=$(extractFlags $@);
  local _flagCount;
  local _currentCount;
  logDebug -n "Checking input";

  # Flags
  for _flag in ${_flags}; do
    _flagCount=$((_flagCount+1));
    case ${_flag} in
      -h | --help | -v | -vv | -q | -u | --userId | -g | --groupId)
         shift;
         ;;
      *) logDebugResult FAILURE "failed";
         exitWithErrorCode INVALID_OPTION ${_flag};
         ;;
    esac
  done

  if isEmpty "${FOLDER}"; then
    logDebugResult FAILURE "fail";
    exitWithErrorCode NO_FOLDER_SPECIFIED;
  fi

  if isEmpty ${COMMAND} && isEmpty ${SCRIPT}; then
    logDebugResult FAILURE "fail";
    exitWithErrorCode NO_SCRIPT_OR_COMMAND_SPECIFIED;
  else
    logDebugResult SUCCESS "valid";
  fi
}

## Parses the input.
## dry-wit hook
function parseInput() {

  local _flags=$(extractFlags $@);
  local _flagCount;
  local _currentCount;

  # Flags
  for _flag in ${_flags}; do
    _flagCount=$((_flagCount+1));
    case ${_flag} in
      -h | --help | -v | -vv | -q)
        shift;
        ;;
      -u | --userId)
        export USER_ID="${1}";
        shift;
        ;;
      -g | --groupId)
        export GROUP_ID="${1}";
        shift;
        ;;
    esac
  done

  if isEmpty "${FOLDER}"; then
    FOLDER="${1}";
    shift;
  fi

  if isEmpty "${SCRIPT}"; then
    SCRIPT="${1}";
  fi

  if [ ! -e "${SCRIPT}" ]; then
    if isEmpty "${COMMAND}"; then
      COMMAND="$1";
      shift;
    fi

    if isEmpty "${ARGS}"; then
      ARGS="$@";
    fi
  fi
}

## Updates given account.
## -> 1: The user name.
## -> 2: The new user id.
## -> 3: The new group id.
## Example:
##   update_service_user_account guest 1000 1000
function update_account() {
  local _user="${1}";
  local _userId="${2}";
  local _groupId="${3}";

  logInfo -n "Changing ${SERVICE_USER}'s uid to ${_userId}";
  usermod -u ${_userId} ${SERVICE_USER} > /dev/null 2>&1
  if [ $? -eq ${TRUE} ]; then
      logInfoResult SUCCESS "done";
  else
    logInfoResult FAILURE "failed";
    exitWithErrorCode CANNOT_CHANGE_UID "${_user}";
  fi
  logInfo -n "Changing ${_user}'s primary group as ${_groupId}";
  usermod -g ${_groupId} ${SERVICE_USER} > /dev/null 2>&1
  if [ $? -eq ${TRUE} ]; then
      logInfoResult SUCCESS "done";
  else
    logInfoResult FAILURE "unneeded";
  fi
}

## Main logic
## dry-wit hook
function main() {
  local _uid="${USER_ID}";
  local _gid="${GROUP_ID}";
  local _restoreUid=${FALSE};
  local _uidUser;
  local _temporaryUser;
  local _temporaryUid;

  if isEmpty "${_uid}"; then
    retrieveOwnerUid "${FOLDER}";
    _uid="${RESULT}";
  fi
  if isEmpty "${_uid}"; then
    exitWithErrorCode CANNOT_RETRIEVE_USER_UID_OF_FOLDER "${FOLDER}";
  fi
  if isEmpty "${_gid}"; then
    retrieve_owner_gid "${FOLDER}";
    _gid="${RESULT}";
  fi
  if isEmpty "${_gid}"; then
    exitWithErrorCode CANNOT_RETRIEVE_GROUP_GID_OF_FOLDER "${FOLDER}";
  fi

  retrieveUidFromUser "${SERVICE_USER}";
  _serviceUserId="${RESULT}";

  if uidAlreadyExists "${_uid}"; then
    _restoreUid=${TRUE};
    retrieveUserFromUid "${_uid}";
    _uidUser="${RESULT}";
    _temporaryUser="temp$$";
    createUser "${_temporaryUser}";
    _temporaryUid="${RESULT}";
    deleteUser "${_temporaryUser}";
    update_account "${_uidUser}" "${_temporaryUid}" "${_gid}";
  fi

  update_account "${SERVICE_USER}" "${_uid}" "${_gid}";

  runCommandAsUidGid "${SERVICE_USER}" "${_uid}" "${_gid}" "${FOLDER}" "${COMMAND}" "${ARGS}";

  update_account "${SERVICE_USER}" "${_serviceUserId}" "${_gid}";

  if isTrue ${_restoreUid}; then
    update_account "${_uidUser}" "${_uid}" "${_gid}";
  fi
}
