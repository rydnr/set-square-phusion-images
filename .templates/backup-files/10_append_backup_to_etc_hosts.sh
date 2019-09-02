#!/bin/bash dry-wit
# Copyright 2015-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3
# mod: backup/10_append_backup_to_etc_hosts
# api: public
# txt: Appends the information about the backup server to /etc/hosts.

# fun: main
# api: public
# txt: Appends the information about the backup server to /etc/hosts.
# txt: Returns 0/TRUE always.
# use: main
function main() {
  logInfo -n "Appending ${BACKUP_HOST} to /etc/hosts";
  echo "${BACKUP_HOST} backup" >> /etc/hosts
  if isTrue $?; then
    logInfoResult SUCCESS "done";
  else
    logInfoResult FAILED "failed";
    exitWithErrorCode CANNOT_WRITE_TO_ETC_HOSTS;
  fi
}
## Script metadata and CLI options
setScriptDescription "Appends the information about the backup server to /etc/hosts.";
addError CANNOT_WRITE_TO_ETC_HOSTS "Could not write to /etc/hosts";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
