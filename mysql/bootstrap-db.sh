#!/bin/bash dry-wit
# Copyright 2015-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3

function usage() {
cat <<EOF
$SCRIPT_NAME
$SCRIPT_NAME [-h|--help]
(c) 2015-today Automated Computing Machinery S.L.
    Distributed under the terms of the GNU General Public License v3

Bootstraps a MySQL database.

Common flags:
    * -h | --help: Display this message.
    * -v: Increase the verbosity.
    * -vv: Increase the verbosity further.
    * -q | --quiet: Be silent.
EOF
}

## Defines required dependencies
## dry-wit hook
function defineReq() {
  checkReq rsync RSYNC_NOT_AVAILABLE;
  checkReq mysql MYSQL_NOT_AVAILABLE;
  checkReq mysqladmin MYSQLADMIN_NOT_AVAILABLE;
  checkReq service SERVICE_NOT_AVAILABLE;
}

## Defines the errors
## dry-wit hook
function defineErrors() {
  addError "INVALID_OPTION" "Unrecognized option";
  addError "RSYNC_NOT_AVAILABLE" "rsync is not installed";
  addError "MYSQL_NOT_AVAILABLE" "mysql is not installed";
  addError "MYSQLADMIN_NOT_AVAILABLE" "mysqladmin is not installed";
  addError "SERVICE_NOT_AVAILABLE" "This script relies upon Systemd";
  addError "MYSQL_DATA_FOLDER_IS_MANDATORY" "MYSQL_DATA_FOLDER environment variable is mandatory";
  addError "SERVICE_USER_IS_MANDATORY" "SERVICE_USER environment variable is mandatory";
  addError "SERVICE_GROUP_IS_MANDATORY" "SERVICE_GROUP environment variable is mandatory";
  addError "ERROR_PROCESSING_SQL_TEMPLATE" "Error processing the SQL template ";
  addError "SLEEP_WHEN_SHUTTING_DOWN_DB_IS_MANDATORY" "SLEEP_WHEN_SHUTTING_DOWN_DB environment variable is mandatory";
  addError "MAX_RETRIES_TO_SHUT_DOWN_DB_IS_MANDATORY" "MAX_RETRIES_TO_SHUT_DOWN_DB environment variable is mandatory";
  addError "ERROR_PROCESSING_SQL_TEMPLATE" "Cannot process SQL template ";
  addError "CANNOT_STOP_MONIT" "Cannot stop Monit";
  addError "CANNOT_STOP_MYSQL" "Cannot stop MySQL";
  addError "CANNOT_HOUSEKEEP_DATA_FOLDER" "Cannot housekeep data folder ";
  addError "CANNOT_INITIALIZE_DB" "Cannot initialize a new database";
  addError "CANNOT_RUN_SQL_SCRIPT" "Cannot run the SQL script ";
  addError "CANNOT_UPGRADE_DB" "Cannot upgrade the database";
  addError "CANNOT_SHUTDOWN_DB" "Cannot shutdown the database";
  addError "CANNOT_FIX_DB_FOLDER_PERMISSIONS" "Cannot fix the folder permissions of ";
  addError "CANNOT_START_MONIT" "Cannot start monit";
  addError "CANNOT_START_MYSQL" "Cannot start MySQL";
  addError "CANNOT_RESET_TEMPORARY_PASSWORD" "Cannot reset the temporary password";
}

## Validates the input.
## dry-wit hook
function checkInput() {

  local _flags=$(extractFlags $@);
  local _flagCount;
  local _currentCount;
  logDebug -n "Checking input";

  # Flags
  for _flag in ${_flags}; do
    _flagCount=$((_flagCount+1));
    case ${_flag} in
      -h | --help | -v | -vv | -q)
         shift;
         ;;
      --)
        shift;
        break;
        ;;
      *) logDebugResult FAILURE "failed";
         exitWithErrorCode INVALID_OPTION;
         ;;
    esac
  done

  if isEmpty "${MYSQL_DATA_FOLDER}"; then
    logDebugResult FAILURE "failed";
    exitWithErrorCode MYSQL_DATA_FOLDER_IS_MANDATORY;
  fi

  if isEmpty "${SERVICE_USER}"; then
    logDebugResult FAILURE "failed";
    exitWithErrorCode SERVICE_USER_IS_MANDATORY;
  fi

  if isEmpty "${SERVICE_GROUP}"; then
    logDebugResult FAILURE "failed";
    exitWithErrorCode SERVICE_GROUP_IS_MANDATORY;
  fi

  if isEmpty "${SLEEP_WHEN_SHUTTING_DOWN_DB}"; then
    logDebugResult FAILURE "failed";
    exitWithErrorCode SLEEP_WHEN_SHUTTING_DOWN_DB_IS_MANDATORY;
  fi

  if isEmpty "${MAX_RETRIES_TO_SHUT_DOWN_DB}"; then
      logDebugResult FAILURE "failed";
      exitWithErrorCode MAX_RETRIES_TO_SHUT_DOWN_DB_IS_MANDATORY;
  fi

  logDebugResult SUCCESS "valid";
}

