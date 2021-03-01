#!/bin/bash dry-wit
# Copyright 2017-today Automated Computing Machinery
# Licensed under GPLv3.
# mod: mongodb/mongodb-dump.sh
# api: public
# txt: Performs dumps of the MongoDB database.

export DW_DISABLE_ANSI_COLORS=TRUE
export NO_COLOR=true
export USECOLOR=no

DW.import mongodb

# fun: main
# api: public
# txt: Performs dumps of the MongoDB database.
# txt: Returns 0/TRUE always.
# use: main;
function main() {
	local _outputFolder="${MONGODB_DUMP_FOLDER}"
	local _dumpFile
	_dumpFile="${_outputFolder}/dump-$(date '+%Y%m%d.%H%M').gz"

	DW.getScriptName
	local _scriptName
	_scriptName="$(basename ${RESULT})"

	exec > >(sudo tee "${MONGODB_LOG_FOLDER}"/"${_scriptName}".log | sudo sh -c "logger -t \"${_scriptName}\" -s 2>/dev/console") 2>&1

	mkdir -p "${_outputFolder}" >/dev/null

	logInfo -n "Dumping MongoDB database on localhost to ${_dumpFile}"

	if mongoDump "${_dumpFile}" "${MONGODB_HOST}" "${MONGODB_USER}" "${MONGODB_PASSWORD}" "${AUTHENTICATION_DATABASE}" "${AUTHENTICATION_MECHANISM}"; then
		logInfoResult SUCCESS "done"
	else
		logInfoResult FAILURE "failed"
		logInfo "${ERROR}"
	fi
}

setScriptDescription "Performs dumps of the MongoDB database."

# env: MONGODB_DUMP_FOLDER: The folder storing the generated dump file. Defaults to /backup/mongodb/dumps.
defineEnvVar MONGODB_DUMP_FOLDER OPTIONAL "The folder storing the generated dump file" "/backup/mongodb/dumps"
# env: MONGODB_HOST: The MongoDB host. Defaults to localhost.
defineEnvVar MONGODB_HOST OPTIONAL "The MongoDB host" "localhost"
# env: MONGODB_USER: The MongoDB user. Defaults to ${BACKUP_USER_NAME}.
defineEnvVar MONGODB_USER OPTIONAL "The MongoDB user" "${BACKUP_USER_NAME}"
# env: MONGODB_PASSWORD: The password of the MongoDB user. Defaults to ${BACKUP_USER_PASSWORD}.
defineEnvVar MONGODB_PASSWORD OPTIONAL "The password of the MongoDB user" "${BACKUP_USER_PASSWORD}"
# env: AUTHENTICATION_DATABASE: The authentication database. Defaults to admin.
defineEnvVar AUTHENTICATION_DATABASE OPTIONAL "The authentication database" "admin"
# env: AUTHENTICATION_MECHANISM: The authentication mechanism. Defaults to SCRAM-SHA-1.
defineEnvVar AUTHENTICATION_MECHANISM OPTIONAL "The authentication mechanism" "SCRAM-SHA-1"
# env: MONGODB_LOG_FOLDER The MongoDB log folder. Defaults to /var/log/mongodb.
defineEnvVar MONGODB_LOG_FOLDER OPTIONAL "The MongoDB log folder" "/var/log/mongodb"
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
