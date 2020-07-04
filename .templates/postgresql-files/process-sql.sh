#!/bin/bash dry-wit
# Copyright 2014-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3
# mod: process-sql.sh
# api: public
# txt: Connects to a PostgreSQL server and processes the SQL files in a volume.

# fun: main
# api: public
# txt: Connects to a PostgreSQL server and processes the SQL files in a volume.
# txt: Returns 0/TRUE always, but can exit if there're no sql files to process.
# use: main;
function main() {
  local _atLeastOneFile=${FALSE};

  if isNotEmpty "${SQL_FILE}"; then
    _atLeastOneFile=${TRUE};
    process_sql_file "${SQL_FOLDER}/${SQL_FILE}";
  else
    if find_sql_files "${SQL_FOLDER}"; then
      local _sqlFiles="${RESULT}";
      local _oldIFS="${IFS}";
      local _file;
      IFS="${DWIFS}";
      for _file in ${_sqlFiles}; do
        IFS="${_oldIFS}";
        if process_sql_file "${SQL_FOLDER}/${_file}"; then
          _atLeastOneFile=${TRUE};
        fi
      done
      IFS="${_oldIFS}";

      if isFalse ${_atLeastOneFile}; then
        logInfo "No pending files to process in ${SQL_FOLDER}";
      fi
    fi
  fi
}

# fun: process_sql_file file
# api: public
# txt: Processes given SQL file.
# opt: file: The SQL file to process.
# txt: Returns 0/TRUE if the file is processed and could be marked as such; 1/FALSE otherwise.
# use: if process_sql_file /tmp/my.sql; then
# use:   echo "Done";
# use: else
# use:   cho "Failed";
# use: fi
function process_sql_file() {
  local _file="${1}";
  checkNotEmpty file "${_file}" 1;

  local _inputFile;

  logInfo -n "Processing ${_file}";
  if replace_placeholders "${_file}"; then
    _inputFile="${RESULT}";
  else
    _inputFile="${_file}";
  fi
  createTempFile;
  local _logFile="${RESULT}";

  cat "${_logFile}";

  local -i _rescode;
  if isEmpty "${DB_PASSWORD}"; then
    /usr/bin/psql -X -n -h ${DB_HOST} -f ${_file} -o ${_logFile} -U ${DB_USER} -w --dbname=${DB_NAME} 2>&1;
    _rescode=$?;
  else
    PGPASSWORD="${DB_PASSWORD}" /usr/bin/psql -X -n -h ${DB_HOST} -f ${_file} -o ${_logFile} -U ${DB_USER} --dbname=${DB_NAME} 2>&1;
    _rescode=$?;
  fi

  if isTrue ${_rescode}; then
    if ! mark_sql_file_as_processed "$(dirname "${_file}")" "$(basename "${_file}")"; then
      logInfoResult SUCCESS "warning";
      logInfo "Cannot mark ${_file} as processed";
      _rescode=${FALSE};
    else
      logInfoResult SUCCESS "done";
    fi
  else
    logInfoResult FAILURE "failed";
    export ERROR="$(cat ${_logFile})";
  fi

  return ${_rescode};
}

# fun: find_sql_files folder
# api: public
# txt: Finds the SQL files in given folder.
# opt: The folder.
# txt: Returns 0/TRUE if there's at least one sql file yet to process.
# txt: If the function returns 0/TRUE, the variable RESULT contains a space-separated list of file names (relative to the folder).
# use: local f;
# use: local oldIFS="${IFS}";
# use: IFS="${DWIFS}";
# use: for f in find_sql_files /tmp; do
# use:   IFS="${oldIFS}";
# use:   echo "Found SQL: $f";
# use: done;
# use: IFS="${oldIFS}";
function find_sql_files() {
  local _folder="${1}";
  checkNotEmpty folder "${_folder}" 1;
  local _result=();

  local -i _rescode=${FALSE};

  local _oldIFS="${IFS}";
  local IFS="${DWIFS}";
  local _aux;

  for _aux in $(ls -a "${_folder}/" | grep -v '^\..*$'); do
    IFS="${_oldIFS}";
    if ! is_sql_file_marked_as_processed "${_folder}" "${_aux}"; then
      _rescode=${TRUE};
      _result[${#_result[@]}]="${_aux}";
    fi
  done
  IFS="${_oldIFS}";

  export RESULT=${_result[@]};

  return ${TRUE};
}

# fun: is_sql_file_marked_as_processed folder file
# api: public
# txt: Checks whether given SQL file is marked as processed.
# opt: folder: The SQL folder.
# opt: file: The SQL file.
# txt: Returns 0/TRUE if it's marked as processed; 1/FALSE otherwise.
# use: if is_sql_file_marked_as_processed /tmp my.sql; then
# use:   echo "/tmp/my.sql Already processed";
# use: fi
function is_sql_file_marked_as_processed() {
  local _folder="${1}";
  checkNotEmpty folder "${_folder}" 1;
  local _file="${2}";
  checkNotEmpty file "${_file}" 2;

  local -i _rescode=${TRUE};

  if fileExists "${_folder}"/."${_file}".done; then
    _rescode=${TRUE};
  else
    _rescode=${FALSE};
  fi

  return ${_rescode};
}

# fun: mark_sql_file_as_processed folder file
# api: public
# txt: Marks given SQL file as processed.
# opt: folder: The SQL folder.
# opt: file: The SQL file.
# txt: Returns 0/TRUE if it's marked successfully; 1/FALSE otherwise.
# use: if ! mark_sql_file_as_processed /tmp my.sql; then
# use:   echo "Cannot mark SQL file as processed";
# use: fi
function mark_sql_file_as_processed() {
  local _folder="${1}";
  checkNotEmpty folder "${_folder}" 1;
  local _file="${2}";
  checkNotEmpty file "${_file}" 2;

  touch "${_folder}"/."${_file}".done 2> /dev/null;

  return $?;
}

# fun: replace_placeholders file
# api: public
# txt: Replaces any placeholders in given file, using the existing environment variables.
# opt: file: The SQL file to process.
# txt: Returns 0/TRUE if the file is processed, 1/FALSE otherwise.
# txt: If the function returns 0/TRUE, the variable RESULT contains the path of the processed file.
# use: if replace_placeholders /var/local/my-file.template; then
# use:   echo "my-file.template processed: ${RESULT}";
# use: fi
function replace_placeholders() {
  local _file="${1}";
  checkNotEmpty file "${_file}" 1;

  createTempFile;
  local _output="${RESULT}";

  local _env="$(IFS=" \t" env | grep -v -e '^_DW_' | grep -v -e '^DW_' | awk -F'=' '{if ($1!="") { printf("%s=\"%s\" ", $1, $2);}}')";

  local _envsubstDecl=$(echo -n "'"; IFS=" \t" env | grep -v -e '^_DW_' | grep -v -e '^DW_' | cut -d'=' -f 1 | grep -v -e '^$' | awk '{ printf("${%s} ", $0);}'; echo -n "'";);

  echo "${_env} envsubst ${_envsubstDecl} < ${_file} > ${_output}" | sh;
  local -i _rescode=$?;

  if isTrue ${_rescode}; then
    export RESULT="${_output}";
  fi

  return ${_rescode};
}

