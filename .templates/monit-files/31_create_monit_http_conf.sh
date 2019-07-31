#!/bin/bash dry-wit
# Copyright 2015-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3
# mod: monit/31_create_monit_http_conf
# api: public
# txt: Creates Monit configuration to enable the web interface.

DW.import net;

# fun: main
# api: public
# txt: Creates Monit configuration to enable the web interface.
# txt: Returns 0/TRUE always.
# use: main
function main() {
  local _iface;
  local _subnet;
  local _key;

  logDebug -n "Checking SSL certificate for monit";
  _key=$(find /etc/ssl/private/ -name 'monit-*.key');
  if isEmpty "${_key}"; then
    logDebugResult FAILURE "failed";
  else
    logDebugResult SUCCESS "${_key}";
  fi

  if retrieveIface; then
    _iface="${RESULT}";
    if retrieveSubnet24 "${_iface}"; then
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
    else
      exitWithErrorCode CANNOT_RETRIEVE_SUBNET_24_FOR_IFACE "${_iface}";
    fi
  else
    exitWithErrorCode CANNOT_RETRIEVE_INTERFACE_NAME;
  fi
}

## Script metadata and CLI options
setScriptDescription "Creates Monit configuration to enable the web interface";
addError CANNOT_RETRIEVE_INTERFACE_NAME "Cannot retrieve the interface name";
addError CANNOT_RETRIEVE_SUBNET_24_FOR_IFACE "Cannot retrieve the /24 subnet";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
