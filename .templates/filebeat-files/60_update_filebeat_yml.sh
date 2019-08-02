#!/bin/bash dry-wit
# Copyright 2016-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3
# mod: filebeat/60_update_filebeat_yml
# api: public
# txt: Updates filebeat.yml configuration.

DW.import filebeat;

# fun: main
# api: public
# txt: Updates the openssl.cnf file to support certain log files.
# txt: Returns 0/TRUE always, unless an error is detected.
# use: main
function main() {
  local _ip;
  local _f;
  local _oldIFS="${IFS}";

  logInfo -n "Retrieving IP";
  if retrieveOwnIp; then
    _ip="${RESULT}";
    logInfoResult SUCCESS "${_ip}";

    IFS="${DWIFS}";
    for _f in "${LOG_FILES}"; do
      IFS="${_oldIFS}";
      logInfo -n "Configuring ${FILEBEAT_YML_FILE} to include ${_f}";
      if configureFilebeatToAddLogFileToForward "${_f}" "${FILEBEAT_YML_FILE}"; then
        logInfoResult SUCCESS "done";
      else
        logInfoResult FAILURE "failed";
        exitWithErrorCode ERROR_CONFIGURING_FILEBEAT;
      fi
    done
    IFS="${_oldIFS}";
  else
    logInfoResult FAILURE "failed";
    exitWithErrorCode CANNOT_RETRIEVE_OWN_IP;
  fi
}

## Script metadata and CLI options
setScriptDescription "Updates filebeat.yml configuration.";
addError CANNOT_RETRIEVE_OWN_IP "Cannot retrieve my own IP";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
