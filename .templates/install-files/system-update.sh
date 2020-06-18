#!/bin/bash dry-wit
# Copyright 2015-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3
# mod: system-update
# api: public
# txt: Updates the system packages.

DW.import ubuntu;

# fun: main
# api: public
# txt: Updates the system packages.
# txt: Returns 0/TRUE always, but can exit if an error occurs.
# use: main;
function main() {
  update_system;
  upgrade_system;
}

# fun: update_system
# api: public
# txt: Updates the system via apt update.
# txt: Returns 0/TRUE if the system gets updated; 1/FALSE otherwise.
# use: if ! update_system; then
# use:   echo "Error updating system";
# use: fi
function update_system() {

  logInfo -n "Updating system (this can take some time)";

  updateUbuntuSystem;
  local -i _rescode=$?;

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
# use: if ! upgrade_system; then
# use:   echo "Error upgrading system";
# use: fi
function upgrade_system() {

  logInfo -n "Upgrade system (this can take some time)";

  upgradeUbuntuSystem;
  local -i _rescode=$?;

  if isTrue ${_rescode}; then
    logInfoResult SUCCESS "done";
  else
    logInfoResult FAILURE "failed";
  fi

  return ${_rescode};
}

## Script metadata and CLI settings.
setScriptDescription "Updates the system packages.";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
