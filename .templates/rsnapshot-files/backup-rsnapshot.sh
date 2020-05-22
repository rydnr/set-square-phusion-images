#!/bin/bash dry-wit
# Copyright 2015-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3
# mod: rsnapshot/backup-rsnapshot.sh
# api: public
# txt: Copies the contents of a folder to a remote host.

export DW_DISABLE_ANSI_COLORS=TRUE;

# fun: main
# api: public
# txt: Copies the contents of a folder to a remote host.
# txt: Returns 0/TRUE always.
# use: main;
function main() {
  if    [[ -z "${DOBACKUP}" ]] \
     || [[ "${DOBACKUP}" != "true" ]]; then
    logDebug "Backup disabled";
  else
    ${BACKUP_FOLDER_SCRIPT} ${RSNAPSHOT_SOURCE_FOLDER} ${RSNAPSHOT_DESTINATION_FOLDER};
  fi
}

# Script metadata and CLI options.
setScriptDescription "Copies the contents of a folder to a remote host.";

addCommandLineParameter "source" "The source folder" EXPECTS_ARGUMENT;
addCommandLineParameter "destination" "The destination" EXPECTS_ARGUMENT;
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
