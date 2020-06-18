#!/bin/bash dry-wit
# Copyright 2015-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3
# mod: system-cleanup
# api: public
# txt: Removes unused packages from the system.

DW.import ubuntu;

# fun: main
# api: public
# txt: Removes unused packages from the system.
# txt: Returns 0/TRUE always, but can exit in case an error occurs.
# use: main;
function main() {
  autoremove_packages;
  clean_system;
  truncate_logs;
  wipe_temporary_folder;
}

# fun: autoremove_packages
# api: public
# txt: Removes unused packages from the system.
# txt: Returns 0/TRUE if the packages get removed; 1/FALSE otherwise.
# use: if autoremove_packages; then
# use:   ...
# use: fi
function autoremove_packages() {

  logInfo -n "Removing unused packages";
  autoremoveUbuntuPackages;
  local -i _rescode=$?;

  if isTrue ${_rescode}; then
    logInfoResult SUCCESS "done";
  else
    logInfoResult FAILURE "failed";
  fi

  return ${_rescode};
}

# fun: clean_system
# api: public
# txt: Cleans up the system.
# txt: Returns 0/TRUE if the system gets cleaned; 1/FALSE otherwise.
# use: if clean_system; then
# use:   ...
# use: fi
function clean_system() {

  logInfo -n "Autoremoving unused packages";
  cleanUbuntuSystem;
  local -i _rescode=$?;

  if isTrue ${_rescode}; then
    logInfoResult SUCCESS "done";
  else
    logInfoResult FAILURE "failed";
  fi

  return ${_rescode};
}

# fun: truncate_logs
# api: public
# txt: Truncates all log files.
# txt: Returns 0/TRUE if the logs get truncated; 1/FALSE otherwise.
# use: if truncate_logs; then
# use:   ...
# use: fi
function truncate_logs() {

  logInfo -n "Truncating log files";
  truncateFiles /var/log '*.log';
  local -i _rescode=$?;

  if isTrue ${_rescode}; then
    logInfoResult SUCCESS "done";
  else
    logInfoResult FAILURE "failed";
  fi

  return ${_rescode};
}

# fun: wipe_temporary_folder
# api: public
# txt: Wipes the contents of the /tmp.
# txt: Returns 0/TRUE if the temporary folder gets wiped; 1/FALSE otherwise.
# use: if wipe_temporary_folder; then
# use:   ...
# use: fi
function wipe_temporary_folder() {

  logInfo -n "Wiping /tmp";
  rm -rf /tmp/* > /dev/null 2>&1;
  local -i _rescode=$?;

  if isTrue ${_rescode}; then
    logInfoResult SUCCESS "done";
  else
    logInfoResult FAILURE "failed";
  fi
  rm -rf /tmp/.* > /dev/null 2>&1

  return ${_rescode};
}

## Script metadata and CLI settings.
setScriptDescription "Cleans up the system by removing unused packages.";

addError ERROR_REMOVING_UNUSED_PACKAGES "Error removing unused packages";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
