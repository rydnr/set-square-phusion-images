#!/usr/bin/env dry-wit
# Copyright 2015-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3
# mod: locale/install-locale
# api: public
# txt: Installs a locale (for an encoding).

export DW_DISABLE_ANSI_COLORS=TRUE

DW.import locale

# fun: old_install_locale
# api: public
# txt: Installs given locale.
# opt: locale: The locale.
# txt: Returns 0/TRUE if the locale is installed; 1/FALSE otherwise.
# use: if install_locale "en_US UTF-8"; then echo "Locale en_US UTF-8 installed successfully"; fi
function install_locale() {
  local _locale="${1}"
  local _encoding="${2}"
  local -i _rescode=${FALSE}

  checkNotEmpty "locale" "${_locale}" 1
  checkNotEmpty "encoding" "${_encoding}" 2

  if ! isLocaleDefinedInLocaleGen "${_locale}" "${_encoding}"; then
    addLocaleToLocaleGen "${_locale}" "${_encoding}"
  fi
}

# fun: old_install_locale
# api: public
# txt: Installs given locale.
# opt: locale: The locale.
# txt: Returns 0/TRUE if the locale is installed; 1/FALSE otherwise.
# use: if install_locale "en_US UTF-8"; then echo "Locale en_US UTF-8 installed successfully"; fi
function old_install_locale() {
  local _locale="${1}"
  local _encoding="${2}"
  local -i _rescode=${FALSE}

  checkNotEmpty "locale" "${_locale}" 1
  checkNotEmpty "encoding" "${_encoding}" 2

  local _lang="${_locale%_*}"
  local _output

  logInfo -n "Checking if ${_locale} is already installed"
  if isLocaleSupported "${_locale}" "${_encoding}"; then
    logInfoResult SUCCESS "installed"
  else
    logInfoResult SUCCESS "missing"
    logInfo -n "Installing language-pack-${_lang}-base"
    _output="$(DEBIAN_FRONTEND="noninteractive" command apt-get install -y --reinstall "language-pack-${_lang}-base" 2>&1 || command echo "$$.ERROR.$$")"
    if isNotEmpty "${_output}" && contains "${_output}" "$$.ERROR.$$"; then
      logInfoResult FAILURE "failed"
      logDebug "${_output}"
    else
      logInfoResult SUCCESS "done"
    fi
  fi
  logInfo -n "Checking if ${_locale} ${_encoding} is supported"
  if isLocaleSupported "${_locale}" "${_encoding}"; then
    logInfoResult SUCCESS "valid"
    if localeRequiresEncodingSuffix "${_locale}" "${_encoding}"; then
      command echo "${_locale}.${_encoding} ${_encoding}" >>"${LOCALEGEN}"
      command echo "${_locale}.${_encoding} ${_encoding}" >>"${LOCALENOPURGE}"
      if folderExists "${SUPPORTED_LOCALES_FOLDER}"; then
        command echo "${_locale}.${_encoding} ${_encoding}" >>"${SUPPORTED_LOCALES_FOLDER}/${_lang}"
      fi
      logInfo -n "Running locale-gen ${_locale}.${_encoding}"
      _output="$(command locale-gen "${_locale}.${_encoding}" 2>&1 || command echo "$$.ERROR.$$")"
      if isNotEmpty "${_output}" && contains "${_output}" "$$.ERROR.$$"; then
        logInfoResult FAILURE "failed"
        logDebug "${_output}"
      else
        logInfoResult SUCCESS "done"
      fi
    else
      command echo "${_locale} ${_encoding}" >>"${LOCALEGEN}"
      if folderExists "${SUPPORTED_LOCALES_FOLDER}"; then
        command echo "${_locale} ${_encoding}" >>"${SUPPORTED_LOCALES_FOLDER}/${_lang}"
      fi
      logInfo -n "Running locale-gen ${_locale}"
      _output="$(command locale-gen "${_locale}" 2>&1 || command echo "$$.ERROR.$$")"
      if isNotEmpty "${_output}" && contains "${_output}" "$$.ERROR.$$"; then
        logInfoResult FAILURE "failed"
        logDebug "${_output}"
      else
        logInfoResult SUCCESS "done"
      fi
    fi

    logInfo -n "Running dpkg-reconfigure locales"
    _output="$(command dpkg-reconfigure locales 2>&1 || command echo "$$.ERROR.$$")"
    if isNotEmpty "${_output}" && contains "${_output}" "$$.ERROR.$$"; then
      logInfoResult FAILURE "failed"
      logDebug "${_output}"
    else
      logInfoResult SUCCESS "done"
    fi
    logInfo -n "Running localepurge"
    _output="$(command localepurge 2>&1 || command echo "$$.ERROR.$$")"
    if isNotEmpty "${_output}" && contains "${_output}" "$$.ERROR.$$"; then
      logInfoResult FAILURE "failed"
      logDebug "${_output}"
    else
      logInfoResult SUCCESS "done"
      _rescode=${TRUE}
    fi
  else
    logInfoResult FAILURE "unsupported"
  fi

  return ${_rescode}
}

# fun: main
# api: public
# txt: Installs a locale (for an encoding).
# txt: Returns 0/TRUE if the locale is installed; 1/FALSE otherwise.
# use: main
function main() {
  install_locale "${TARGET_LOCALE}" "${TARGET_ENCODING}"
}

## Script metadata and CLI settings.

setScriptDescription "Installs a locale (for an encoding)"

addCommandLineFlag "locale" "l" "The locale to install (en_US, es_ES, ...)" MANDATORY EXPECTS_ARGUMENT
addCommandLineFlag "encoding" "e" "The encoding (UTF-8, ISO-8859-1, ...)" MANDATORY EXPECTS_ARGUMENT

function dw_parse_locale_cli_flag() {
  export TARGET_LOCALE="${1}"
}

function dw_parse_encoding_cli_flag() {
  export TARGET_ENCODING="${1}"
}

checkReq locale-gen
checkReq apt-get
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
