#!/bin/bash dry-wit
# Copyright 2016-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3

## Main logic
## dry-wit hook
function main() {
  local _result;
  local _package;
  local _rescode=-1;

  if ! isEmpty "${PACKAGE}"; then
    _package="${PACKAGE}";
  elif ! isEmpty "${SERVICE_PACKAGE}"; then
    _package="${SERVICE_PACKAGE}";
  fi

  logDebug -n "Checking ${PACKAGE} local version";
  _result="$(apt-get update > /dev/null; apt-cache madison ${_package} | grep 'Packages' | head -n 1 | awk '{print $3;}'; /usr/local/sbin/system-cleanup.sh > /dev/null)";
  _rescode=$?;
  if ! isTrue ${_rescode}; then
    logDebugResult FAILURE "${_result}";
    exitWithErrorCode CANNOT_RETRIEVE_PACKAGE_VERSION;
  fi

  if isEmpty ${_result}; then
    logDebugResult FAILURE "${_result}";
    exitWithErrorCode CANNOT_RETRIEVE_PACKAGE_VERSION;
  else
    logDebugResult SUCCESS "${_result}";
    echo "${_result}";
  fi
}

## Script metadata and CLI options
setScriptDescription "Retrieves the current version of a given package."
setScriptLicenseSummary "Distributed under the terms of the GNU General Public License v3";
setScriptCopyright "Copyleft 2015-today Automated Computing Machinery S.L.";

addCommandLineParameter package "The package to check the version of" OPTIONAL SINGLE;
defineEnvVar SERVICE_PACKAGE OPTIONAL "The default package of this image" "${SQ_SERVICE_PACKAGE}";

addError EITHER_PACKAGE_OR_SERVICE_PACKAGE_MUST_BE_PROVIDED "Either package parameter or SERVICE_PACKAGE environment variable must be provided";
addError CANNOT_RETRIEVE_PACKAGE_VERSION "Cannot retrieve the packge version";

## Validates the input.
## dry-wit hook
function dw_checkInput() {
  if isEmpty "${PACKAGE}" && isEmpty "${SERVICE_PACKAGE}"; then
    exitWithErrorCode EITHER_PACKAGE_OR_SERVICE_PACKAGE_MUST_BE_PROVIDED;
  fi
}
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
