#!/bin/bash dry-wit
# Copyright 2017-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3

function usage() {
cat <<EOF
$SCRIPT_NAME
$SCRIPT_NAME [-h|--help]
(c) 2017-today Automated Computing Machinery S.L.
    Distributed under the terms of the GNU General Public License v3

Copies the latest changes in Jenkins configurations so that they survive restarts.

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
  addError INVALID_OPTION "Unrecognized option";
  addError TOOL_IS_MANDATORY "Tool is mandatory";
  addError UNSUPPORTED_TOOL "Only gradle, groovy, grails, maven and ant are supported. Unsupported ";
  addError JENKINS_HOME_IS_UNDEFINED "JENKINS_HOME environment variable is undefined";
  addError BACKUP_FOLDER_IS_UNDEFINED "BACKUP_FOLDER environment variable is undefined";
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

  if isEmpty "${JENKINS_HOME}"; then
    logDebugResult FAILURE "failed";
    exitWithErrorCode JENKINS_HOME_IS_UNDEFINED;
  fi

  if isEmpty "${BACKUP_FOLDER}"; then
      logDebugResult FAILURE "failed";
      exitWithErrorCode BACKUP_FOLDER_IS_UNDEFINED;
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

  rsync -az --exclude '.sdkman/*' ${JENKINS_HOME}/ ${BACKUP_FOLDER}/
}
