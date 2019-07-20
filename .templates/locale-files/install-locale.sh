#!/bin/bash dry-wit
# Copyright 2015-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3
# mod: locale/install-locale
# api: public
# txt: Installs a locale (for an encoding).

DW.import locale;

# fun: install_locale
# api: public
# txt: Installs given locale.
# opt: locale: The locale.
# txt: Returns 0/TRUE if the locale is installed; 1/FALSE otherwise.
# use: if install_locale "en_US UTF-8"; then echo "Locale en_US UTF-8 installed successfully"; fi
function install_locale() {
  local _locale="${1}";
  local _encoding="${2}";
  local -i _rescode=${FALSE};

  checkNotEmpty "locale" "${_locale}" 1;
  checkNotEmpty "encoding" "${_encoding}" 2;

  local _lang="${_locale%_*}";

  logInfo -n "Checking if ${_locale} is already installed";
  if is_locale_supported "${_locale}" "${_encoding}"; then
      logInfoResult SUCCESS "installed";
  else
    logInfoResult SUCCESS "missing";
    DEBIAN_FRONTEND="noninteractive" apt-get install -y --reinstall language-pack-${_lang}-base
  fi
  logInfo -n "Checking if ${_locale} ${_encoding} is supported";
  if is_locale_supported "${_locale}" "${_encoding}"; then
      logInfoResult SUCCESS "valid";
      if locale_requires_encoding_suffix "${_locale}" "${_encoding}"; then
          logInfo "Generating '${_locale}.${_encoding} ${_encoding}' locale";
          echo "${_locale}.${_encoding} ${_encoding}" >> ${LOCALEGEN};
          locale-gen "${_locale}.${_encoding}"
      else
        logInfo "Generating '${_locale} ${_encoding}' locale";
        echo "${_locale} ${_encoding}" >> ${LOCALEGEN};
        locale-gen "${_locale}"
      fi
#      dpkg-reconfigure locales
      localepurge
      _rescode=${TRUE};
  else
    logInfoResult FAILURE "unsupported";
  fi

  return ${_rescode};
}

# fun: main
# api: public
# txt: Installs a locale (for an encoding).
# txt: Returns 0/TRUE if the locale is installed; 1/FALSE otherwise.
# use: main
function main() {
  install_locale "${TARGET_LOCALE}" "${TARGET_ENCODING}";
}

## Script metadata and CLI settings.

setScriptDescription "Installs a locale (for an encoding)";

addCommandLineFlag "locale" "l" "The locale to install (en_US, es_ES, ...)" MANDATORY EXPECTS_ARGUMENT;
addCommandLineFlag "encoding" "e" "The encoding (UTF-8, ISO-8859-1, ...)" MANDATORY EXPECTS_ARGUMENT;

function dw_parse_locale_cli_flag() {
  export TARGET_LOCALE="${1}";
}

function dw_parse_encoding_cli_flag() {
  export TARGET_ENCODING="${1}";
}

checkReq locale-gen;
checkReq apt-get;
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
