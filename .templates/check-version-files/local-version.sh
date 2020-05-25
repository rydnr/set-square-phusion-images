#!/bin/bash dry-wit
# Copyright 2016-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3
# mod: check-version/local-version.sh
# api: public
# txt: Checks whether the current version is the latest available.

# txt: Checks whether the current version is the latest available.
# api: public
# txt: Returns 0/TRUE always, unless the version of the service cannot be retrieved.
# use: main;
function main() {
  local _result;

  if isNotEmpty "${SERVICE_VERSION}"; then
    _result="${SERVICE_VERSION}";
  elif isNotEmpty "${SERVICE_PACKAGE}"; then
    _result="$(dpkg -p ${SERVICE_PACKAGE} | grep -e '^Version: ' | cut -d' ' -f2)";
  fi
  if isEmpty ${_result}; then
    exitWithErrorCode CANNOT_RETRIEVE_SERVICE_VERSION;
  fi

  export RESULT="${_result}";
}

setScriptDescription "Checks whether the current version is the latest available.";
addError CANNOT_RETRIEVE_SERVICE_VERSION "Cannot retrieve the service version, neither via SERVICE_VERSION environment variable nor using dpkg -p ${SERVICE_PACKAGE}";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet

