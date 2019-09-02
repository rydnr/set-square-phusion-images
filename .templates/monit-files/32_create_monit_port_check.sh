#!/bin/bash dry-wit
# Copyright 2015-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3
# mod: monit/32_create_monit_port_check
# api: public
# txt: Creates Monit configuration to check the exposed ports are running correctly.

DW.import docker;

## Main logic
## dry-wit hook
function main() {
  local _ports="";
  local _oldIFS="${IFS}";
  local _d;
  local _port;

  echo 'check host localhost with address 0.0.0.0' > ${MONIT_CONF_FILE}

  IFS=$' ';
  for _d in ${DOCKERFILES_LOCATION}/*; do
    IFS="${_oldIFS}";
    if retrievePortsFromDockerfile "${_d}"; then
      _ports="${_ports} $(echo ${RESULT} | tr "\n" " ")";
    fi
  done
  IFS="${_oldIFS}";
  _ports=$(echo ${_ports} | tr " " "\n" | sort | uniq | tr "\n" " ");
  IFS=$' ';
  for _port in ${_ports}; do
    IFS="${_oldIFS}";
    logInfo -n "Creating Monit check for ${_port} port";
    cat <<EOF >> ${MONIT_CONF_FILE}
        if failed port ${_port} with timeout ${PORT_TIMEOUT} then alert
EOF
    logInfoResult SUCCESS "done";
  done
  IFS="${_oldIFS}";
}

## Script metadata and CLI options
setScriptDescription "Creates Monit configuration to check the exposed ports are running correctly";
checkReq tr;
checkReq sort;
checkReq uniq;
checkReq cat;
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
