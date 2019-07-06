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

  logInfo -n "Updating system (this can take some time)";
  ${APTGET_UPDATE} > /dev/null 2>&1
  _rescode=$?;

  if isTrue ${_rescode}; then
    logInfoResult SUCCESS "done";
  else
    logInfoResult FAILURE "failed";
  fi

  return ${_rescode};
}

## Checks the ${INSTALLED_PACKAGES_FILE} is writable.
## Example:
##   check_packages_file_writable
function check_packages_file_writable() {
  logDebug -n "Checking if ${INSTALLED_PACKAGES_FILE} is writable";
  if fileIsWritable "${INSTALLED_PACKAGES_FILE}"; then
    logDebugResult SUCCESS "true";
  else
    logDebugResult FAILURE "false";
    exitWithErrorCode CANNOT_WRITE_TO_INSTALLED_PACKAGES_FILE ${INSTALLED_PACKAGES_FILE};
  fi
}

## Checks whether the -np flag is enabled
## Example:
##   if no_pin_enabled; then [..]; fi
function no_pin_enabled() {
  _flagEnabled NO_PIN;
}

## Installs a package.
## -> 1: the package to install
## Example:
##   install_package wget
function install_package() {
  local _package="${1}";
  local -i _aux;

  logInfo -n "Checking if ${_package} is already installed";
  grep -e "^${_package}$" ${INSTALLED_PACKAGES_FILE} > /dev/null
  if isTrue $?; then
    logInfoResult SUCCESS "true";
  else
    logInfoResult SUCCESS "false";
    logInfo "Installing ${_package}";
    runCommandLongOutput "apt-get install -y ${EXTRA_ARGS} --no-install-recommends ${_package}"
    _aux=$?;
    logInfo -n "Installing ${_package}";
    if isTrue ${_aux}; then
      echo "${_package}" >> ${INSTALLED_PACKAGES_FILE}
      logInfoResult SUCCESS "done";
    else
      logInfoResult FAILURE "failed";
      exitWithErrorCode ERROR_INSTALLING_PACKAGE "${_package}";
    fi
  fi
}

## Marks a package as sticky, so that it doesn't
## get automatically removed assuming it's not used.
## -> 1: the package to pin
## Example:
##   pin_package wget
function pin_package() {
  local _package="${1}";
  logInfo -n "Pinning ${_package}";
  ${HOLD_PACKAGE} ${_package} > /dev/null 2>&1
  if isTrue $?; then
    logInfoResult SUCCESS "done";
  else
    logInfoResult FAILURE "failed";
    exitWithErrorCode ERROR_PINNING_PACKAGE "${_package} ($(${HOLD_PACKAGE} ${_package}))";
  fi
}

## Checks whether the Ubuntu APT cache is missing.
## <- 0/${TRUE} if the cache is missing; 1/${FALSE} otherwise.
## Example:
##   if isUbuntuAptCacheMissing; then
##     echo "Ubuntu APT cache is missing"
##   fi
function isUbuntuAptCacheMissing() {
  local -i _rescode;
  local _cacheFolder="${APT_CACHE_FOLDER}";
  local -i _aux;

  if [ -e ${_cacheFolder} ]; then
      _aux=$(ls ${_cacheFolder} > /dev/null | wc -l);
      if [ ${_aux} -eq 0 ]; then
          _rescode=${TRUE};
      else
        _rescode=${FALSE};
      fi
  else
    _rescode=${TRUE};
  fi

  return ${_rescode};
}

## Main logic
## dry-wit hook
function main() {
  local _package;
  local _oldIFS="${IFS}";

  if isTrue ${UPDATE} || isUbuntuAptCacheMissing; then
    update_system;
  fi

  check_packages_file_writable;

  IFS="${DWIFS}";
  for _package in ${PACKAGES}; do
    IFS="${_oldIFS}";
    install_package "${_package}";
    if ! no_pin_enabled; then
      pin_package "${_package}";
    fi
  done
  IFS="${_oldIFS}";
}

## Script metadata and CLI settings.

setScriptDescription "Installs packages via apt-get, so that their impact in the
overall image size is better. It requires the Dockerfile to install
packages using this script, and afterwards call aptget-cleanup.sh
to remove unnecessary dependencies.";
addCommandLineFlag "update" "u" "Update the system before installing anything" OPTIONAL NO_ARGUMENT "false";
addCommandLineFlag "no-pin" "np" "Do not pin the package" OPTIONAL NO_ARGUMENT "false";

addCommandLineParameter "packages" "The package(s) to install" MANDATORY MULTIPLE;

function dw_parse_packages_cli_parameter() {
  export PACKAGES="${@}";
}

addError "INVALID_OPTION" "Unrecognized option";
addError "APTGET_NOT_INSTALLED" "apt-get not found";
addError "APTMARK_NOT_INSTALLED" "apt-mark not found";
addError "NO_PACKAGES_SPECIFIED" "No packages specified";
addError "CANNOT_WRITE_TO_INSTALLED_PACKAGES_FILE" 'Cannot write to ';
addError "ERROR_INSTALLING_PACKAGE" "Error installing ";
addError "ERROR_PINNING_PACKAGE" 'Error pinning ';

checkReq apt-get;
checkReq apt-mark;
#