## Parses the input
## dry-wit hook
function parseInput() {

  local _flags=$(extractFlags $@);
  local _flagCount;
  local _currentCount;

  # Flags
  for _flag in ${_flags}; do
    _flagCount=$((_flagCount+1));
    case ${_flag} in
      -h | --help | -v | -vv | -q)
         shift;
         ;;
      --)
        shift;
        break;
        ;;
    esac
  done
}

## Stops the Monit service.
## <- 0/${TRUE} if the service stops successfully; 1/${FALSE} otherwise.
## Example:
##    if stop_monit; then
##      echo "Monit stopped successfully";
##    fi
function stop_monit() {
  local -i _rescode;
  service monit stop > /dev/null;
  _rescode=$?;

  return ${_rescode};
}

## Start the Monit service.
## <- 0/${TRUE} if the service starts successfully; 1/${FALSE} otherwise.
## Example:
##    if start_monit; then
##      echo "Monit started successfully";
##    fi
function start_monit() {
  local -i _rescode;

  service monit start > /dev/null 2>&1;
  _rescode=$?;

  return ${_rescode};
}

## Waits until MySQL is actually stopped.
## <- 0/${TRUE} if the MySQL service is stopped; 1/${FALSE} otherwise.
## Example:
##    if stop_mysql; then
##      echo "MySQL has stopped successfully";
##    else
##      echo "Could not stop MySQL";
##    fi
function stop_mysql() {
  local -i _rescode;
  local -i _retries=0;

  while is_mysql_running; do
    killall mysqld > /dev/null 2>&1;
    killall mysqld_safe > /dev/null 2>&1;
    logDebug -n "Waiting ${SLEEP_WHEN_SHUTTING_DOWN_DB}s for MySQL to shut down";
    _retries=$((_retries+1));
    sleep ${SLEEP_WHEN_SHUTTING_DOWN_DB};
    if is_mysql_running; then
        if [ ${_retries} -ge ${MAX_RETRIES_TO_SHUT_DOWN_DB} ]; then
            logDebugResult FAILURE "failed";
            _rescode=${FALSE};
            break;
        else
          logDebugResult FAILURE "running";
        fi
    else
      _rescode=${TRUE};
      logDebugResult SUCCESS "stopped";
      break;
    fi
  done

  return ${_rescode};
}

