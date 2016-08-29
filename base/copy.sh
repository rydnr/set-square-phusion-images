#!/bin/bash dry-wit
# Copyright 2015-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3

function usage() {
cat <<EOF
$SCRIPT_NAME [-v[v] | -q]? origin destination
$SCRIPT_NAME [-h|--help]
(c) 2016-today Automated Computing Machinery S.L.
    Distributed under the terms of the GNU General Public License v3

A simple "copy" tool to copy files/folders from containers to host-mounted volumes,
ensuring the permissions are kept after copying.

Common flags:
    * -h | --help: Display this message.
    * -v: Increase the verbosity.
    * -vv: Increase the verbosity further.
    * -q | --quiet: Be silent.
EOF
}

## Defines the errors
## dry-wit hook
function defineErrors() {
  export INVALID_OPTION="Unrecognized option";
  export ORIGIN_IS_MANDATORY="origin is mandatory";
  export DESTINATION_IS_MANDATORY="destination is mandatory";
  export ORIGIN_DOES_NOT_EXIST="origin does not exist";
  export DESTINATION_DOES_NOT_EXIST="destination does not exist";
  export ORIGIN_IS_NOT_READABLE="No permissions to read from ";
  export CANNOT_WRITE_TO_DESTINATION="Cannot write to ";

  ERROR_MESSAGES=(\
    INVALID_OPTION \
    ORIGIN_IS_MANDATORY \
    DESTINATION_IS_MANDATORY \
    ORIGIN_DOES_NOT_EXIST \
    DESTINATION_DOES_NOT_EXIST \
    ORIGIN_IS_NOT_READABLE \
    CANNOT_WRITE_TO_DESTINATION \
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
      -h | --help | -v | -vv | -q)
         shift;
         ;;
      *) logDebugResult FAILURE "failed";
         exitWithErrorCode INVALID_OPTION;
         ;;
    esac
  done

  if [ -z "${ORIGIN}" ]; then
    ORIGIN="${1}";
  fi

  if [ -z "${ORIGIN}" ]; then
    exitWithErrorCode ORIGIN_IS_MANDATORY;
  fi

  if [ ! -e "${ORIGIN}" ]; then
    exitWithErrorCode ORIGIN_DOES_NOT_EXIST "${ORIGIN}";
  fi

  if [ ! -r "${ORIGIN}" ]; then
    exitWithErrorCode ORIGIN_IS_NOT_READABLE "${ORIGIN}";
  fi

  if [ -z "${DESTINATION}" ]; then
    DESTINATION="${1}";
  fi

  if [ -z "${DESTINATION}" ]; then
    exitWithErrorCode DESTINATION_IS_MANDATORY;
  fi

  if [ ! -e "${DESTINATION}" ]; then
    exitWithErrorCode DESTINATION_DOES_NOT_EXIST "${DESTINATION}";
  fi

  if [ ! -w "${DESTINATION}" ]; then
    exitWithErrorCode CANNOT_WRITE_TO_DESTINATION "${DESTINATION}";
  fi

  logDebugResult SUCCESS "valid";
}

## Parses the input
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
    esac
  done

  if [ -z "${ORIGIN}" ]; then
    ORIGIN="${1}";
  fi

  if [ -z "${DESTINATION}" ]; then
    DESTINATION="${1}";
  fi

  logDebugResult SUCCESS "valid";
}

## Retrieves the user id who owns given file or folder.
## -> 1: The file or folder.
## <- RESULT: The user id.
## Example:
##   retrieve_user_id /tmp;
##   echo "/tmp is owned by ${RESULT}";
function retrieve_user_id() {
  local _fileOrFolder="${1}";
  local _result=$(stat -c '%u' "${_fileOrFolder}");
  export RESULT="${_result}";
}

## Retrieves the group id which owns given file or folder.
## -> 1: The file or folder.
## <- RESULT: The group id.
## Example:
##   retrieve_group_id /tmp
##   echo "/tmp belongs to group ${RESULT}";
function retrieve_group_id() {
  local _fileOrFolder="${1}";
  local _result=$(stat -c '%d' "${_fileOrFolder}");
  export RESULT="${_result}";
}

## Copies a folder.
## -> 1: The user.
## -> 2: The group.
## -> 3: The origin folder.
## -> 4: The destination folder.
## Example:
##   copy_folder mysql mysql /var/local/mysql/conf.d /tmp/conf.d
function copy_folder() {
  local _user="${1}";
  local _group="${2}";
  local _origin="${3}";
  local _destination="${4}";
  local _single=0;
  rsync -az "${_origin}"/ "${_destination}"/ > /dev/null
  chown -R ${_user}:${_group} "${_destination}"/* > /dev/null;
}

## Main logic
## dry-wit hook
function main() {
  retrieve_user_id "${DESTINATION}";
  local _userId="${RESULT}";
  retrieve_group_id "${DESTINATION}";
  local _groupId="${RESULT}";

  copy_folder "${_userId}" "${_groupId}" "${ORIGIN}" "${DESTINATION}";
}
