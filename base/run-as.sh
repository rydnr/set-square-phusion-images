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

## Declares the requirements.
## dry-wit hook
function defineRequirements() {
  checkReq chpst CHPST_NOT_INSTALLED;
}

## Defines the errors.
## dry-wit hook
function defineErrors() {
  export INVALID_OPTION="Unrecognized option";
  export CHPST_NOT_INSTALLED="chpst is not installed";
  export NO_FOLDER_SPECIFIED="No folder specified";
  export NO_COMMAND_SPECIFIED="No command specified";
  export SERVICE_USER_IS_NOT_DEFINED="SERVICE_USER variable is not defined";
  export SERVICE_GROUP_IS_NOT_DEFINED="SERVICE_GROUP variable is not defined";
  export CANNOT_CHANGE_UID="Cannot change the uid of ";
  export CANNOT_CHANGE_GID="Cannot change the gid of ";
  export CANNOT_RETRIEVE_USER_UID_OF_FOLDER="Cannot retrieve the user uid of ";
  export CANNOT_RETRIEVE_GROUP_GID_OF_FOLDER="Cannot retrieve the group gid of ";
  export CANNOT_RETRIEVE_UID_FOR_USER="Cannot retrieve uid for ";
  export CANNOT_RETRIEVE_GID_FOR_GROUP="Cannot retrieve gid for ";

  ERROR_MESSAGES=(\
    INVALID_OPTION \
    CHPST_NOT_INSTALLED \
    NO_FOLDER_SPECIFIED \
    NO_COMMAND_SPECIFIED \
    SERVICE_USER_IS_NOT_DEFINED \
    SERVICE_GROUP_IS_NOT_DEFINED \
    CANNOT_CHANGE_UID \
    CANNOT_CHANGE_GID \
    CANNOT_RETRIEVE_USER_UID_OF_FOLDER \
    CANNOT_RETRIEVE_GROUP_GID_OF_FOLDER \
    CANNOT_RETRIEVE_UID_FOR_USER \
    CANNOT_RETRIEVE_GID_FOR_GROUP \
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
  fi

  if [[ -z ${COMMAND} ]]; then
    logDebugResult FAILURE "fail";
    exitWithErrorCode NO_COMMAND_SPECIFIED;
  fi

  if [[ -z ${SERVICE_USER} ]]; then
    logDebugResult FAILURE "fail";
    exitWithErrorCode SERVICE_USER_IS_NOT_DEFINED;
  fi

  if [[ -z ${SERVICE_GROUP} ]]; then
    logDebugResult FAILURE "fail";
    exitWithErrorCode SERVICE_GROUP_IS_NOT_DEFINED;
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
  local _rescode;

  logDebug -n "Checking if uid ${_uid} is already used";
  getent passwd ${_uid} > /dev/null;
  _rescode=$?;

  if [ ${_rescode} -eq ${TRUE} ]; then
    logDebugResult SUCCESS "true";
  else
    logDebugResult FAILURE "false";
  fi

  return ${_rescode};
}

## Checks whether given gid already exists.
## -> 1: The group id.
## <- 0/${TRUE} if it exists; 1/${FALSE} otherwise.
##
## Example:
##   if gid_already_exists 103; then
##     echo "Group 103 exists";
##   fi
function gid_already_exists() {
  local _gid="${1}";
  local _rescode;

  logDebug -n "Checking if gid ${_gid} already exists";
  getent group ${_gid} > /dev/null;
  _rescode=$?;

  if [ ${_rescode} -eq ${TRUE} ]; then
    logDebugResult SUCCESS "true";
  else
    logDebugResult FAILURE "false";
  fi

  return ${_rescode};
}

## Checks whether given user already exists.
## -> 1: The user name.
## <- 0/${TRUE} if it exists; 1/${FALSE} otherwise.
##
## Example:
##   if user_already_exists guest; then
##     echo "User guest exists";
##   fi
function user_already_exists() {
  local _user="${1}";
  local _rescode;

  logDebug -n "Checking if user ${_user} is already used";
  getent passwd ${_user} > /dev/null;
  _rescode=$?;

  if [ ${_rescode} -eq ${TRUE} ]; then
    logDebugResult SUCCESS "true";
  else
    logDebugResult FAILURE "false";
  fi

  return ${_rescode};
}

## Checks whether given group already exists.
## -> 1: The group name.
## <- 0/${TRUE} if it exists; 1/${FALSE} otherwise.
##
## Example:
##   if group_already_exists users; then
##     echo "Group users exists";
##   fi
function group_already_exists() {
  local _group="${1}";
  local _rescode;

  logDebug -n "Checking if group ${_group} already exists";
  getent group ${_group} > /dev/null;
  _rescode=$?;

  if [ ${_rescode} -eq ${TRUE} ]; then
    logDebugResult SUCCESS "true";
  else
    logDebugResult FAILURE "false";
  fi

  return ${_rescode};
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
  local _rescode;

  _result=$(getent passwd ${_uid} | cut -d':' -f1);
  _rescode=$?;

  export RESULT="${_result}";

  return ${_rescode};
}

## Retrieves the group id of given group.
## -> 1: The group name.
## <- RESULT: The group id.
##
## Example:
##   retrieve_group_from_gid "100";
##   echo "The name of group 1 is ${RESULT}";
function retrieve_group_from_gid() {
  local _gid="${1}";
  local _result;
  local _rescode;

  _result=$(getent group ${_gid} | cut -d':' -f1);
  _rescode=$?;

  if [ ${_rescode} -eq ${TRUE} ]; then
      export RESULT="${_result}";
  fi

  return ${_rescode};
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
  local _rescode;

  logDebug -n "Retrieving uid of user ${_user}";
  _result=$(getent passwd ${_user} | cut -d':' -f3);
  _rescode=$?;
  if [ ${_rescode} -eq ${TRUE} ]; then
    logDebugResult SUCCESS "${_result}";
    export RESULT="${_result}";
  else
    logDebugResult FAILURE "failed";
  fi

  return ${_rescode};
}

## Retrieves the name of the group matching given id.
## -> 1: The group id.
## <- RESULT: The group name.
##
## Example:
##   retrieve_gid_from_group "admin";
##   echo "The name of group admin is ${RESULT}";
function retrieve_gid_from_group() {
  local _group="${1}";
  local _result;
  local _rescode;

  logDebug -n "Retrieving gid of group ${_group}";
  _result=$(getent group ${_group} | cut -d':' -f3);
  _rescode=$?;
  if [ ${_rescode} -eq ${TRUE} ]; then
    logDebugResult SUCCESS "${_result}";
    export RESULT="${_result}";
  else
    logDebugResult FAILURE "failed";
  fi

  return ${_rescode};
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
  local _rescode;

  logDebug -n "Creating user ${_userName}";

  useradd -M -N -l "${_userName}";
  _rescode=$?;
  if [ ${_rescode} -eq ${TRUE} ]; then
    logDebugResult SUCCESS "done";
  else
    logDebugResult FAILURE "failed";
  fi

  return ${_rescode};
}

## Creates a new group.
## -> 1: The group name.
## <- 0/${TRUE} if the group gets created successfully; 1/${FALSE} otherwise.
##
## Example:
## if create_group "fakegroup"; then
##    echo "fakegroup created successfully";
## fi
function create_group() {
  local _groupName="${1}";
  local _rescode;

  logDebug -n "Creating group ${_groupName}";

  groupadd "${_groupName}";
  _rescode=$?;
  if [ ${_rescode} -eq ${TRUE} ]; then
    logDebugResult SUCCESS "done";
  else
      logDebugResult FAILURE "failed";
  fi

  return ${_rescode};
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
  local _rescode;

  logDebug -n "Deleting user ${_userName}";

  userdel "${_userName}";
  _rescode=$?;
  if [ ${_rescode} -eq ${TRUE} ]; then
    logDebugResult SUCCESS "done";
  else
    logDebugResult FAILURE "failed";
  fi

  return ${_rescode};
}

## Deletes given group.
## -> 1: The group name.
## <- 0/${TRUE} if the group is removed successfully; 1/${FALSE} otherwise.
##
## Example:
## if delete_group "fakegroup"; then
##    echo "fakegroup deleted successfully";
## fi
function delete_group() {
  local _groupName="${1}";
  local _rescode;

  logDebug -n "Deleting group ${_groupName}";

  groupdel "${_groupName}";
  _rescode=$?;
  if [ ${_rescode} -eq ${TRUE} ]; then
    logDebugResult SUCCESS "done";
  else
    logDebugResult FAILURE "failed";
  fi

  return ${_rescode};
}

## Runs the command in a folder, under a given user.
## -> 1: The user id.
## -> 2: The group id.
## -> 3: the folder.
## -> 4+: the command.
## Example:
##  run_command_as_uid_gid 1000 100 /tmp "ls -ltrhia"
function run_command_as_uid_gid() {
  local _user="${1}";
  local _uid="${2}";
  local _gid="${3}";
  local _folder="${4}";
  local _command="${5}";
  shift
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
declare -x HOME="/home/${_user}"
cd ${_folder}
${_command} ${_args}
EOF
  chmod +x ${_runme}

  logDebug "Running ${_command} ${_args} as ${SERVICE_USER}:${SERVICE_GROUP}";
  exec 2>&1
  chpst -u ${SERVICE_USER}:${SERVICE_GROUP} -U ${SERVICE_USER}:${SERVICE_GROUP} ${_runme}
}


## Modifies given user so that its uid matches a certain value,
## even if such value is already used by another group.
## -> 1: The user.
## -> 2: The desired user id.
## <- RESULT: the name of the group that is unbound first, in such case.
##
## Example:
##   bind_user "guest" 1000
function bind_user() {
  local _user="${1}";
  local _uid="${2}";
  local _aux;
  local _uidUser;
  local _result;

  if uid_already_exists "${_uid}"; then

    logDebug -n "Retrieving the user whose uid is ${_uid}";
    retrieve_user_from_uid "${_uid}";
    _aux=$?;
    _uidUser="${RESULT}";
    if [ ${_aux} -eq ${TRUE} ]; then
      logDebugResult SUCCESS "${_uidUser}";
    else
      logDebugResult FAILURE "non-existent";
      exitWithErrorCode CANNOT_RETRIEVE_USER_FOR_UID "${_uid}";
    fi
    if [ "${_uidUser}" != "${_user}" ]; then
      _temporaryUser="temp$$";
      create_user "${_temporaryUser}";
      retrieve_uid_from_user "${_temporaryUser}";
      _temporaryUid="${RESULT}";
      delete_user "${_temporaryUser}";
      update_user_uid "${_uidUser}" "${_temporaryUid}";
      _result="${_uidUser}";
    fi
  else
    if ! user_already_exists "${_user}"; then
      create_user "${_user}" "${_uid}" "${_gid}";
    fi
    update_user_uid "${_user}" "${_uid}";
  fi

  if [ -n "${_result}" ]; then
    export RESULT="${_result}";
  else
    export RESULT="";
  fi
}

## Binds given group to that its gid matches a certain value,
## even if such value is already used by another group.
## -> 1: The group.
## -> 2: The desired group id.
## <- RESULT: the name of the group that is unbound first, in such case.
##
## Example:
##   bind_group "guests" 103
function bind_group() {
  local _group="${1}";
  local _gid="${2}";
  local _result;
  local _rescode;
  local _aux;
  local _gidGroup;

  if gid_already_exists "${_gid}"; then

    logDebug -n "Retrieving the group whose gid is ${_gid}";
    retrieve_group_from_gid "${_gid}";
    _aux=$?;
    _gidGroup="${RESULT}";
    if [ ${_aux} -eq ${TRUE} ]; then
      logDebugResult SUCCESS "${_gidGroup}";
    else
      logDebugResult FAILURE "non-existent";
      exitWithErrorCode CANNOT_RETRIEVE_GROUP_FOR_GID "${_gid}";
    fi

    if [ "${_gidGroup}" != "${_group}" ]; then
      _temporaryGroup="temp$$";
      create_group "${_temporaryGroup}";
      retrieve_gid_from_group "${_temporaryGroup}";
      _temporaryGid="${RESULT}";
      delete_group "${_temporaryGroup}";
      update_group_gid "${_gidGroup}" "${_temporaryGid}";
      _result="${_gidGroup}";
    fi
  fi

  if ! group_already_exists "${_group}"; then
    create_group "${_group}" "${_gid}";
  fi

  if [ -n "${_result}" ]; then
    export RESULT="${_result}";
  else
    export RESULT="";
  fi
}

## Updates the uid of the user.
## -> 1: The user.
## -> 2: The uid.
## <- 0/${TRUE} if the user's uid is updated successfully; 1/${FALSE} otherwise.
## Example:
## update_user_uid "guest" 1001
function update_user_uid() {
  local _user="${1}";
  local _uid="${2}";
  local _rescode;

  logInfo -n "Changing ${_user}'s uid to ${_uid}";
  usermod -u ${_uid} ${_user} > /dev/null 2>&1
  _rescode=$?;
  if [ ${_rescode} -eq ${TRUE} ]; then
    logInfoResult SUCCESS "done";
  else
    logInfoResult FAILURE "failed";
    exitWithErrorCode CANNOT_CHANGE_UID "${_user}";
  fi

  return ${_rescode};
}

## Updates the gid of the user.
## -> 1: The user.
## -> 2: The gid.
## <- 0/${TRUE} if the user's gid is updated successfully; 1/${FALSE} otherwise.
## Example:
## update_user_gid "guest" 103
function update_user_gid() {
  local _user="${1}";
  local _gid="${2}";
  local _rescode;

  logInfo -n "Changing ${_user}'s primary group as ${_gid}";
  usermod -g ${_gid} ${_user} > /dev/null 2>&1
  _rescode=$?;
  if [ ${_rescode} -eq ${TRUE} ]; then
    logInfoResult SUCCESS "done";
  else
    logInfoResult FAILURE "unneeded";
  fi

  return ${_rescode};
}

## Updates the gid of the group.
## -> 1: The group.
## -> 2: The gid.
## <- 0/${TRUE} if the group's gid is updated successfully; 1/${FALSE} otherwise.
## Example:
## update_user_gid "guests" 103
function update_group_gid() {
  local _group="${1}";
  local _gid="${2}";
  local _rescode;

  logInfo -n "Changing ${_group}'s gid to ${_gid}";
  groupmod -g ${_gid} ${_group} > /dev/null 2>&1
  _rescode=$?;
  if [ ${_rescode} -eq ${TRUE} ]; then
    logInfoResult SUCCESS "done";
  else
    logInfoResult FAILURE "failed";
    exitWithErrorCode CANNOT_CHANGE_GID "${_group}";
  fi

  return ${_rescode};
}

## Adds given user to a group.
## -> 1: The user.
## -> 2: The group.
## <- 0/${TRUE} if the user gets added to the group successfully; 1/${FALSE} otherwise.
##
## Example:
##   if add_user_to_group guest users; then
##     echo "User guest added to group users";
##   fi
function add_user_to_group() {
  local _user="${1}";
  local _group="${2}";
  local _rescode;

  gpasswd -a ${_user} ${_group} > /dev/null;
  _rescode=$?;

  return ${_rescode};
}

## Main logic
## dry-wit hook
function main() {
  local _uid="${USER_ID}";
  local _gid="${GROUP_ID}";
  local _restoreUser;
  local _restoreGroup;

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

  bind_group "${SERVICE_GROUP}" "${_gid}";
  _restoreGroup="${RESULT}";
  bind_user "${SERVICE_USER}" "${_uid}";
  _restoreUser="${RESULT}";

  add_user_to_group "${SERVICE_USER}" "${SERVICE_GROUP}";

  run_command_as_uid_gid "${SERVICE_USER}" "${_uid}" "${_gid}" "${FOLDER}" "${COMMAND}" "${ARGS}";

  if [ -n "${_restoreGroup}" ]; then
    update_group_gid "${_restoreGroup}" "${_gid}";
  fi

  if [ -n "${_restoreUser}" ]; then
    update_user_uid "${_restoreUser}" "${_uid}";
  fi
}

