#!/bin/bash dry-wit
# Copyright 2015-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3
# mod: backup/backup-folder
# api: public
# txt: Copies the contents of a folder to a remote host, using SSH.

## Main logic
## dry-wit hook
function main() {
  local -i _success;
  local _hostname="$(hostname)";

  if  isFalse "${DOBACKUP}"; then
    logDebug "Backup disabled";
  else
    if startsWith "${_hostname}" "${SQ_IMAGE}"; then
      _hostname="${SQ_IMAGE}";
    fi
    logInfo "Transferring ${SOURCE%/} to ${SQ_IMAGE}${SQ_BACKUP_HOST_SUFFIX}:${DESTINATION}";
    rsync ${RSYNC_OPTIONS} -e "ssh -p ${SQ_BACKUP_HOST_SSH_PORT} ${SSH_OPTIONS}" ${SOURCE%/}/ ${SQ_BACKUP_USER}@${_hostname}${SQ_BACKUP_HOST_SUFFIX}:${DESTINATION%/}/
    _success=$?;
    logInfo -n "Transferring ${SOURCE%/} to ${SQ_IMAGE}${SQ_BACKUP_HOST_SUFFIX}:${DESTINATION}";
    if isTrue ${_success}; then
      logInfoResult SUCCESS "done";
    else
      logInfoResult FAILURE "failed";
      exitWithErrorCode ERROR_TRANSMITTING_DATA;
    fi
  fi
}

## Script metadata and CLI options
setScriptDescription "Copies the contents of a folder to a remote host, via SSH.";
addError ERROR_TRANSMITTING_DATA "Error transmitting data from ${SOURCE} to ${SQ_IMAGE}${SQ_BACKUP_HOST_SUFFIX}:${DESTINATION}";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
