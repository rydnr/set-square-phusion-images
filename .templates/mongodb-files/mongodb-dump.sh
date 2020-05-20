#!/bin/bash dry-wit
# Copyright 2017-today Automated Computing Machinery
# Licensed under GPLv3.
# mod: mongodb-dump.sh
# api: public
# txt: Performs dumps of the MongoDB database.

DW.import mongodb;

# fun: main
# api: public
# txt: Performs dumps of the MongoDB database.
# txt: Returns 0/TRUE always.
# use: main;
function main() {
  local _outputFolder="${MONGODB_DUMP_FOLDER}";
  local _dumpFile="${_outputFolder}/dump-$(date '+%Y%m%d.%H%M').gz";

  mkdir -p "${_outputFolder}" > /dev/null;

  logInfo -n "Dumping MongoDB database on localhost to ${_dumpFile}";

  if mongoDump "${_dumpFile}" "${MONGODB_HOST}" "${MONGODB_USER}" "${MONGODB_PASSWORD}" "${MONGODB_AUTHENTICATION_DATABASE}" "${MONGODB_AUTHENTICATION_MECHANISM}"; then
    logInfoResult SUCCESS "done";
  else
    logInfoResult FAILURE "failed";
    logInfo "${ERROR}";
  fi
}

setScriptDescription "Performs dumps of the MongoDB database.";
defineEnvVar MONGODB_DUMP_FOLDER OPTIONAL "The folder storing the generated dump file" "/backup/mongodb/dumps";
defineEnvVar MONGODB_HOST OPTIONAL "The MongoDB host" "localhost";
defineEnvVar MONGODB_USER OPTIONAL "The MongoDB user";
defineEnvVar MONGODB_PASSWORD OPTIONAL "The password of the MongoDB user";
defineEnvVar MONGODB_AUTHENTICATION_DATABASE OPTIONAL "The authentication database" "admin";
defineEnvVar MONGODB_AUTHENTICATION_MECHANISM "The authentication mechanism" "SCRAM-SHA-256";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
