#!/bin/env dry-wit
# Copyright 2015-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3

function usage() {
cat <<EOF
$SCRIPT_NAME
$SCRIPT_NAME [-h|--help]
(c) 2016-today Automated Computing Machinery S.L.
    Distributed under the terms of the GNU General Public License v3

Creates Padlock virtual host configuration for Apache.

Common flags:
    * -h | --help: Display this message.
    * -X:e | --X:eval-defaults: whether to eval all default values, which potentially slows down the script unnecessarily.
    * -v: Increase the verbosity.
    * -vv: Increase the verbosity further.
    * -q | --quiet: Be silent.
EOF
}

## Defines the requirements
## dry-wit hook
function defineReq() {
  checkReq "process-file.sh" PROCESSFILE_NOT_INSTALLED;
}

## Defines the errors
## dry-wit hook
function defineErrors() {
  addError "INVALID_OPTION" "Unrecognized option";
  addError "PROCESSFILE_NOT_INSTALLED" "process-file.sh is not installed";

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
      -h | --help | -v | -vv | -q | -X:e | --X:eval-defaults)
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
      -h | --help | -v | -vv | -q | -X:e | --X:eval-defaults)
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

  if isEmpty "${PADLOCK_DOMAIN}"; then
      export PADLOCK_DOMAIN="${SQ_PADLOCK_DOMAIN}";
  fi

  if isEmpty "${PADLOCK_VIRTUALHOST}"; then
      export PADLOCK_VIRTUALHOST="${SQ_PADLOCK_VIRTUALHOST}";
  fi

  process-file.sh -o ${PADLOCK_APACHE_VHOST_FILE} ${PADLOCK_APACHE_VHOST_TEMPLATE_FILE}

  a2ensite $(basename ${PADLOCK_APACHE_VHOST_FILE} .conf);
}
