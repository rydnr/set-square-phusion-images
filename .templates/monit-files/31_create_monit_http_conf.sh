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
  checkReq tr;
}

## Defines the errors
## dry-wit hook
function defineErrors() {
  addError "INVALID_OPTION" "Unrecognized option";
  addError "CUT_NOT_INSTALLED" "cut is not installed";
  addError "GREP_NOT_INSTALLED" "grep not installed";
  addError "AWK_NOT_INSTALLED" "awk not installed";
  addError "IFCONFIG_NOT_INSTALLED" "ifconfig not installed";
  addError "TR_NOT_INSTALLED" "tr not installed";
  addError "CANNOT_RETRIEVE_INTERFACE_NAME" "Cannot retrieve the interface name";
  addError "CANNOT_RETRIEVE_SUBNET_16_FOR_IFACE" "Cannot retrieve the /16 subnet";
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
      --) shift;
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

## Retrieves the first network interface.
## <- RESULT: such interface name.
## Usage:
##   if retrieve_iface; then
##     echo "Interface candidate: ${RESULT}";
##   fi
function retrieve_iface() {
  local _result;
  local -i _rescode;

  logInfo -n "Finding out the name of the network interface";
  _result="$(ifconfig | cut -d' ' -f1 | grep -v -e '^$' | tr ' ' '\n' | grep -v -e '^docker' | grep -v -e '^lo$' | grep -v -e '^tun' | head -n 1)";
  _rescode=$?;
  if isTrue ${_rescode}; then
      logInfoResult SUCCESS "${_result}";
      export RESULT="${_result}";
  else
    logInfoResult FAILED "failed";
    exitWithErrorCode CANNOT_RETRIEVE_INTERFACE_NAME;
  fi

  return ${_rescode};
}

## Retrieves the /16 subnet of the eth0 interface.
## -> 1: The interface name.
## <- 0/${TRUE} if the subnet information is available; 1/${FALSE} otherwise.
## <- RESULT: the device where the root filesystem is stored.
## Usage:
##   if retrieve_subnet_16 "eth0"; then
##     echo "The /16 subnet for eth0 is ${RESULT}"
##   fi
function retrieve_subnet_16() {
  local _iface="${1}";
  local _result;

  checkNotEmpty "iface" "${_iface}" 1;

  logInfo -n "Finding out the /16 subnet for ${_iface}";
  _result="$(ifconfig ${_iface} | grep 'inet addr' | cut -d':' -f 2 | awk '{print $1;}' | awk -F'.' '{printf("%d.%d.%d.0/24\n", $1, $2, $3);}')";

  if isEmpty ${_result}; then
      logInfoResult FAILED "failed";
      exitWithErrorCode CANNOT_RETRIEVE_SUBNET_16_FOR_IFACE "${_iface}";
  else
    logInfoResult SUCCESS "${_result}";
    export RESULT="${_result}";
  fi
}

## Main logic
## dry-wit hook
function main() {
  local _iface;
  local _subnet;
  local _key;

  logDebug -n "Checking SSL certificate for monit";
  _key=$(find /etc/ssl/private/ -name 'monit-*.key');
  if isEmpty "${_key}"; then
      logDebugResult FAILURE "failed";
  fi

  if retrieve_iface; then
      _iface="${RESULT}";
      if retrieve_subnet_16 "${_iface}"; then
          _subnet="${RESULT}";

          logInfo -n "Creating Monit configuration for enabling web interface on port ${MONIT_HTTP_PORT}";
  cat <<EOF > ${MONIT_CONF_FILE}
set httpd port ${MONIT_HTTP_PORT} and
   use address 0.0.0.0
EOF
          if isNotEmpty "${_key}"; then
              cat <<EOF >> ${MONIT_CONF_FILE}
   SSL ENABLE
   PEMFILE ${_key}
EOF
          fi
          cat <<EOF >> ${MONIT_CONF_FILE}
   ALLOWSELFCERTIFICATION
   ALLOW ${_subnet}
   ALLOW ${MONIT_HTTP_USER}:"${MONIT_HTTP_PASSWORD}"

#check host local_monit with address 0.0.0.0
#   if failed port ${MONIT_HTTP_PORT} protocol http with timeout ${MONIT_HTTP_TIMEOUT} then alert
#   if failed url http://${MONIT_HTTP_USER}:${MONIT_HTTP_PASSWORD}@0.0.0.0:${MONIT_HTTP_PORT}/
#       then alert
EOF
          logInfoResult SUCCESS "done";
      fi
  fi
}
