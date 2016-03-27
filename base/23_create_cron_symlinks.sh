#!/bin/bash dry-wit
# Copyright 2015-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3

function usage() {
cat <<EOF
$SCRIPT_NAME
$SCRIPT_NAME [-h|--help]
(c) 2015-today Automated Computing Machinery S.L.
    Distributed under the terms of the GNU General Public License v3

Creates symlinks for all cron jobs under /usr/local/bin folder.

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

  ERROR_MESSAGES=(\
    INVALID_OPTION \
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

## Checks whether backups are enabled as a whole.
## <- RESULT: 0 if so, 1 otherwise.
## Example:
##   is_backup_enabled -> false
##   # assuming the environment variable is DOBACKUP
##   export DOBACKUP=0; is_backup_enabled -> true
function is_backup_enabled() {
  local _result;
  _evalVar "${ENABLE_BACKUP_ENVIRONMENT_VARIABLE}";
  local _dobackup="${RESULT}";
  if [ -z ${_dobackup+x} ]; then
    _result=0;
  else
    result=1;
  fi
  return ${_result};
}

## Main logic
## dry-wit hook
function main() {
  if is_backup_enabled; then
    for period in hourly daily weekly monthly; do
      logInfo -n "Enabling ${period} cron jobs";
      for f in /usr/local/bin/backup*.${period}; do
        ln -s ${f} /etc/cron.${period}/$(basename $f);
      done
      logInfoResult SUCCESS "done";
    done
  else
    logInfo "Backup disabled for this image.";
  fi
}
