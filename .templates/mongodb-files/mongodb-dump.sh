#!/bin/bash dry-wit
# Copyright 2017-today Automated Computing Machinery
# Licensed under GPLv3.
# mod: mongodb-dump.sh
# api: public
# txt: Performs regular dumps of the MongoDB database.

# fun: main
# api: public
# txt: Performs regular dumps of the MongoDB database.
# txt: Returns 0/TRUE always.
function main() {
  local _outputFolder="${MONGODB_DUMPS_FOLDER}";
  build_name_of_current_dump;
  mkdir -p "${_outputFolder}" > /dev/null;

  DW.import mongodb;

  logInfo -n "Dumping MongoDB database on localhost to ${_dumpFile}";

  local _dumpFile="${_outputFolder}/${RESULT}";
  if mongoDump "${_dumpFile}" "${MONGODB_HOST}" "${MONGODB_USER}" "${MONGODB_PASSWORD}" "${MONGODB_AUTHENTICATION_DATABASE}" "${MONGODB_AUTHENTICATION_MECHANISM}"; then
    logInfoResult SUCCESS "done";
  else
    logInfoResult FAILURE "failed";
  fi
}

# fun: build_name_of_current_dump
# api: public
# txt: Builds the name of the current dump file.
# txt: Returns 0/TRUE always.
# txt: The variable RESULT contains the file name.
# use: build_name_of_current_dump; echo "Dump file: ${RESULT}";
function build_name_of_current_dump() {
  export RESULT="dump-$(date '+%Y%m%d.%H%M').gz";
}

# script metadata
setScriptDescription "Performs regular dumps of the MongoDB database.";

defineEnvVar MONGODB_DUMPS_FOLDER OPTIONAL "The folder where the dumps are stored" "/backup/mongodb/db/dumps";
defineEnvVar MONGODB_HOST OPTIONAL "The MongoDB host" "localhost";
defineEnvVar MONGODB_USER OPTIONAL "The MongoDB user" "";
defineEnvVar MONGODB_PASSWORD OPTIONAL 'The MongoDB password for ${MONGODB_USER}' "";
defineEnvVar MONGODB_AUTHENTICATION_DATABASE OPTIONAL 'The MongoDB authentication database for logging in as ${MONGODB_USER}' 'admin';
defineEnvVar MONGODB_AUTHENTICATION_MECHANISM OPTIONAL 'The MongoDB authentication mechanism for logging in as ${MONGODB_USER}' 'SCRAM-SHA-1';

# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
