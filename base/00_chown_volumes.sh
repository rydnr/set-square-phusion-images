#!/bin/bash dry-wit
# Copyright 2015-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3

function usage() {
cat <<EOF
$SCRIPT_NAME
$SCRIPT_NAME [-h|--help]
(c) 2016-today Automated Computing Machinery S.L.
    Distributed under the terms of the GNU General Public License v3

Changes the ownership of all declared volumes.

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

## Changes the ownership of a Docker volume.
## -> 1: The user.
## -> 2: The group.
## -> 3: The volume folder.
## Example:
##   chown_volume mysql mysql /var/lib/mysql
function chown_volume() {
  local _user="${1}";
  local _group="${2}";
  local _volume="${3}";
  local _single=0;
  if [ "${_volume#[}" == "${_volume}" ]; then
    _single=0; # true, single
  else
    _single=1; # false, multiple
  fi
  if [ ${_single} -eq 0 ]; then
    chown -R ${_user}:${_group} "${_aux}";
  else
    local _oldIFS="${IFS}";
    IFS='"';
    for item in $(echo ${_aux} | tr -d '[],'); do
      IFS="${_oldIFS}";
      chown -R ${_user}:${_group} "${item}";
    done
  fi
}

## Processes the volumes from a given Dockerfile.
## -> 1: the user.
## -> 2: the group.
## -> 3: the Dockerfile.
## Example:
##   process_volumes mysql mysql /Dockerfiles/Dockerfile
function process_volumes() {
  local _user="${1}";
  local _group="${2}";
  local _dockerfile="${3}";
  local _aux;
  local _single;
  grep -e '^\s*VOLUME\s' "${_dockerfile}" > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    local _oldIFS="${IFS}";
    IFS=$'\n';
    for _aux in $(grep -e '^\s*VOLUME\s' "${_dockerfile}" 2> /dev/null | cut -d' ' -f 2- | sed -e 's/^ \+//g'); do
      IFS="${_oldIFS}";
      logInfo -n "Changing the ownership of ${_aux} to ${_user}/${_group} (from ${DOCKERFILES_LOCATION}/${p})";
      chown_volume "${_user}" "${_group}" "${_aux}";
      logInfoResult SUCCESS "done";
    done
  fi
}

## Main logic
## dry-wit hook
function main() {
  local _user="${SERVICE_USER}";
  if [ -z ${SERVICE_USER} ]; then
    logInfo "SERVICE_USER environment variable not found. Assuming root.";
    _user="root";
  fi
  local _group="${SERVICE_GROUP}";
  if [ -z ${SERVICE_GROUP} ]; then
    logInfo "SERVICE_GROUP environment variable not found. Assuming ${_user}.";
    _group="${_user}";
  fi
  for p in $(ls ${DOCKERFILES_LOCATION} | grep -v -e '^Dockerfile'); do
    process_volumes "${_user}" "${_group}" "${DOCKERFILES_LOCATION}/${p}";
  done
}
