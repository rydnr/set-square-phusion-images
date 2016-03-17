#!/bin/bash dry-wit
# Copyright 2016-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3

function usage() {
cat <<EOF
$SCRIPT_NAME
$SCRIPT_NAME [-h|--help]
(c) 2015-today Automated Computing Machinery S.L.
    Distributed under the terms of the GNU General Public License v3

Retrieves the latest version identifier.

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
  export SERVICE_VERSION_UNAVAILABLE="The SERVICE_VERSION information is not available";
  export CHECK_VERSION_SCRIPT_UNAVAILABLE="The check-version.sh script is not available";
  export EMPTY_RESPONSE_FROM_CHECK_VERSION_SCRIPT="Empty response from check-version.sh script";

  ERROR_MESSAGES=(\
    INVALID_OPTION \
    SERVICE_VERSION_UNAVAILABLE \
    CHECK_VERSION_SCRIPT_UNAVAILABLE \
    EMPTY_RESPONSE_FROM_CHECK_VERSION_SCRIPT \
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

  if [ -z ${SERVICE_VERSION} ]; then
    logDebugResult FAILURE "failed";
    exitWithErrorCode SERVICE_VERSION_UNAVAILABLE;
  fi

  if [ ! -f "${CHECK_VERSION_SCRIPT}" ]; then
    logDebugResult FAILURE "failed";
    exitWithErrorCode CHECK_VERSION_SCRIPT_UNAVAILABLE;
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
  local _suffix="$(basename $SCRIPT_NAME .sh)";
  _suffix="${_suffix#latest}";
  local _latest=$("${CHECK_VERSION_SCRIPT}${_suffix}");
  if [ -n "${_latest}" ]; then
    if [ "${_latest}" == "${SERVICE_VERSION}" ]; then
      echo "up to date";
    else
      echo "New version available: ${_latest}";
    fi
  else
    exitWithErrorCode EMPTY_RESPONSE_FROM_CHECK_VERSION_SCRIPT;
  fi
}
