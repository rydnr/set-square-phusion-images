#!/bin/bash dry-wit
# Copyright 2016-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3

function usage() {
cat <<EOF
$SCRIPT_NAME
$SCRIPT_NAME [-h|--help]
(c) 2015-today Automated Computing Machinery S.L.
    Distributed under the terms of the GNU General Public License v3

Generates a logstash-forwarder.crt SSL certificate.

Common flags:
    * -h | --help: Display this message.
    * -v: Increase the verbosity.
    * -vv: Increase the verbosity further.
    * -q | --quiet: Be silent.
EOF
}

## Defines required dependencies
## dry-wit hook
function defineReq() {
  checkReq openssl OPENSSL_NOT_AVAILABLE;
  checkReq ifconfig IFCONFIG_NOT_AVAILABLE;
  checkReq grep GREP_NOT_AVAILABLE;
  checkReq cut CUT_NOT_AVAILABLE;
}

## Defines the errors
## dry-wit hook
function defineErrors() {
  addError "INVALID_OPTION" "Unrecognized option";
  addError "OPENSSL_NOT_AVAILABLE" "openssl is not installed";
  addError "IFCONFIG_NOT_AVAILABLE" "ifconfig is not installed";
  addError "GREP_NOT_AVAILABLE" "grep is not available";
  addError "CUT_NOT_AVAILABLE" "cut is not available";
  addError "CANNOT_RETRIEVE_OWN_IP" "Cannot retrieve my own IP";
  addError "CANNOT_UPDATE_OPENSSL_CNF" "Cannot update openssl.cnf";
  addError "CANNOT_GENERATE_LOGSTASH_FORWARDER_CRT_FILE" "Cannot generate logstash-forwarder.crt";
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

## Retrieves the IP.
## <- 0/${TRUE} if the IP is up; 1/${FALSE} otherwise.
## <- RESULT: The IP.
## Example:
##   if retrieve_ip; then
##     echo "IP: ${RESULT}";
##   fi
function retrieve_ip() {
  local -i _rescode;
  local _result;
  local _iface="$(ifconfig | grep ' Link'  | grep -v docker | grep -v lo | grep -v tun | grep -v veth | awk '{print $1}')";

  _result="$(ifconfig ${_iface} | grep 'inet addr:' | grep -v '127.0.0.1' | cut -d ':' -f 2 | cut -d' ' -f 1)";
  _rescode=$?;

  if isTrue ${_rescode}; then
      export RESULT=${_result};
  fi

  return ${_rescode};
}

## Adds the IP to the openssl.cnf file.
## -> 1: The openssl.cnf file.
## <- 0/${TRUE} if the file is updated successfully; 1/${FALSE} otherwise.
## Example:
##   if add_ip_to_openssl_cnf "/etc/ssl/openssl.cnf" "${IP}"; then
##     echo "${IP} added to /etc/ssl/openssl.cnf";
##   fi
function add_ip_to_openssl_cnf() {
  local _opensslCnf="${1}";
  local _ip="${2}";
  local -i _rescode;

  checkNotEmpty "opensslCnf" "${_opensslCnf}" 1;
  checkNotEmpty "ip" "${_ip}" 2;

  sed "/\[ v3_ca \]/a subjectAltName = IP: ${_ip}" "${_opensslCnf}" > /dev/null 2>&1;
  _rescode=$?;

  return ${_rescode};
}

## Generates the logstash-forwarder.crt file.
## -> 1: The openssl.cnf input file.
## -> 2: The logstash-forwarder.crt file to generate.
## -> 3: The private key to generate.
## -> 4: The validity in days.
## -> 5: The key algorithm.
## -> 6: The key length.
## <- 0/${TRUE} if the certificate gets generated successfully; 1/${FALSE} otherwise.
## Example:
##   if generate_logstash_forwarder_crt_file /etc/ssl/openssl.cnf /etc/pki/tls/certs/logstash-forwarder.crt /etc/ssl/private/logstash-forwarder.key 3650 rsa 2048; then
##     echo "logstash-forwarder.crt generated successfully";
##   fi
function generate_logstash_forwarder_crt_file() {
  local _input="${1}";
  local _outputCrt="${2}";
  local _outputKey="${3}";
  local _validity="${4}";
  local _keyAlgorithm="${5}";
  local _keyLength="${6}";
  local -i _rescode;

  checkNotEmpty "input" "${_input}" 1;
  checkNotEmpty "certificate" "${_outputCrt}" 2;
  checkNotEmpty "privateKey" "${_outputKey}" 3;
  checkNotEmpty "validity" "${_validity}" 4;
  checkNotEmpty "keyAlgorithm" "${_keyAlgorithm}" 5;
  checkNotEmpty "keyLength" "${_keyLength}" 6;

  mkdir -p $(dirname ${_outputCrt});
  mkdir -p $(dirname ${_outputKey});

  openssl req -config "${_input}" -x509 -days "${_validity}" -batch -nodes -newkey ${_keyAlgorithm}:${_keyLength} -keyout "${_outputKey}" -out "${_outputCrt}" > /dev/null 2>&1;
  _rescode=$?;

  return ${_rescode};
}

## Updates the openssl.cnf file to add the
## Main logic
## dry-wit hook
function main() {
  local _ip;

  logInfo -n "Retrieving IP";
  if retrieve_ip; then
      _ip="${RESULT}";
      logInfoResult SUCCESS "${_ip}";

      logInfo -n "Updating ${OPENSSL_CNF_FILE}";
      if add_ip_to_openssl_cnf "${OPENSSL_CNF_FILE}" "${_ip}"; then
          logInfoResult SUCCESS "done";

          logInfo -n "Generating ${LOGSTASH_FORWARDER_CRT_FILE}";
          if generate_logstash_forwarder_crt_file \
                 "${OPENSSL_CNF_FILE}" \
                 "${LOGSTASH_FORWARDER_CRT_FILE}" \
                 "${LOGSTASH_FORWARDER_PRIVATE_KEY}" \
                 "${LOGSTASH_FORWARDER_VALIDITY_DAYS}" \
                 "${LOGSTASH_FORWARDER_KEY_ALGORITHM}" \
                 "${LOGSTASH_FORWARDER_KEY_LENGTH}"; then
              logInfoResult SUCCESS "done";
          else
            logInfoResult FAILURE "failed";
            exitWithErrorCode CANNOT_GENERATE_LOGSTASH_FORWARDER_CRT_FILE;
          fi
      else
        logInfoResult FAILURE "failed";
        exitWithErrorCode CANNOT_UPDATE_OPENSSL_CNF "${OPENSSL_CNF_FILE}";
      fi
  else
    logInfoResult FAILURE "failed";
    exitWithErrorCode CANNOT_RETRIEVE_OWN_IP;
  fi
}


