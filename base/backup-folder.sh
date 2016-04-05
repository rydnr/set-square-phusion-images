#!/bin/bash dry-wit
# Copyright 2015-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3

function usage() {
cat <<EOF
$SCRIPT_NAME [source destination]?
$SCRIPT_NAME [-h|--help]
(c) 2015-today Automated Computing Machinery S.L.
    Distributed under the terms of the GNU General Public License v3

Copies the contents of a folder to a remote host, using

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
  export SOURCE_IS_MANDATORY="source is mandatory";
  export DESTINATION_IS_MANDATORY="destination is mandatory";

  ERROR_MESSAGES=(\
    INVALID_OPTION \
    SOURCE_IS_MANDATORY \
    DESTINATION_IS_MANDATORY \
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

  if [[ -z ${SOURCE} ]]; then
    SOURCE="${1}";
    shift;
  fi

  if [[ -z ${SOURCE} ]]; then
    logDebugResult FAILURE "fail";
    exitWithErrorCode SOURCE_IS_MANDATORY;
  fi

  if [[ -z ${DESTINATION} ]]; then
    DESTINATION="${1}";
    shift;
  fi

  if [[ -z ${DESTINATION} ]]; then
      logDebugResult FAILURE "fail";
      exitWithErrorCode DESTINATION_IS_MANDATORY;
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
  if    [[ -z "${DOBACKUP}" ]] \
     || [[ "${DOBACKUP}" != "true" ]]; then
    rsync ${RSYNC_OPTIONS} -e "ssh -p ${SQ_BACKUP_HOST_SSH_PORT} ${SSH_OPTIONS}" ${SOURCE%/}/ ${SQ_BACKUP_USER}@${SQ_IMAGE}${SQ_BACKUP_HOST_SUFFIX}:${DESTINATION%/}/
  else
    logDebug "Backup disabled";
  fi
}
