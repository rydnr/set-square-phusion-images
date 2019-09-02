#!/bin/bash dry-wit
# Copyright 2016-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3
# mod: check-version/check-version
# api: public
# txt: Checks whether the current version is the latest available.

# fun: main
# api: public
# txt: Checks whether the current version is the latest available.
# txt: Returns 0/TRUE always, unless an error is thrown.
# use: main
function main() {
  local _local=$("${LOCAL_VERSION_SCRIPT}");
  if isEmpty "${_local}"; then
    exitWithErrorCode EMPTY_RESPONSE_FROM_LOCAL_VERSION_SCRIPT;
  fi
  local _remote=$("${REMOTE_VERSION_SCRIPT}");
  if isEmpty "${_remote}"; then
    exitWithErrorCode EMPTY_RESPONSE_FROM_REMOTE_VERSION_SCRIPT;
  fi
  if areEqual "${_remote}" "${_local}"; then
    echo "up to date";
  else
    echo "Current version: ${_local}";
    echo "New version available: ${_remote}";
  fi
}

## Script metadata and CLI options.
setScriptDescription "Checks whether the current version is the latest available.";
addError LOCAL_VERSION_SCRIPT_UNAVAILABLE "The local-version script is not available";
addError REMOTE_VERSION_SCRIPT_UNAVAILABLE "The remote-version script is not available";
addError EMPTY_RESPONSE_FROM_LOCAL_VERSION_SCRIPT "Empty response from local-version script";
addError EMPTY_RESPONSE_FROM_REMOTE_VERSION_SCRIPT "Empty response from remote-version script";

function dw_check_local_version_script_cli_envvar() {
  if ! fileExists "${LOCAL_VERSION_SCRIPT}"; then
    exitWithErrorCode LOCAL_VERSION_SCRIPT_UNAVAILABLE;
  fi
}

function dw_check_remote_version_script_cli_envvar() {
  if ! fileExists "${REMOTE_VERSION_SCRIPT}"; then
    exitWithErrorCode REMOTE_VERSION_SCRIPT_UNAVAILABLE;
  fi
}
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
