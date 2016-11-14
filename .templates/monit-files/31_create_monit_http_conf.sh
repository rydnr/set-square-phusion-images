#!/bin/bash dry-wit
# Copyright 2015-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3

function usage() {
cat <<EOF
$SCRIPT_NAME
$SCRIPT_NAME [-h|--help]
(c) 2015-today Automated Computing Machinery S.L.
    Distributed under the terms of the GNU General Public License v3

Creates Monit configuration to enable the web interface.

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
  checkReq cut;
  checkReq grep;
  checkReq awk;
  checkReq ifconfig;
}

## Defines the errors
## dry-wit hook
function defineErrors() {
  addError "INVALID_OPTION" "Unrecognized option";
  addError "CUT_NOT_INSTALLED" "cut is not installed";
  addError "GREP_NOT_INSTALLED" "grep not installed";
  addError "AWK_NOT_INSTALLED" "awk not installed";
  addError "IFCONFIG_NOT_INSTALLED" "ifconfig not installed";
  addError "CANNOT_RETRIEVE_SUBNET_16_FOR_ETH0" "Cannot retrieve the /16 subnet for eth0";
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
    esac
  done
}

## Retrieves the /16 subnet of the eth0 interface.
## <- RESULT: the device where the root filesystem is stored.
## Usage:
##   retrieve_eth0_subnet_16;
##   echo "The /16 subnet for eth0 is ${RESULT}"
function retrieve_eth0_subnet_16() {
  local _result;
  logInfo -n "Finding out the /16 subnet for eth0";
  _result="$(ifconfig eth0 | grep 'inet addr' | cut -d':' -f 2 | awk '{print $1;}' | awk -F'.' '{printf("%d.%d.%d.0/24\n", $1, $2, $3);}')";
  if [[ -n ${_result} ]]; then
    logInfoResult SUCCESS "${_result}";
    export RESULT="${_result}";
  else
    logInfoResult FAILED "failed";
    exitWithErrorCode CANNOT_RETRIEVE_SUBNET_16_FOR_ETH0;
  fi
}

## Main logic
## dry-wit hook
function main() {
  local _subnet;
  retrieve_eth0_subnet_16;
  _subnet="${RESULT}";

  logInfo -n "Creating monit configuration for enabling web interface on port ${MONIT_HTTP_PORT}";
  cat <<EOF > ${MONIT_CONF_FILE}
set httpd port ${MONIT_HTTP_PORT} and
   use address 0.0.0.0
   SSL ENABLE
   PEMFILE /etc/ssl/private/monit-${SQ_IMAGE}-${SQ_TAG}.pem
   allow localhost
   allow ${_subnet}
   allow ${MONIT_HTTP_USER}:"${MONIT_HTTP_PASSWORD}"

#check host local_monit with address 0.0.0.0
#   if failed port ${MONIT_HTTP_PORT} protocol http with timeout ${MONIT_HTTP_TIMEOUT} then alert
#   if failed url http://${MONIT_HTTP_USER}:${MONIT_HTTP_PASSWORD}@0.0.0.0:${MONIT_HTTP_PORT}/
#       then alert
EOF
  logInfoResult SUCCESS "done";
}