# Script metadata
setScriptDescription "Connects to a PostgreSQL server and processes the SQL files in a volume.";

checkReq awk AWK_NOT_INSTALLED;
checkReq envsubst ENVSUBST_NOT_INSTALLED;
checkReq tr TR_NOT_INSTALLED;

addError NO_DB_USER_SPECIFIED "The database user cannot be empty";
addError NO_DB_NAME_SPECIFIED "The database name cannot be empty";
addError NO_SQL_FOLDER_SPECIFIED "The SQL folder is mandatory";
addError NO_SQL_FILES_FOUND "No SQL files found in ${SQL_FOLDER}";
addError SQL_FILE_NOT_FOUND "The specified file does not exist";
addError SQL_FILE_NOT_READABLE "The specified file is not readable";
addError SQL_FILE_IS_NOT_A_FILE "The specified file is not a file";

addCommandLineFlag user u "The database user" OPTIONAL EXPECTS_ARGUMENT "${DEFAULT_DB_USER}";
function dw_check_user_cli_flag() {
  local _user="${1}";
  if isEmpty "${_user}"; then
    exitWithErrorCode NO_DB_USER_SPECIFIED;
  fi
}
function dw_parse_user_cli_flag() {
  export DB_USER="${1}";
}

addCommandLineFlag password p "The password of the database user" OPTIONAL EXPECTS_ARGUMENT;
function dw_parse_password_cli_flag() {
  export DB_PASSWORD="${1}";
}

addCommandLineFlag database db "The database name" OPTIONAL EXPECTS_ARGUMENT "${DEFAULT_DB_NAME}";
function dw_check_database_cli_flag() {
  local _name="${1}";
  if isEmpty "${_name}"; then
    exitWithErrorCode NO_DB_NAME_SPECIFIED;
  fi
}
function dw_parse_database_cli_flag() {
  export DB_NAME="${1}";
}
addCommandLineFlag file f "The sql file" OPTIONAL EXPECTS_ARGUMENT;
function dw_parse_file_cli_flag() {
  export SQL_FILE="${1}";
}
addCommandLineParameter sqlFolder "The folder with sql files to process" OPTIONAL SINGLE;

defineEnvVar DB_HOST MANDATORY "The PostgreSQL host" "localhost";
defineEnvVar DEFAULT_DB_USER MANDATORY "The default database user" "${POSTGRESQL_ROOT_USER}";
defineEnvVar DEFAULT_DB_NAME MANDATORY "The default database name" "postgres";

# fun: checkInput
# api: public
# txt: Checks input parameters and flags.
# txt: Returns 0/TRUE always, but can exit if the input parameters are invalid.
# use: checkInput;
function checkInput() {

  logDebug -n "Checking input";

  if isEmpty "${SQL_FOLDER}"; then
    if isEmpty "${SQL_FILE}"; then
      logDebugResult FAILURE "fail";
      exitWithErrorCode NO_SQL_FOLDER_SPECIFIED;
    else
      if fileExists "${SQL_FILE}"; then
        if [[ -r ${SQL_FILE} ]]; then
          if [[ -f ${SQL_FILE} ]]; then
            logDebugResult SUCCESS "valid";
          else
            logDebugResult FAILURE "fail";
            exitWithErrorCode SQL_FILE_IS_NOT_A_FILE;
          fi
        else
          logDebugResult FAILURE "fail";
          exitWithErrorCode SQL_FILE_NOT_READABLE;
        fi
      else
        logDebugResult FAILURE "fail";
        exitWithErrorCode SQL_FILE_NOT_FOUND;
      fi
    fi
  else
    logDebugResult SUCCESS "valid";
  fi
}

# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
