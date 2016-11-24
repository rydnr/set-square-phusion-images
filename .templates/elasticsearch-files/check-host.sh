#!/bin/bash dry-wit
# Copyright 2014-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3

#set -o xtrace

# Prints how to use this script.
## dry-wit hook
function usage() {
  cat <<EOF
$SCRIPT_NAME [-v[v]|-q]
$SCRIPT_NAME [-h|--help]
(c) 2014-today Automated Computing Machinery S.L.
    Distributed under the terms of the GNU General Public License v3

Checks the host satisfies mandatory requirements for ElasticSearch.

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
  addError VM_MAX_MAP_COUNT_TOO_LOW "VM_MAX_MAP_COUNT value is too low";
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
        shift;
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
  local _maxMapCount;

  logInfo -n "Checking vm.max_map_count system value is at least 262144";
  _maxMapCount=$(sysctl vm.max_map_count | cut -d'=' -f 2 | tr -d ' ');

  if [ ${_maxMapCount} -lt 262144 ]; then
    logInfoResult FAILURE "${_maxMapCount}";
    exitWithErrorCode VM_MAX_MAP_COUNT_TOO_LOW ${_maxMapCount};
  else
    logInfoResult SUCCESS "${_maxMapCount}";
  fi
}
