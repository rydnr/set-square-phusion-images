#!/bin/bash dry-wit
# Copyright 2016-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3

function usage() {
cat <<EOF
$SCRIPT_NAME
$SCRIPT_NAME [-h|--help]
(c) 2016-today Automated Computing Machinery S.L.
    Distributed under the terms of the GNU General Public License v3

Updates Jenkins plugins.

Common flags:
    * -h | --help: Display this message.
    * -v: Increase the verbosity.
    * -vv: Increase the verbosity further.
    * -q | --quiet: Be silent.
EOF
}

## Defines the errors
## dry-wit hook
function defineErrors() {
  addError INVALID_OPTION "Unrecognized option";
  addError CANNOT_UPDATE_JENKINS "Could not update Jenkins";
  addError CANNOT_RETRIEVE_UPDATE_CENTER_JSON "Could not retrieve update-center.json file from ${JENKINS_UPDATE_CENTER_JSON}";
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

## Retrieves the information from the update-center view.
## <- 0 if successful, 1 otherwise.
## <- RESULT: the path of the json file.
## Example:
##   if retrieve_update_center_json; then
##     echo "update-center.json is located in ${RESULT}"
##   fi
function retrieve_update_center_json() {
  local -i _rescode;

  createTempFile;
  local _result="${RESULT}";

  logDebug -n "Retrieving update-center.json from updates.jenkins-ci.org";
  wget -q -O "${_result}" ${JENKINS_UPDATE_CENTER_JSON};
  _rescode=$?;
  if isTrue ${_rescode}; then
    logDebugResult SUCCESS "done";
    export RESULT="${_result}";
  else
    logDebugResult FAILURE "failed";
  fi

  return ${_rescode};
}

## Processes the update-center.json file.
## -> 1: The update-center.json file.
## <- 0 if successful, 1 otherwise.
## <- RESULT: The processed file.
## Example:
##   process_update_center_json /tmp/my.json
##   echo "Processed update-center.json: ${RESULT}"
function process_update_center_json() {
  local _source="${1}";
  checkNotEmpty "source" "${_source}" 1;

  local -i _rescode;

  createTempFile;
  local _result="${RESULT}";

  logDebug -n "Processing update-center.json";
  sed '1d;$d' "${_source}" > "${_result}";
  _rescode=$?;
  if isTrue ${_rescode}; then
    logDebugResult SUCCESS "done";
    export RESULT="${_result}";
  else
    logDebugResult FAILURE "failed";
  fi

  return ${_rescode};
}

## Updates the local Jenkins instance.
## -> 1: The json file to upload.
## <- 0 if successful, 1 otherwise.
## <- RESULT: The processed file.
## Example:
##   process_update_center_json /tmp/my.json
##   echo "Processed update-center.json: ${RESULT}"
function update_jenkins() {
  local _source="${1}";
  checkNotEmpty "source" "${_source}" 1;

  local -i _rescode;

  logDebug -n "Posting update-center.json";
  curl -X POST -H "Accept: application/json" -d @"${_source}" http://localhost:${VIRTUAL_PORT}/updateCenter/byId/default/postBack
  _rescode=$?;
  if isTrue ${_rescode}; then
      logDebugResult SUCCESS "done";

      logDebug -n "Overwritting Jenkins update configuration";
      mv "${_source}" /var/jenkins_home/updates/default.json
      _rescode=$?;
      if isTrue ${_rescode}; then
          logDebugResult SUCCESS "done";
      else
        logDebugResult FAILURE "failed";
      fi
  else
    logDebugResult FAILURE "failed";
  fi

  return ${_rescode};
}

## Main logic
## dry-wit hook
function main() {
  retrieve_update_center_json;
  local _jsonFile="${RESULT}";

  process_update_center_json "${_jsonFile}";

  update_jenkins "${_jsonFile}";
}