## Performs housekeeping on the data folder.
## -> 1: The data folder.
## <- 0/${TRUE} if the operation finishes successfully; 1/${FALSE} otherwise.
## Example:
##    if housekeep_data_folder "${MYSQL_DATA_FOLDER}"; then
##      echo "${MYSQL_DATA_FOLDER} sanitized successfully";
##    fi
function housekeep_data_folder() {
  local _datadir="${1}";
  local -i _rescode;
  local _backupFolder;

  checkNotEmpty "dataDir" "${_datadir}" 1;

  _backupFolder="${_datadir}-$(date '+%Y%m%d_%H%M%S')";
  mkdir "${_backupFolder}";
  rsync -azq ${_datadir}/ ${_backupFolder}/;
  rm -rf ${_datadir}/*;
}

## Bootstraps the MySQL database.
## -> 1: The template.
## -> 2: The output file.
## <- 0/${TRUE} if the template is processed successfully; 1/${FALSE} otherwise.
## Example:
##   if generate_sql_file "/usr/local/src/setup.sql.tpl" "/usr/local/src/setup.sql"; then
##     echo "/usr/local/src/setup.sql generated successfully";
##   fi
function generate_sql_file() {
  local _template="${1}";
  local _output="${2}";
  local -i _rescode;

  checkNotEmpty "template" "${_template}" 1;
  checkNotEmpty "output" "${_output}" 2;

  sed "s ___LAN___ $(ifconfig eth0 | grep 'inet addr' | cut -d':' -f 2 | awk '{print $1;}' | awk -F'.' '{printf("%d.%d.%d.%%\n", $1, $2, $3);}') g" ${_template} > ${_output};
  _rescode=$?;
  if isTrue ${_rescode}; then
      sed -i "s ___DEBIAN_SYS_MAINT_PASSWORD_HASH___ $(grep password /etc/mysql/debian.cnf  | head -n 1 | cut -d' ' -f 3) g" ${_output};
      _rescode=$?;
  fi

  return ${_rescode};
}

## Initializes a new MySQL database.
## -> 1: The data folder.
## <- RESULT: The auto-generated password for root.
## <- 0/${TRUE} if the database gets initialized successfully; 1/${FALSE} otherwise.
## Example:
##   if initialize_db "/var/lib/mysql"; then
##     echo "Database initialized successfully (pass: ${RESULT})";
##   fi
function initialize_db() {
  local _datadir="${1}";
  local -i _rescode;
  local _result;

  checkNotEmpty "dataDir" "${_datadir}" 1;

  logDebug -n "Initializing a database in ${_datadir}";
  _result=$(mysqld --initialize --datadir=${_datadir} 2>&1 | grep 'temporary password');
  _rescode=$?;

  if isTrue ${_rescode}; then
      logDebugResult SUCCESS "done";
      _result="${_result#*: }";
      export RESULT="${_result}";
  else
    logDebugResult FAILURE "failed";
  fi

  return ${_rescode};
}

## Resets the temporary password for the root user, generated when creating a new database.
## -> 3: The temporary password.
## -> 2: The new password.
## <- 0/${TRUE} if the operation finishes successfully; 1/${FALSE} otherwise.
## Example:
##   if reset_temporary_password "sthaorue" "secret"; then
##     echo "Password reset successfully";
##   fi
function reset_temporary_password() {
  local _temporaryPassword="${1}";
  local _newPassword="${2}";
  local -i _rescode;

  checkNotEmpty "temporaryPassword" "${_temporaryPassword}" 1;
  checkNotEmpty "newPassword" "${_newPassword}" 2;

  logDebug -n "Resetting temporary password";

  mysql -u root --password="${_temporaryPassword}" --connect-expired-password > /dev/null 2>&1 <<EOF
SET PASSWORD="${_newPassword}";
FLUSH PRIVILEGES;
EOF
  _rescode=$?;

  if isTrue ${_rescode}; then
      logDebugResult SUCCESS "done";
  else
    logDebugResult FAILURE "failed";
  fi

  return ${_rescode};
}

## Processes given SQL file.
## -> 1: The SQL file to run.
## -> 2: The database user to use. Optional. Default: root.
## -> 3: The password of the database user. Optional. Default: empty.
## <- 0/${TRUE} if the SQL finishes successfully; 1/${FALSE} otherwise.
## Example:
##   if run_sql "/usr/local/src/setup.sql" root "secret"; then
##     echo "SQL file finished successfully";
##   fi
function run_sql() {
  local _sqlFile="${1}";
  local _user="${2:-root}";
  local _password="${3}";
  local -i _rescode;

  checkNotEmpty "sqlFile" "${_sqlFile}" 1;

  logDebug -n "Running bootstrap SQL";
  if isEmpty "${_password}"; then
      mysql -u ${_user} > /dev/null 2>&1 < "${_sqlFile}";
      _rescode=$?;
  else
    mysql -u ${_user} --password="${_password}" > /dev/null 2>&1 < "${_sqlFile}";
    _rescode=$?;
  fi

  if isTrue ${_rescode}; then
      logDebugResult SUCCESS "done";
  else
    logDebugResult FAILURE "failed";
  fi

  return ${_rescode};
}

## Performs an upgrade of the database.
## -> 1: The database user to use. Optional. Default: root.
## -> 2: The password of the database user. Optional. Default: empty.
## <- 0/${TRUE} if the database gets upgraded successfully; 1/${FALSE} otherwise.
## Example:
##   if upgrade_db root "secret"; then
##     echo "Database upgrade finished successfully";
##   fi
function upgrade_db() {
  local _user="${1:-root}";
  local _password="${2}";
  local -i _rescode;

  logDebug -n "Upgrading database";

  if isEmpty "${_password}"; then
      mysql_upgrade -u ${_user} > /dev/null 2>&1;
      _rescode=$?;
  else
    mysql_upgrade -u ${_user} --password="${_password}" > /dev/null 2>&1;
    _rescode=$?;
  fi

  if isTrue ${_rescode}; then
      logDebugResult SUCCESS "done";
  else
    logDebugResult FAILURE "failed";
  fi

  return ${_rescode};
}

## Shuts down the database.
## -> 1: The database user to use. Optional. Default: root.
## -> 2: The password of the database user. Optional. Default: empty.
## <- 0/${TRUE} if the database gets upgraded successfully; 1/${FALSE} otherwise.
## Example:
##   if shutdown_db root "secret"; then
##     echo "Database upgrade finished successfully";
##   fi
function shutdown_db() {
  local _user="${1:-root}";
  local _password="${2}";
  local -i _rescode;
  local -i _retries=0;

  logDebug -n "Shutting down the database";

  if isEmpty "${_password}"; then
      mysqladmin -u ${_user} -h127.0.0.1 --protocol=tcp shutdown > /dev/null 2>&1;
      _rescode=$?;
  else
    mysqladmin -u ${_user} --password="${_password}" -h127.0.0.1 --protocol=tcp shutdown > /dev/null 2>&1;
    _rescode=$?;
  fi

  if isTrue ${_rescode}; then
      while is_mysql_running; do
        logDebugResult SUCCESS "waiting";
        _retries=$((_retries+1));
        logDebug -n "Waiting ${SLEEP_WHEN_SHUTTING_DOWN_DB}s for MySQL to shut down";
        sleep ${SLEEP_WHEN_SHUTTING_DOWN_DB};
        if [ ${_retries} -ge ${MAX_RETRIES_TO_SHUT_DOWN_DB} ]; then
            logDebugResult FAILURE "failed";
            break;
        else
          logDebugResult FAILURE "running";
        fi
      done

      logDebugResult SUCCESS "done";
  else
    logDebugResult FAILURE "failed";
  fi

  return ${_rescode};
}

## Checks whether MySQL is running (accepting connections).
## <- 0/${TRUE} if MySQL is running; 1/${FALSE} otherwise.
## Example:
##   if is_mysql_running; then
##     echo "MySQL is running";
##   fi
function is_mysql_running() {
  local -i _rescode;

  local _aux="$(mysqladmin extended-status 2>&1)";
  if [ "${_aux#*error:}" != "${_aux}" ]; then
      if    [ "${_aux#*\(2\)}" != "${_aux}" ] \
         || [ "${_aux#*\(111\)}" != "${_aux}" ]; then
          _debugEcho "is_running -> false"
          _rescode=${FALSE};
      else
        _debugEcho "is_running -> true"
        _rescode=${TRUE};
      fi
  else
    _debugEcho "is_running -> true"
    _rescode=${TRUE};
  fi

  return ${_rescode};
}

## Starts MySQL.
## -> 1: The database folder.
## <- 0/${TRUE} if MySQL starts successfully; 1/${FALSE} otherwise.
## Example:
##   if start_mysql /var/lib/mysql; then
##     echo "MySQL started successfully";
##   fi
function start_mysql() {
  local _datadir="${1}";
  local -i _rescode;
  local -i _retries=0;

  checkNotEmpty "datadir" "${_datadir}" 1;

  logDebug -n "Starting MySQL";

  /usr/bin/mysqld_safe --console --user=${SERVICE_USER} --datadir=${_datadir} > /dev/null 2>&1 &

  _rescode=$?;

  if isTrue ${_rescode}; then
      logDebugResult SUCCESS "waiting";
      while isFalse is_mysql_running; do
        _retries=$((_retries+1));
        logDebug -n "Waiting ${SLEEP_UNTIL_DB_IS_READY}s for MySQL to start";
        sleep ${SLEEP_UNTIL_DB_IS_READY};
        if [ ${_retries} -ge ${MAX_RETRIES_TO_START_DB} ]; then
            logDebugResult FAILURE "failed";
            break;
        elif is_mysql_running; then
            logDebugResult SUCCESS "started";
            break;
        else
          logDebugResult FAILURE "stopped";
        fi
      done
  else
    logDebugResult FAILURE "failed";
  fi

  return ${_rescode};
}

## Fixes the permissions of given folder.
## -> 1: The folder.
## -> 2: The folder owner.
## -> 3: The folder group.
## <- 0/${TRUE} if the folder got the correct permissions; 1/${FALSE} otherwise.
## Example:
##    if fix_folder_permissions "/var/lib/mysql" "mysql" "mysql"; then
##      echo "Permissions updated successfully";
##    fi
function fix_folder_permissions() {
  local _folder="${1}";
  local _owner="${2}";
  local _group="${3}";
  local -i _rescode;

  checkNotEmpty "folder" "${_folder}" 1;
  checkNotEmpty "owner" "${_owner}" 2;
  checkNotEmpty "group" "${_group}" 3;

  logDebug -n "Fixing permissions on ${_folder}";
  chown -R ${_owner}:${_gorup} "${_folder}" && chmod 755 "${_folder}";
  _rescode=$?;

  if isTrue ${_rescode}; then
      logDebugResult SUCCESS "done";
  else
    logDebugResult FAILURE "failed";
  fi

  return ${_rescode};
}

## Main logic
## dry-wit hook
function main() {
  local _sqlFile;
  local _rootPassword;

  if [ -e ${MYSQL_DATA_FOLDER}/.bootstrapped ]; then
      logInfo "Skipping bootstrap since database already exists";
  else
      createTempFile;
      _sqlFile="${RESULT}";

      logDebug -n "Processing ${SQL_TEMPLATE}";
      if generate_sql_file "${SQL_TEMPLATE}" "${_sqlFile}"; then
          logDebugResult SUCCESS "done";
      else
        logDebugResult FAILURE "failed";
        exitWithErrorCode ERROR_PROCESSING_SQL_TEMPLATE "${SQL_TEMPLATE}";
      fi

      # Just in case Monit is configured to restart MySQL
      if ! stop_monit; then
          exitWithErrorCode CANNOT_STOP_MONIT;
      fi

      if ! stop_mysql; then
          exitWithErrorCode CANNOT_STOP_MYSQL;
      fi

      if ! housekeep_data_folder "${MYSQL_DATA_FOLDER}"; then
          exitWithErrorCode CANNOT_HOUSEKEEP_DATA_FOLDER "${MYSQL_DATA_FOLDER}";
      fi

      if ! initialize_db "${MYSQL_DATA_FOLDER}"; then
          exitWithErrorCode CANNOT_INITIALIZE_DB;
      fi
      _rootPassword="${RESULT}";

      if ! start_mysql ${MYSQL_DATA_FOLDER}; then
          exitWithErrorCode CANNOT_START_MYSQL;
      fi

      if ! reset_temporary_password "${_rootPassword}" "${MYSQL_ROOT_PASSWORD}"; then
          exitWithErrorCode CANNOT_RESET_TEMPORARY_PASSWORD;
      fi

      if ! run_sql "${_sqlFile}" "root" "${MYSQL_ROOT_PASSWORD}"; then
          exitWithErrorCode CANNOT_RUN_SQL_SCRIPT "${_sqlFile}";
      fi

      if ! upgrade_db "root" "${MYSQL_ROOT_PASSWORD}"; then
          exitWithErrorCode CANNOT_UPGRADE_DB;
      fi

      if ! shutdown_db "root" "${MYSQL_ROOT_PASSWORD}"; then
          exitWithErrorCode CANNOT_SHUTDOWN_DB;
      fi

      if ! fix_folder_permissions "${MYSQL_DATA_FOLDER}" "${SERVICE_USER}" "${SERVICE_GROUP}"; then
         exitWithErrorCode CANNOT_FIX_DB_FOLDER_PERMISSIONS "${MYSQL_DATA_FOLDER}";
      fi

      touch ${MYSQL_DATA_FOLDER}/.bootstrapped

      if ! start_monit; then
          exitWithErrorCode CANNOT_START_MONIT;
      fi
  fi
}

