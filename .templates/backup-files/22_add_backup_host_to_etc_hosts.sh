#!/bin/bash dry-wit
# Copyright 2015-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3
# mod: backup/22_add_backup_host_to_etc_hosts
# api: public
# txt: Performs some tuning on rsync configuration, to avoid consuming too many resources.

# fun: main
# api: public
# txt: Performs some tuning on rsync configuration, to avoid consuming too many resources.
# txt: Returns 0/TRUE always, unless an error is thrown.
# use: main
function main() {
  logInfo -n "Updating RSYNC_NICE in ${RSYNC_CONF}";
  sed -i -e "s/^#\?\s*RSYNC_NICE=.*/RSYNC_NICE='${RSYNC_NICE}'/g" ${RSYNC_CONF};
  if isTrue $?; then
    logInfoResult SUCCESS "done";
  else
    logInfoResult FAILURE "failed";
    exitWithErrorCode CANNOT_REPLACE_RSYNC_NICE_IN_RSYNC_CONF "${RSYNC_CONF}";
  fi

  logInfo -n "Updating RSYNC_IONICE in ${RSYNC_CONF}";
  sed -i -e "s/^#\?\s*RSYNC_IONICE=.*/RSYNC_IONICE='${RSYNC_IONICE}'" ${RSYNC_CONF};
  if isTrue $?; then
    logInfoResult SUCCESS "done";
  else
    logInfoResult FAILURE "failed";
    exitWithErrorCode CANNOT_REPLACE_RSYNC_IONICE_IN_RSYNC_CONF "${RSYNC_CONF}";
  fi
}

## Script metadata and CLI options
setScriptDescription "Performs some tuning on rsync configuration, to avoid consuming too many resources.";
addError CANNOT_REPLACE_RSYNC_NICE_IN_RSYNC_CONF "Could not replace RSYNC_NICE in ";
addError CANNOT_REPLACE_RSYNC_IONICE_IN_RSYNC_CONF "Could not replace RSYNC_IONICE in ";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
