#!/bin/bash dry-wit

# Copyright 2015-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3

## Updates the system via apt-get update
## <- 0 if the system gets updated; 1 otherwise.
## Example:
##   if ! update_system; then
##     echo "Error updating system"
##   fi
function update_system() {
  local -i _rescode;

  if isEmpty "${SYSTEM_UPDATE}"; then
      exitWithErrorCode SYSTEM_UPDATE_IS_MANDATORY;
  fi

  logInfo -n "Updating system (this can take some time)";

  ${SYSTEM_UPDATE} > /dev/null 2>&1
  _rescode=$?;

  if isTrue ${_rescode}; then
    logInfoResult SUCCESS "done";
  else
    logInfoResult FAILURE "failed";
  fi

  return ${_rescode};
}


## Main logic
## dry-wit hook
function main() {
  update_system;
}

## Script metadata and CLI settings.

setScriptDescription "Updates the system packages.";

addError "INVALID_OPTION" "Unrecognized option";

addError SYSTEM_UPDATE_IS_MANDATORY "SYSTEM_UPDATE is mandatory"
#
