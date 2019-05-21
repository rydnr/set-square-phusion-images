#!/bin/bash dry-wit
# Copyright 2015-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3

## Removes unused packages from the system.
## Example:
##   autoremove_packages
function autoremove_packages() {
  local -i _rescode;

  logInfo -n "Removing unused packages";
  ${PKG_REMOVE} > /dev/null
  _rescode=$?;

  if isTrue ${_rescode}; then
    logInfoResult SUCCESS "done";
  else
    logInfoResult FAILURE "failed";
  fi

  return ${_rescode};
}

## Cleans up the system.
## Example:
##   clean_system
function clean_system() {
  local -i _rescode;

  logInfo -n "Cleaning up the system";
  ${SYSTEM_CLEAN} > /dev/null
  _rescode=$?;

  if isTrue ${_rescode}; then
    logInfoResult SUCCESS "done";

    logInfo -n "Autoremoving unused packages";
    ${PKG_AUTOREMOVE} > /dev/null;
    _rescode=$?;

    if isTrue ${_rescode}; then
      logInfoResult SUCCESS "done";
    else
      logInfoResult FAILURE "failed";
    fi
  else
    logInfoResult FAILURE "failed";
  fi

  return ${_rescode};
}

## Deletes all caches.
## Example:
##   remove_cache
function delete_caches() {
  local -i _rescode;

  logInfo -n "Deleting caches";
  ${SYSTEM_CLEAN} > /dev/null
  _rescode=$?;

  if isTrue ${_rescode}; then
    logInfoResult SUCCESS "done";
  else
    logInfoResult FAILURE "failed";
  fi

  return ${_rescode};
}

## Truncates all log files.
## Example:
##   truncate_logs
function truncate_logs() {
  local -i _rescode;

  logInfo -n "Truncating log files";
  find /var/log -type f -name '*.log' -exec bash -c 'echo > {}' \;
  _rescode=$?;

  if isTrue ${_rescode}; then
    logInfoResult SUCCESS "done";
  else
    logInfoResult FAILURE "failed";
  fi

  return ${_rescode};
}

## Wipes the contents of the /tmp.
## Example:
##   wipe_temporary_folder
function wipe_temporary_folder() {
  local -i _rescode;

  logInfo -n "Wiping /tmp";
  rm -rf /tmp/*;
  _rescode=$?;

  if isTrue ${_rescode}; then
    logInfoResult SUCCESS "done";
  else
    logInfoResult FAILURE "failed";
  fi
  rm -rf /tmp/.* > /dev/null 2>&1

  return ${_rescode};
}

## Main logic
## dry-wit hook
function main() {
  autoremove_packages;
  clean_system;
  delete_caches;
  truncate_logs;
  wipe_temporary_folder;
}

## Script metadata and CLI settings.

setScriptDescription "Cleans up the system by removing unused packages.";

addError "INVALID_OPTION" "Unrecognized option";
addError "APTGET_NOT_INSTALLED" "apt-get not found";
checkReq apt-get APTGET_NOT_INSTALLED;
addError "ERROR_REMOVING_UNUSED_PACKAGES" "Error removing unused packages";
#
