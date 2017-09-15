#!/bin/bash dry-wit
# Copyright 2017-today Automated Computing Machinery
# Licensed under GPLv3.

# Prints how to use this script.
## dry-wit hook
function usage() {
  cat <<EOF
$SCRIPT_NAME [-v[v]|-q]
$SCRIPT_NAME [-h|--help]
(c) 2017-today Automated Computing Machinery

Performs regular dumps of the MongoDB database.

Common flags:
    * -h | --help: Display this message.
    * -v: Increase the verbosity.
    * -vv: Increase the verbosity further.
    * -q | --quiet: Be silent.
EOF
}

# Error messages
function defineErrors() {
  addError INVALID_OPTION "Unknown option";
}

## Parses the input
## dry-wit hook
function parseInput() {

  local _flags=$(extractFlags $@);
  local _flagCount=0;
  local _currentCount;
  local _help=${FALSE};

  # Flags
  for _flag in ${_flags}; do
    _flagCount=$((_flagCount+1));
    case ${_flag} in
      -h | --help)
        _help=${TRUE};
        shift;
        ;;
      -v | -vv | -q | --quiet)
        shift;
        ;;
      --)
        shift;
        break;
        ;;
    esac
  done
}

## Checking input
## dry-wit hook
function checkInput() {

  local _flags=$(extractFlags $@);
  local _flagCount;
  local _currentCount;
  local _oldIfs;

  logDebug -n "Checking input";

  # Flags
  for _flag in ${_flags}; do
    _flagCount=$((_flagCount+1));
    case ${_flag} in
      -h | --help | -v | -vv | -q | --quiet)
      ;;
      --)
        break;
        ;;
      *) logDebugResult FAILURE "fail";
         exitWithErrorCode INVALID_OPTION ${_flag};
         ;;
    esac
  done

  logDebugResult SUCCESS "valid";
}

## Performs a dump (gzipped, using the MongoDB archive format)
## -> 1: The output file.
## -> 2: The host. Optional. Defaults to localhost.
## -> 3: The user name. Optional.
## -> 4: The password. Optional.
## -> 5: The authentication database. Optional. Defaults to admin.
## -> 6: The authentication mechanism. Optional. Defaults to SCRAM-SHA1.
## <- 0/${TRUE} if the dump gets created successfully; 1/${FALSE} otherwise.
## Example:
## if mongo_dump /tmp/dump-today.gz localhost root secret; then
##   echo "dump succeeded"
## fi
function mongo_dump() {
  local _output="${1}";
  local _host="${2:-localhost}";
  local _user="${3}";
  local _pass="${4}";
  local _authDb="${5:-admin}";
  local _authMechanism="${6:-SCRAM-SHA1}";

  local -i _rescode;

  checkNotEmpty "output" "${_output}" 1;
  checkNotEmpty "host" "${_host}" 2;

  if isEmpty "${_user}"; then
    mongodump --gzip --archive="${_output}" -h ${_host} > /dev/null 2>&1;
  else
    mongodump --gzip --archive="${_output}" -h ${_host} -u ${_user} -p ${_pass} --authenticationDatabase=${_authDb} --authenticationMechanism=${_authMechanism} > /dev/null 2>&1
  fi
  _rescode=$?;

  return ${_rescode}
}

## Main logic
## dry-wit hook
function main() {
  local _outputFolder="${MONGODB_DUMPS_FOLDER}";
  local _dumpFile="${_outputFolder}/dump-$(date '+%Y%m%d.%H%M').gz";

  mkdir -p "${_outputFolder}" > /dev/null;

  logInfo -n "Dumping MongoDB database on localhost to ${_dumpFile}";

  if mongo_dump "${_dumpFile}" "${MONGODB_HOST}" "${MONGODB_USER}" "${MONGODB_PASSWORD}" "${MONGODB_AUTHENTICATION_DATABASE}" "${MONGODB_AUTHENTICATION_MECHANISM}"; then
    logInfoResult SUCCESS "done";
  else
    logInfoResult FAILURE "failed";
  fi
}
