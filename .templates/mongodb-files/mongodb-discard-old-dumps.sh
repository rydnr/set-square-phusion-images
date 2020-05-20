#!/bin/bash dry-wit
# Copyright 2017-today Automated Computing Machinery
# Licensed under GPLv3.
# mod: mongodb-discard-old-dumps.sh
# api: public
# txt: Deletes MongoDB dumps older than a certain number of days.

# fun: main
# api: public
# txt: Deletes MongoDB dumps older than a certain number of days.
# txt: Returns 0/TRUE always.
# use: main;
function main() {
  local _outputFolder="${MONGODB_DUMPS_FOLDER}";

  mkdir -p "${_outputFolder}";

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

defineEnvVar MONGODB_DUMPS_FOLDER OPTIONAL "The folder where the dumps are stored" "/backup/mongodb/dumps";
defineEnvVar MONGODB_DUMP_RETAIN_DAYS OPTIONAL "The number of days the dumps are retained" 7;
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
