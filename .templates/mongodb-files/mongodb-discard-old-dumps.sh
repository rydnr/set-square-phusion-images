#!/bin/bash dry-wit
# Copyright 2017-today Automated Computing Machinery
# Licensed under GPLv3.

# Prints how to use this script.
## dry-wit hook
function usage() {
  cat <<EOF
$SCRIPT_NAME [-v[v]|-q]
$SCRIPT_NAME [-h|--help]
(c) 2017-today Automated Computing Machinery

Deletes MongoDB dumps older than ${MONGODB_DUMP_RETAIN_DAYS}.

Common flags:
    * -h | --help: Display this message.
    * -v: Increase the verbosity.
    * -vv: Increase the verbosity further.
    * -q | --quiet: Be silent.
EOF
}

# Error messages
function defineErrors() {
  addError INVALID_OPTION "Unknown option";
}

## Parses the input
## dry-wit hook
function parseInput() {

  local _flags=$(extractFlags $@);
  local _flagCount=0;
  local _currentCount;
  local _help=${FALSE};

  # Flags
  for _flag in ${_flags}; do
    _flagCount=$((_flagCount+1));
    case ${_flag} in
      -h | --help)
        _help=${TRUE};
        shift;
        ;;
      -v | -vv | -q | --quiet)
        shift;
        ;;
      --)
        shift;
        break;
        ;;
    esac
  done
}

## Checking input
## dry-wit hook
function checkInput() {

  local _flags=$(extractFlags $@);
  local _flagCount;
  local _currentCount;
  local _oldIfs;

  logDebug -n "Checking input";

  # Flags
  for _flag in ${_flags}; do
    _flagCount=$((_flagCount+1));
    case ${_flag} in
      -h | --help | -v | -vv | -q | --quiet)
      ;;
      --)
        break;
        ;;
      *) logDebugResult FAILURE "fail";
         exitWithErrorCode INVALID_OPTION ${_flag};
         ;;
    esac
  done

  logDebugResult SUCCESS "valid";
}

## Main logic
## dry-wit hook
function main() {
  local _outputFolder="${MONGODB_DUMP_FOLDER}";

  logInfo -n "Deleting MongoDB dumps older than ${MONGODB_DUMP_RETAIN_DAYS} days in ${_outputFolder}";
  find "${_outputFolder}" -daystart -mtime +${MONGODB_DUMP_RETAIN_DAYS} -exec rm -f {} \;
  if isTrue $?; then
    logInfoResult SUCCESS "done";
  else
    logInfoResult FAILURE "failed";
  fi
}
