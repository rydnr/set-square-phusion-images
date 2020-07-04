#!/bin/bash dry-wit
# Copyright 2015-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3
# mod: aptget-install
# api: public
# txt: Installs packages via apt-get, so that their impact in the
# txt: overall image size is better. It requires the Dockerfile to install
# txt: packages using this script, and afterwards call aptget-cleanup.sh
# txt: to remove unnecessary dependencies.

DW.import ubuntu;

# fun: main
# api: public
# txt: Installs packages via apt-get, so that their impact in the
# txt: overall image size is better. It requires the Dockerfile to install
# txt: packages using this script, and afterwards call aptget-cleanup.sh
# txt: to remove unnecessary dependencies.
# txt: Returns 0/TRUE always, but can exit if the operation fails.
# use: main;
function main() {
  if isTrue ${UPDATE} || isUbuntuAptCacheMissing; then
    update_system;
  fi

  check_packages_file_writable;

  local _oldIFS="${IFS}";
  IFS="${DWIFS}";
  local _package;
  for _package in ${PACKAGES}; do
    IFS="${_oldIFS}";
    install_package "${_package}";
    if ! no_pin_enabled; then
      pin_package "${_package}";
    fi
  done
  IFS="${_oldIFS}";
}

# fun: update_system
# api: public
# txt: Updates the system via apt-get update.
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

# fun: check_packages_file_writable
# api: public
# txt: Checks the ${INSTALLED_PACKAGES_FILE} is writable.
# txt: Returns 0/TRUE always, but can exit if the file is not writable.
# use: check_packages_file_writable;
function check_packages_file_writable() {
  logDebug -n "Checking if ${INSTALLED_PACKAGES_FILE} is writable";

  if fileIsWritable "${INSTALLED_PACKAGES_FILE}"; then
    logDebugResult SUCCESS "true";
  else
    logDebugResult FAILURE "false";
    exitWithErrorCode CANNOT_WRITE_TO_INSTALLED_PACKAGES_FILE ${INSTALLED_PACKAGES_FILE};
  fi
}

# fun: no_pin_enabled
# api: public
# txt: Checks whether the -np flag is enabled
# txt: Returns 0/TRUE if the no-pin flag is enabled.
# use: if no_pin_enabled; then
# use:   ...
# use: fi
function no_pin_enabled() {
  flagEnabled NO_PIN;
}

# fun: install_package package
# api: public
# txt: Installs given package.
# opt: package: The package to install.
# txt: Returns 0/TRUE always, but can exit if the package cannot be installed.
# use: install_package wget;
function install_package() {
  local _package="${1}";
  checkNotEmpty package "${_package}" 1;

  logInfo -n "Checking if ${_package} is already installed";
  grep -e "^${_package}$" "${INSTALLED_PACKAGES_FILE}" > /dev/null
  if isTrue $?; then
    logInfoResult SUCCESS "true";
  else
    logInfoResult SUCCESS "false";

    logInfo "Installing ${_package}";
    installPackage "${_package}" ${EXTRA_ARGS};
    local -i _aux=$?;

    logInfo -n "Installing ${_package}";
    if isTrue ${_aux}; then
      echo "${_package}" >> "${INSTALLED_PACKAGES_FILE}"
      logInfoResult SUCCESS "done";
    else
      logInfoResult FAILURE "failed";
      exitWithErrorCode ERROR_INSTALLING_PACKAGE "${_package}";
    fi
  fi
}

# fun: pin_package
# api: public
# txt: Marks a package as sticky, so that it doesn't get automatically removed assuming it's not used.
# opt: package: The package to pin.
# txt: Returns 0/TRUE always, but can exit if the package cannot be pinned.
# use: pin_package wget;
function pin_package() {
  local _package="${1}";
  checkNotEmpty package "${_package}" 1;

  logInfo -n "Pinning ${_package}";
  pinUbuntuPackagke ${_package};
  if isTrue $?; then
    logInfoResult SUCCESS "done";
  else
    logInfoResult FAILURE "failed";
    exitWithErrorCode ERROR_PINNING_PACKAGE "${_package} ($(${HOLD_PACKAGE} ${_package}))";
  fi
}

# Script metadata
setScriptDescription "Installs packages via apt-get, so that their impact in the \
overall image size is better. It requires the Dockerfile to install \
packages using this script, and afterwards call aptget-cleanup.sh \
to remove unnecessary dependencies.";

addError NO_PACKAGES_SPECIFIED "No packages specified";
addError CANNOT_WRITE_TO_INSTALLED_PACKAGES_FILE 'Cannot write to ';
addError ERROR_INSTALLING_PACKAGE "Error installing ";
addError ERROR_PINNING_PACKAGE 'Error pinning ';

addCommandLineParameter package "The package(s) to install" MANDATORY MULTIPLE;
addCommandLineFlag update u "Update the system before installing anything" OPTIONAL NO_ARGUMENT;
addCommandLineFlag "no-pin" np "Do not pin the package(s)" OPTIONAL NO_ARGUMENT;

defineEnvVar INSTALLED_PACKAGES_FILE OPTIONAL "The file to annotate the explicitly-installed packages" "/var/local/docker-installed-packages.txt";

function dw_parse_package_cli_parameter() {
  export PACKAGES="${@}";
}

function dw_parse_update_cli_flag() {
  export UPDATE=${TRUE};
}

function dw_parse_update_cli_flag() {
  export NO_PIN=${TRUE};
}
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
