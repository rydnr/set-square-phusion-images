#!/bin/bash dry-wit
# Copyright 2015-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3

function usage() {
cat <<EOF
$SCRIPT_NAME
$SCRIPT_NAME [-h|--help]
(c) 2015-today Automated Computing Machinery S.L.
    Distributed under the terms of the GNU General Public License v3

Creates Monit configuration to check the exposed ports are running correctly.

Common flags:
    * -h | --help: Display this message.
    * -v: Increase the verbosity.
    * -vv: Increase the verbosity further.
    * -q | --quiet: Be silent.
EOF
}

## Defines the requirements
## dry-wit hook
function defineReq() {
  checkReq cut;
  checkReq sed;
  checkReq grep;
}

## Defines the errors
## dry-wit hook
function defineErrors() {
  addError "INVALID_OPTION" "Unrecognized option";
  addError "CUT_NOT_INSTALLED" "cut is not installed";
  addError "SED_NOT_INSTALLED" "sed is not installed";
  addError "GREP_NOT_INSTALLED" "grep is not installed";
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
        -h | --help | -v | -vv | -q | --quiet)
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
      -h | --help | -v | -vv | -q | --quiet)
         shift;
         ;;
      --)
        shift;
        break;
        ;;
    esac
  done
}

## Retrieves the exposed ports in given Dockerfile.
## -> 1: the dockerfile
## <- RESULT: the space-separated list of ports exposed in the Dockerfile.
## Usage:
##   retrieve_exposed_ports /Dockerfiles/Dockerfile;
##   echo "Exposed ports in the Dockerfile: ${RESULT}"
function extract_ports() {
  local _dockerfile="${1}";
  local _result=();
  local _aux;
  local _single;

  checkNotEmpty "dockerfile" "${_dockerfile}" 1;

  local _oldIFS="${IFS}";
  IFS=$'\n';
  for _aux in $(grep EXPOSE "${_dockerfile}" | cut -d' ' -f 2- | sed -e 's/^ \+//g'); do
    IFS=$' ';
    for p in ${_aux}; do
      IFS="${_oldIFS}";
      if ! arrayContainsElement "${p}" "${_result[@]}"; then
        _result[${#_result[@]}]="${p}";
      fi
    done
  done

  export RESULT=${_result[@]};
}

## Main logic
## dry-wit hook
function main() {
  local _ports="";
  local _oldIFS="${IFS}";

  echo 'check host localhost with address 0.0.0.0' > ${MONIT_CONF_FILE}

  IFS=$' ';
  for d in ${DOCKERFILES_LOCATION}/*; do
    IFS="${_oldIFS}";
    extract_ports "${d}";
    _ports="${_ports} $(echo ${RESULT} | tr "\n" " ")";
  done
  _ports=$(echo ${_ports} | tr " " "\n" | sort | uniq | tr "\n" " ");
  IFS=$' ';
  for _port in ${_ports}; do
    IFS="${_oldIFS}";
    logInfo -n "Creating Monit check for ${_port} port (exposed in ${d})";
    cat <<EOF >> ${MONIT_CONF_FILE}
        if failed port ${_port} with timeout ${PORT_TIMEOUT} then alert
EOF
    logInfoResult SUCCESS "done";
  done
}
