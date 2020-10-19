#!/bin/bash dry-wit
# Copyright 2017-today Automated Computing Machinery
# Licensed under GPLv3.
# mod: mongodb/mongodb-restore.sh
# api: public
# txt: Restores a MongoDB database from a dump file.

export DW_DISABLE_ANSI_COLORS=TRUE;

DW.import mongodb;

# fun: main
# api: public
# txt: Performs dumps of the MongoDB database.
# txt: Returns 0/TRUE always.
# use: main;
function main() {
  logInfo -n "Restoring ${CORE_DATABASE} database on localhost from ${FILE}";

  if mongoRestore "${FILE}" "${MONGODB_HOST}" "${MONGODB_USER}" "${MONGODB_PASSWORD}" "${CORE_DATABASE}" "${AUTHENTICATION_MECHANISM}" "${CORE_DATABASE}"; then
    logInfoResult SUCCESS "done";
  else
    logInfoResult FAILURE "failed";
    logInfo "${ERROR}";
  fi
}

# Script metadata
setScriptDescription "Performs dumps of the MongoDB database.";

setCommandLineParameter "file" "The file to import" MANDATORY EXPECTS_ARGUMENT;

addError DUMP_FILE_DOES_NOT_EXIST "Dump file does not exist";

function dw_parse_file_cli_parameter() {
  export FILE="${1}";
}

function dw_check_file_cli_parameter() {
  if ! fileExists "${FILE}"; then
    exitWithErrorCode DUMP_FILE_DOES_NOT_EXIST;
  fi
}

# env: MONGODB_HOST: The MongoDB host. Defaults to localhost.
defineEnvVar MONGODB_HOST OPTIONAL "The MongoDB host" "localhost";
# env: MONGODB_USER: The MongoDB user. Defaults to ${BACKUP_USER}.
defineEnvVar MONGODB_USER OPTIONAL "The MongoDB user" "${BACKUP_USER}";
# env: MONGODB_PASSWORD: The password of the MongoDB user. Defaults to ${BACKUP_PASSWORD}.
defineEnvVar MONGODB_PASSWORD OPTIONAL "The password of the MongoDB user" "${BACKUP_PASSWORD}";
# env: CORE_DATABASE: The Core database. Defaults to core.
defineEnvVar CORE_DATABASE OPTIONAL "The Core database" "core";
# env: AUTHENTICATION_MECHANISM: The authentication mechanism. Defaults to SCRAM-SHA-256.
defineEnvVar AUTHENTICATION_MECHANISM OPTIONAL "The authentication mechanism" "SCRAM-SHA-256";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
