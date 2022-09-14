#!/usr/bin/env dry-wit
# Copyright 2016-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3
# mod: logstash
# api: public
# txt: Generates a logstash-forwarder.crt SSL certificate.

DW.import net

# fun: main
# api: public
# txt: Updates the openssl.cnf file to add the IP address.
# txt: Returns 0/TRUE always, unless some error occurs.
# use: main
function main() {
  local _iface
  local _ip

  logInfo -n "Retrieving interface name"
  if retrieveOwnIp; then
    _ip="${RESULT}"
    logInfoResult SUCCESS "${_ip}"

    logInfo -n "Updating ${OPENSSL_CNF_FILE}"
    if add_ip_to_openssl_cnf "${OPENSSL_CNF_FILE}" "${_ip}"; then
      logInfoResult SUCCESS "done"

      logInfo -n "Generating ${LOGSTASH_FORWARDER_CRT_FILE}"
      if generate_logstash_forwarder_crt_file \
        "${OPENSSL_CNF_FILE}" \
        "${LOGSTASH_FORWARDER_CRT_FILE}" \
        "${LOGSTASH_FORWARDER_PRIVATE_KEY}" \
        "${LOGSTASH_FORWARDER_VALIDITY_DAYS}" \
        "${LOGSTASH_FORWARDER_KEY_ALGORITHM}" \
        "${LOGSTASH_FORWARDER_KEY_LENGTH}"; then
        logInfoResult SUCCESS "done"
      else
        logInfoResult FAILURE "failed"
        exitWithErrorCode CANNOT_GENERATE_LOGSTASH_FORWARDER_CRT_FILE
      fi
    else
      logInfoResult FAILURE "failed"
      exitWithErrorCode CANNOT_UPDATE_OPENSSL_CNF "${OPENSSL_CNF_FILE}"
    fi
  else
    logInfoResult FAILURE "failed"
    exitWithErrorCode CANNOT_FIND_OUT_MY_OWN_IP
  fi
}

# fun: add_ip_to_openssl_cnf
# api: public
# txt: Adds the IP to the openssl.cnf file.
# opt: file: The openssl.cnf file.
# opt: ip: The IP to add.
# txt: Returns 0/TRUE if the file is updated successfully; 1/FALSE otherwise.
# use: if add_ip_to_openssl_cnf "/etc/ssl/openssl.cnf" "${IP}"; then echo "${IP} added to /etc/ssl/openssl.cnf"; fi
function add_ip_to_openssl_cnf() {
  local _opensslCnf="${1}"
  local _ip="${2}"
  local -i _rescode

  checkNotEmpty file "${_opensslCnf}" 1
  checkNotEmpty ip "${_ip}" 2

  sed "/\[ v3_ca \]/a subjectAltName = IP: ${_ip}" "${_opensslCnf}" >/dev/null 2>&1
  _rescode=$?

  return ${_rescode}
}

# fun: generate_logstash_forwarder_crt_file
# api: public
# txt: Generates the logstash-forwarder.crt file.
# opt: input: The openssl.cnf input file.
# opt: outputCrt: The logstash-forwarder.crt file to generate.
# opt: outputKey: The private key to generate.
# opt: valitidy: The validity in days.
# opt: keyAlgorithm: The key algorithm.
# opt: keyLength: The key length.
# txt: Returns 0/TRUE if the certificate gets generated successfully; 1/FALSE otherwise.
# use:  if generate_logstash_forwarder_crt_file /etc/ssl/openssl.cnf /etc/pki/tls/certs/logstash-forwarder.crt /etc/ssl/private/logstash-forwarder.key 3650 rsa 2048; then
#     echo "logstash-forwarder.crt generated successfully";
#   fi
function generate_logstash_forwarder_crt_file() {
  local _input="${1}"
  local _outputCrt="${2}"
  local _outputKey="${3}"
  local _validity="${4}"
  local _keyAlgorithm="${5}"
  local _keyLength="${6}"
  local -i _rescode

  checkNotEmpty "input" "${_input}" 1
  checkNotEmpty "certificate" "${_outputCrt}" 2
  checkNotEmpty "privateKey" "${_outputKey}" 3
  checkNotEmpty "validity" "${_validity}" 4
  checkNotEmpty "keyAlgorithm" "${_keyAlgorithm}" 5
  checkNotEmpty "keyLength" "${_keyLength}" 6

  mkdir -p $(dirname ${_outputCrt})
  mkdir -p $(dirname ${_outputKey})

  openssl req -config "${_input}" -x509 -days "${_validity}" -batch -nodes -newkey ${_keyAlgorithm}:${_keyLength} -keyout "${_outputKey}" -out "${_outputCrt}" >/dev/null 2>&1
  _rescode=$?

  return ${_rescode}
}

## Script metadata and CLI options
setScriptDescription "Generates a logstash-forwarder.crt SSL certificate"
checkReq openssl
checkReq grep
checkReq cut

addError CANNOT_FIND_OUT_INTERFACE_NAME "Cannot find out the network interface name"
addError CANNOT_FIND_OUT_MY_OWN_IP "Cannot find out my own IP"
addError CANNOT_UPDATE_OPENSSL_CNF "Cannot update openssl.cnf"
addError CANNOT_GENERATE_LOGSTASH_FORWARDER_CRT_FILE "Cannot generate logstash-forwarder.crt"
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
