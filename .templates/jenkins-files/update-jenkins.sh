#!/bin/bash dry-wit
# Copyright 2016-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3

setScriptDescription "Updates Jenkins plugins.";

addError CANNOT_UPDATE_JENKINS "Could not update Jenkins";
addError CANNOT_RETRIEVE_UPDATE_CENTER_JSON "Could not retrieve update-center.json file from ${JENKINS_UPDATE_CENTER_JSON}";

# fun: retrieve_update_center_json
# api: public
# txt: Retrieves the information from the update-center view.
# txt: Returns 0/TRUE if tthe json file could be retrieved; 1/FALSE otherwise.
# txt: If the function returns 0/TRUE, the variable RESULT contains the path of the json file.
# use: if retrieve_update_center_json; then echo "update-center.json is located in ${RESULT}"; fi
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

# fun: process_update_center_json
# api: public
# txt: Processes the update-center.json file.
# opt: source: The update-center.json file.
# txt: Returns 0/TRUE if the file gets processes successfully;  1/FALSE otherwise.
# txt: If the function returns 0/TRUE, the variable RESULT contains the processed file.
# use: if process_update_center_json /tmp/my.json; then echo "Processed update-center.json: ${RESULT}"; fi
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

# fun: update_jenkins
# api: public
# txt: Updates the local Jenkins instance.
# opt: source: The json file to upload.
# txt: Returns 0/TRUE if the file is uploaded successfully; 1/FALSE otherwise.
# txt: If the function returns 0/TRUE, the variable RESULT contains the processed file.
# use: if process_update_center_json /tmp/my.json; then echo "Processed update-center.json: ${RESULT}"; fi
function update_jenkins() {
  local _source="${1}";
  checkNotEmpty source "${_source}" 1;

  local -i _rescode;

  logDebug -n "Posting update-center.json";
  local _aux="$(curl -X POST -H "Accept: application/json" -d @"${_source}" http://localhost:${VIRTUAL_PORT}/updateCenter/byId/default/postBack)";
  _rescode=$?;
  if isTrue ${_rescode} && ! contains "${_aux}" "HTTP Status 404"; then
    logDebugResult SUCCESS "done";

    logDebug -n "Overwritting Jenkins update configuration";
    mv "${_source}" ${JENKINS_HOME}/updates/default.json
    _rescode=$?;
    if isTrue ${_rescode}; then
      logDebugResult SUCCESS "done";
    else
      logDebugResult FAILURE "failed";
    fi
  else
    logDebugResult FAILURE "failed";
    logDebug "${_aux}";
  fi

  return ${_rescode};
}

# fun: main
# api: public
# txt: Main logic (dry-wit hook)
# txt: Returns 0/TRUE always, but may exit with an error.
# use: main
function main() {
  local _jsonFile;
  if retrieve_update_center_json; then
    _jsonFile="${RESULT}";
    process_update_center_json "${_jsonFile}";
    update_jenkins "${_jsonFile}";
  else
    exitWithErrorCode CANNOT_RETRIEVE_UPDATE_CENTER_JSON "${JENKINS_UPDATE_CENTER_JSON}";
  fi
}
#
