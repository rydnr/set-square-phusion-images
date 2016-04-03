#!/bin/bash dry-wit
# Copyright 2016-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3

function usage() {
cat <<EOF
$SCRIPT_NAME
$SCRIPT_NAME [-h|--help]
(c) 2016-today Automated Computing Machinery S.L.
    Distributed under the terms of the GNU General Public License v3

Checks whether there's any new MariaDB configuration files
and restarts the server to apply them.

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
  export DESTINATION_FOLDER_IS_MANDATORY="The DESTINATION_FOLDER environment variable is mandatory";
  export SOURCE_FOLDER_IS_MANDATORY="The SOURCE_FOLDER environment variable is mandatory";
  export CHECKSUM_FILE_IS_MANDATORY="The CHECKSUM_FILE environment variable is mandatory";

  ERROR_MESSAGES=(\
    INVALID_OPTION \
    DESTINATION_FOLDER_IS_MANDATORY \
    SOURCE_FOLDER_IS_MANDATORY \
    CHECKSUM_FILE_IS_MANDATORY \
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

  if [ -z "${SOURCE_FOLDER}" ]; then
    logDebugResult FAILURE "failed";
    exitWithErrorCode SOURCE_FOLDER_IS_MANDATORY;
  fi

  if [ -z "${DESTINATION_FOLDER}" ]; then
      logDebugResult FAILURE "failed";
      exitWithErrorCode DESTINATION_FOLDER_IS_MANDATORY;
  fi

  if [ -z "${CHECKSUM_FILE}" ]; then
    logDebugResult FAILURE "failed";
    exitWithErrorCode CHECKSUM_FILE_IS_MANDATORY;
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
}


## Main logic
## dry-wit hook
function main() {
  local _check=${TRUE};
  local _previousCheck;
  local _newCheck;
  if [ -e "${CHECKSUM_FILE}" ]; then
    _previousCheck="$(cat "${CHECKSUM_FILE}" )";
    _newCheck="$(cat ${SOURCE_FOLDER}/* | ${HASH_ALGORITHM}sum)";
    if [[ "${_previousCheck}" == "${_newCheck}" ]]; then
      _check=${FALSE};
    fi
  fi

  if isTrue ${_check}; then
    logInfo "New configuration found in ${SOURCE_FOLDER}. Restarting MariaDB";
    rsync -az ${SOURCE_FOLDER}/ ${DESTINATION_FOLDER}/
    /usr/local/bin/_restart.sh
    echo "${_newCheck}" > "${CHECKSUM_FILE}";
  else
    logDebug "No new configuration found";
  fi
}
