#!/bin/bash dry-wit
# Copyright 2015-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3

function usage() {
  cat <<EOF
$SCRIPT_NAME 
$SCRIPT_NAME [-h|--help]
(c) 2017-today OSOCO Software Company.
    Distributed under the terms of the GNU General Public License v3

Restores all DEFAULT_* environment variables from their SQ_DEFAULT_* values, if not specified.

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
  addError "INVALID_OPTION" "Unrecognized option";
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
      --)
        shift;
        break;
        ;;
      *) logDebugResult FAILURE "failed";
         exitWithErrorCode INVALID_OPTION;
         ;;
    esac
  done

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
      --)
        shift;
        break;
        ;;
    esac
  done
}

## Main logic
## dry-wit hook
function main() {
  for e in $(env | grep -e '^SQ_DEFAULT_' | cut -d'=' -f1 | grep -v -e '_DEFAULT$' | grep -v -e '_DESCRIPTION'); do
    if [ -z "$(eval "echo \$${e#SQ_}")" ]; then
        logInfo -n "Restoring ${e} from SQ_${e}";
        export "${e#SQ_}"="$(eval "echo \$${e}")";
        cat <<EOF >> /etc/profile.d/99_restored_defaults.sh
export "${e#SQ_}"="$(eval "echo \$${e}")";
EOF
        logInfoResult SUCCESS "${e}";
    else
      logInfo -n "${e#SQ_} defined";
      logInfoResult SUCCESS "$(eval "echo \$${e#SQ_}")";
    fi
  done
}
