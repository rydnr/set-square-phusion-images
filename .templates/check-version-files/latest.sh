#!/bin/bash dry-wit
# Copyright 2016-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3
# mod: check-version/latest
# api: public
# txt: Retrieves the latest version identifier.

# fun: main
# api: public
# txt: Retrieves the latest version identifier.
# txt: Returns 0/TRUE always.
# use: main
function main() {
  local _suffix="$(basename $SCRIPT_NAME .sh)";
  local _version;
  _suffix="${_suffix#latest}";
  local _latest=$("${CHECK_VERSION_SCRIPT}${_suffix}");
  if isNotEmpty "${_latest}"; then
    if retrieve_version; then
      _version="${RESULT}";
      if areEqual "${_latest}" "${_version}"; then
        echo "up to date";
      else
        echo "New version available: ${_latest}";
      fi
    else
      exitWithErrorCode CANNOT_RETRIEVE_SERVICE_VERSION;
    fi
  else
    exitWithErrorCode EMPTY_RESPONSE_FROM_CHECK_VERSION_SCRIPT;
  fi
}

# fun: retrieve_version
# api: public
# txt: Retrieves the service version.
# txt: Returns 0/TRUE if the version could be retrieved; 1/FALSE otherwise.
# txt: If the function succeeds, the variable RESULT contains the service version.
# use: if retrieve_version; then echo "Version: ${RESULT}"; fi
function retrieve_version() {
    local _result;
    local -i _rescode=${FALSE};

    if isNotEmpty "${SERVICE_VERSION}"; then
        _result="${SERVICE_VERSION}";
    elif isNotEmpty "${SERVICE_PACKAGE}" && retrieveVersion "${SERVICE_PACKAGE}"; then
        _result="${RESULT}";
    fi
    if isNotEmpty "${_result}"; then
        _rescode=${TRUE};
        export RESULT="${_result}";
    fi

    return ${_rescode};
}

## Script metadata and CLI options

setScriptDescription "Retrieves the latest version identifier.";

addError CANNOT_RETRIEVE_SERVICE_VERSION "Cannot retrieve the service version, neither via SERVICE_VERSION environment variable nor using dpkg -p ${SERVICE_PACKAGE}";
addError CHECK_VERSION_SCRIPT_UNAVAILABLE "The check-version.sh script is not available";
addError EMPTY_RESPONSE_FROM_CHECK_VERSION_SCRIPT "Empty response from check-version script";

function dw_check_check_version_script_cli_envvar() {
    if ! fileExists "${CHECK_VERSION_SCRIPT}"; then
        exitWithErrorCode CHECK_VERSION_SCRIPT_UNAVAILABLE;
    fi
}


# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
