#!/bin/bash dry-wit
# Copyright 2017-today Automated Computing Machinery
# Licensed under GPLv3.
# mod: mongodb/mongodb-discard-old-dumps.sh
# api: public
# txt: Deletes MongoDB dumps older than a certain number of days.

export DW_DISABLE_ANSI_COLORS=TRUE;

# fun: main
# api: public
# txt: Deletes MongoDB dumps older than a certain number of days.
# txt: Returns 0/TRUE always.
# use: main;
function main() {
  local _outputFolder="${MONGODB_DUMPS_FOLDER}";
  mkdir -p "${_outputFolder}";

  DW.getScriptName;
  local _scriptName="$(basename ${RESULT})";

  exec > >(sudo tee "${MONGODB_LOG_FOLDER}"/"${_scriptName}".log | sudo sh -c "logger -t \"${_scriptName}\" -s 2>/dev/console") 2>&1;

  logInfo -n "Deleting MongoDB dumps older than ${MONGODB_DUMP_RETAIN_DAYS} days in ${_outputFolder}";
  find "${_outputFolder}" -daystart -mtime +${MONGODB_DUMP_RETAIN_DAYS} -exec rm -f {} \;
  if isTrue $?; then
    logInfoResult SUCCESS "done";
  else
    logInfoResult FAILURE "failed";
  fi
}

# script metadata
setScriptDescription "Deletes MongoDB dumps older than a certain number of days.";

# env: MONGODB_DUMPS_FOLDER: The folder where the dumps are stored. Defaults to /backup/mongodb/dumps.
defineEnvVar MONGODB_DUMPS_FOLDER OPTIONAL "The folder where the dumps are stored" "/backup/mongodb/dumps";
# env: MONGODB_DUMP_RETAIN_DAYS: The number of days the dumps are retained. Defaults to 7.
defineEnvVar MONGODB_DUMP_RETAIN_DAYS OPTIONAL "The number of days the dumps are retained" 7;
# env: MONGODB_LOG_FOLDER The MongoDB log folder. Defaults to /var/log/mongodb.
defineEnvVar MONGODB_LOG_FOLDER OPTIONAL "The MongoDB log folder" "/var/log/mongodb";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
