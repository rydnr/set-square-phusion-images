#!/bin/bash dry-wit
# Copyright 2016-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3

function usage() {
cat <<EOF
$SCRIPT_NAME
$SCRIPT_NAME [-h|--help]
(c) 2016-today Automated Computing Machinery S.L.
    Distributed under the terms of the GNU General Public License v3

Updates filebeat.yml configuration.

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
  checkReq perl PERL_NOT_AVAILABLE;
}

## Defines the errors
## dry-wit hook
function defineErrors() {
  addError "INVALID_OPTION" "Unrecognized option";
  addError "PERL_NOT_AVAILABLE" "perl is not installed";
  addError "IFCONFIG_NOT_AVAILABLE" "ifconfig is not installed";
  addError "GREP_NOT_AVAILABLE" "grep is not available";
  addError "CUT_NOT_AVAILABLE" "cut is not available";
  addError "CANNOT_RETRIEVE_OWN_IP" "Cannot retrieve my own IP";
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

## Retrieves the IP.
## <- 0/${TRUE} if the IP is up; 1/${FALSE} otherwise.
## <- RESULT: The IP.
## Example:
##   if retrieve_ip; then
##     echo "IP: ${RESULT}";
##   fi
function retrieve_ip() {
  local -i _rescode;
  local _result;

  _result="$(ifconfig | grep 'inet addr:' | grep -v '127.0.0.1' | cut -d ':' -f 2 | cut -d' ' -f 1)";
  _rescode=$?;

  if isTrue ${_rescode}; then
      export RESULT=${_result};
  fi

  return ${_rescode};
}

## Adds a new log file to the filebeat.yml file.
## -> 1: The log file to add.
## -> 2: The filebeat.yml file.
## <- 0/${TRUE} if the log file is added to the filebeat.yml configuration; 1/${FALSE} otherwise.
## Example:
##   if add_log_file_to_forward "/var/log/syslog" "/etc/filebeat/filebeat.yml"; then
##     echo "/var/log/syslog added to filebeat.yml";
##   fi
function add_log_file_to_forward() {
  local _logFile="${1}";
  local _filebeatYml="${2}";
  local -i _rescode;

  checkNotEmpty "logFile" "${_logFile}" 1;
  checkNotEmpty "filebeatYml" "${_filebeatYml}" 2;

  if grep -e '^#        - /var/log/\*.log$' > /dev/null; then
      perl -i -pe "BEGIN{undef $/;} s|^#        - /var/log/\*.log$|        - ${_logFile}\n#        - /var/log/\*.log|sgm" "${_filebeatYml}";
      _rescode=$?;
  else
    perl -i -pe "BEGIN{undef $/;} s|^        - /var/log/\*.log$|        - ${_logFile}\n#        /var/log/\*.log|sgm" "${_filebeatYml}";
    _rescode=$?;
  fi

  return ${_rescode};
}

## Updates the openssl.cnf file to add the
## Main logic
## dry-wit hook
function main() {

  logInfo -n "Retrieving IP";
  if retrieve_ip; then
      _ip="${RESULT}";
      logInfoResult SUCCESS "${_ip}";

      logInfo -n "Updating ${FILEBEAT_YML_FILE}";
      for _f in "${LOG_FILES}"; do
        add_log_file_to_forward "${_f}" "${FILEBEAT_YML_FILE}";
      done

      logInfoResult SUCCESS "done";

  else
    logInfoResult FAILURE "failed";
    exitWithErrorCode CANNOT_RETRIEVE_OWN_IP;
  fi
}


