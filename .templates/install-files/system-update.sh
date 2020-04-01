#!/bin/bash dry-wit
# Copyright 2015-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3
# mod: system-update
# api: public
# txt: Updates the system packages.

# fun: update_system
# api: public
# txt: Updates the system via apt update.
# txt: Returns 0/TRUE if the system gets updated; 1/FALSE otherwise.
# use: if ! update_system; then echo "Error updating system"; fi
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

# fun: upgrade_system
# api: public
# txt: Updates the system via apt upgrade.
# txt: Returns 0/TRUE if the system gets upgraded; 1/FALSE otherwise.
# use: if ! upgrade_system; then echo "Error upgrading system"; fi
function upgrade_system() {
  local -i _rescode;

  if isEmpty "${SYSTEM_UPGRADE}"; then
    exitWithErrorCode SYSTEM_UPGRADE_IS_MANDATORY;
  fi

  logInfo -n "Upgrade system (this can take some time)";

  ${SYSTEM_UPGRADE} > /dev/null 2>&1
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

  upgrade_system;
}

## Script metadata and CLI settings.

setScriptDescription "Updates the system packages.";
addError SYSTEM_UPDATE_IS_MANDATORY "SYSTEM_UPDATE is mandatory"
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
