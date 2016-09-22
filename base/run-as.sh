#!/bin/bash dry-wit
# Copyright 2015-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3

function usage() {
cat <<EOF
$SCRIPT_NAME [[-u|--userId=userId] [-g|--groupId=groupId]]? folder command [args]*
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
  * command: anything to run.
  * args: the command arguments.
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
  export INVALID_OPTION="Unrecognized option";
  export NO_FOLDER_SPECIFIED="No folder specified";
  export NO_COMMAND_SPECIFIED="No command specified";
  export CANNOT_CHANGE_UID="Cannot change the uid of ";
  export CANNOT_RETRIEVE_USER_UID_OF_FOLDER="Cannot retrieve the user uid of ";
  export CANNOT_RETRIEVE_GROUP_GID_OF_FOLDER="Cannot retrieve the group gid of ";

  ERROR_MESSAGES=(\
    INVALID_OPTION \
    NO_FOLDER_SPECIFIED \
    NO_COMMAND_SPECIFIED \
    CANNOT_CHANGE_UID \
    CANNOT_RETRIEVE_USER_UID_OF_FOLDER \
    CANNOT_RETRIEVE_GROUP_GID_OF_FOLDER \
  );

  export ERROR_MESSAGES;
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

  if [[ -z ${FOLDER} ]]; then
    logDebugResult FAILURE "fail";
    exitWithErrorCode NO_FOLDER_SPECIFIED;
  else
    logDebugResult SUCCESS "valid";
  fi

  if [[ -z ${COMMAND} ]]; then
    logDebugResult FAILURE "fail";
    exitWithErrorCode NO_COMMAND_SPECIFIED;
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

  if [[ -z ${FOLDER} ]]; then
    FOLDER="${1}";
    shift;
  fi

  if [[ -z ${COMMAND} ]]; then
    COMMAND="$1";
    shift;
  fi

  if [[ -z ${ARGS} ]]; then
    ARGS="$@";
  fi
}

## Retrieves the uid of the owner user of given file or folder.
## -> 1: The file or folder.
## <- RESULT: The id of the user that owns the file or folder.
## Example:
##   retrieve_uid /tmp
##   echo "The id of the owner of /tmp is ${RESULT}";
function retrieve_owner_uid() {
  local _file="${1}"
  local _result;

  _result="$(stat -c '%u' "${_file}")";

  export RESULT="${_result}";
}

## Retrieves the id of the owner group of given file or folder.
## -> 1: The file or folder.
## <- RESULT: The id of the group that owns the file or folder.
## Example:
##   retrieve_uid /tmp
##   echo "The id of the group of /tmp is ${RESULT}";
function retrieve_owner_gid() {
  local _file="${1}"
  local _result;

  _result="$(stat -c '%g' "${_file}")";

  export RESULT="${_result}";
}

## Checks whether given uid already exists.
## -> 1: The user id.
## <- 0/${TRUE} if it exists; 1/${FALSE} otherwise.
##
## Example:
##   if uid_already_exists 1; then
##     echo "User 1 exists";
##   fi
function uid_already_exists() {
  local _uid="${1}";

  getent passwd ${_uid} > /dev/null;
}

## Retrieves the user id of given user.
## -> 1: The user name.
## <- RESULT: The user id.
##
## Example:
##   retrieve_user_from_uid "1";
##   echo "The name of user 1 is ${RESULT}";
function retrieve_user_from_uid() {
  local _uid="${1}";
  local _result;

  _result=$(getent passwd ${_uid} | cut -d':' -f1);

  export RESULT="${_result}";
}

## Retrieves the name of the user matching given id.
## -> 1: The user id.
## <- RESULT: The user name.
##
## Example:
##   retrieve_uid_from_user "root";
##   echo "The name of user root is ${RESULT}";
function retrieve_uid_from_user() {
  local _user="${1}";
  local _result;

  _result=$(getent passwd ${_uid} | cut -d':' -f3);

  export RESULT="${_result}";
}

## Creates a new user.
## -> 1: The user name.
## <- 0/${TRUE} if the user gets created successfully; 1/${FALSE} otherwise.
##
## Example:
## if create_user "fakeuser"; then
##    echo "fakeuser created successfully";
## fi
function create_user() {
  local _userName="${1}";

  useradd -M -N -l "${_userName}";
}

## Deletes given user.
## -> 1: The user name.
## <- 0/${TRUE} if the user is removed successfully; 1/${FALSE} otherwise.
##
## Example:
## if delete_user "fakeuser"; then
##    echo "fakeuser deleted successfully";
## fi
function delete_user() {
  local _userName="${1}";

  userdel "${_userName}";
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

## Runs the command in a folder, under a given user.
## -> 1: The user id.
## -> 2: The group id.
## -> 3: the folder.
## -> 4+: the command.
## Example:
##  run_command_as_uid_gid 1000 100 /tmp "ls -ltrhia"
function run_command_as_uid_gid() {
  local _uid="${1}";
  local _gid="${2}";
  local _folder="${3}";
  local _command="${4}";
  shift
  shift
  shift
  shift
  local _args="${@}";
  local _exports="$(export)";

  createTempFile
  local _runme="${RESULT}";

  cat << EOF > ${_runme}
#!/bin/bash

${_exports}
declare -x HOME="/home/${SERVICE_USER}"
cd ${_folder}
${_command} ${_args}
EOF
  chmod +x ${_runme}

  exec 2>&1
  chpst -u ${SERVICE_USER}:${SERVICE_GROUP} -U ${SERVICE_USER}:${SERVICE_GROUP} ${_runme}
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

  if [[ -z "${_uid}" ]]; then
    retrieve_owner_uid "${FOLDER}";
    _uid="${RESULT}";
  fi
  if [[ -z "${_uid}" ]]; then
    exitWithErrorCode CANNOT_RETRIEVE_USER_UID_OF_FOLDER "${FOLDER}";
  fi
  if [[ -z "${_gid}" ]]; then
    retrieve_owner_gid "${FOLDER}";
    _gid="${RESULT}";
  fi
  if [[ -z "${_gid}" ]]; then
    exitWithErrorCode CANNOT_RETRIEVE_GROUP_GID_OF_FOLDER "${FOLDER}";
  fi

  retrieve_uid_from_user "${SERVICE_USER}";
  _serviceUserId="${RESULT}";

  if uid_already_exists "${_uid}"; then
    _restoreUid=${TRUE};
    retrieve_user_from_uid "${_uid}";
    _uidUser="${RESULT}";
    _temporaryUser="temp$$";
    create_user "${_temporaryUser}";
    _temporaryUid="${RESULT}";
    delete_user "${_temporaryUser}";
    update_account "${_uidUser}" "${_temporaryUid}" "${_gid}";
  fi

  update_account "${SERVICE_USER}" "${_uid}" "${_gid}";

  run_command_as_uid_gid "${_uid}" "${_gid}" "${FOLDER}" "${COMMAND}" "${ARGS}";

  update_account "${SERVICE_USER}" "${_serviceUserId}" "${_gid}";

  if [ ${_restoreUid} -eq ${TRUE} ]; then
    update_account "${_uidUser}" "${_uid}" "${_gid}";
  fi
}

