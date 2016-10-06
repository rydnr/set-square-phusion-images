#!/bin/bash dry-wit
# Copyright 2015-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3

function usage() {
cat <<EOF
$SCRIPT_NAME locale encoding
$SCRIPT_NAME [-h|--help]
(c) 2016-today Automated Computing Machinery S.L.
    Distributed under the terms of the GNU General Public License v3

Installs given locale.

Where:
  - locale: The locale to install (en_US.UTF-8, es_ES.ISO-8859-1, ...).
  - encoding: The encoding (UTF-8, ISO-8859-1, ...)

Common flags:
    * -h | --help: Display this message.
    * -v: Increase the verbosity.
    * -vv: Increase the verbosity further.
    * -q | --quiet: Be silent.
EOF
}

# Requirements
function defineRequirements() {
  checkReq locale-gen "LOCALEGEN_IS_NOT_INSTALLED";
  checkReq apt-get "APTGET_IS_NOT_INSTALLED";
}

## Defines the errors
## dry-wit hook
function defineErrors() {
  addError "INVALID_OPTION" "Unrecognized option";
  addError "LOCALEGEN_IS_NOT_INSTALLED" "locale-gen is not installed";
  addError "APTGET_IS_NOT_INSTALLED" "apt-get is not installed";
  addError "TARGET_LOCALE_IS_MANDATORY" "The locale parameter is mandatory";
  addError "TARGET_ENCODING_IS_MANDATORY" "The encoding parameter is mandatory";
}

## Validates the input.
## dry-wit hook
function checkInput() {

  local _flags=$(extractFlags $@);
  local _flagCount;
  local _currentCount;
  logDebug -n "Checking input";

  # Flags
  for _flag in ${_flags}; do
    _flagCount=$((_flagCount+1));
    case ${_flag} in
      -h | --help | -v | -vv | -q)
         shift;
         ;;
      *) logDebugResult FAILURE "failed";
         exitWithErrorCode INVALID_OPTION;
         ;;
    esac
  done

  if isEmpty "${TARGET_LOCALE}"; then
    logDebugResult FAILURE "failed";
    exitWithErrorCode TARGET_LOCALE_IS_MANDATORY;
  elif isEmpty "${TARGET_ENCODING}"; then
      logDebugResult FAILURE "failed";
      exitWithErrorCode TARGET_ENCODING_IS_MANDATORY;
  else
    logDebugResult SUCCESS "valid";
  fi
}

## Parses the input
## dry-wit hook
function parseInput() {

  local _flags=$(extractFlags $@);
  local _flagCount;
  local _currentCount;

  # Flags
  for _flag in ${_flags}; do
    _flagCount=$((_flagCount+1));
    case ${_flag} in
      -h | --help | -v | -vv | -q)
         shift;
         ;;
    esac
  done

  if isEmpty "${TARGET_LOCALE}"; then
      TARGET_LOCALE="${1}";
      shift;
  fi

  if isEmpty "${TARGET_ENCODING}"; then
      TARGET_ENCODING="${1}";
  fi
}

## Checks if given locale identifier is supported.
## -> *: The locale identifier.
## <- 0/${TRUE} if the locale is supported; 1/${FALSE} otherwise.
## Example:
##  if is_locale_supported "en_US"; then
##    echo "en_US is supported"
##  fi
function is_locale_supported() {
  local _locale="${*}";
  local -i _rescode;

  if [ -f ${AVAILABLE_LOCALES_FOLDER}/${_locale} ]; then
      _rescode=${TRUE};
  else
    _rescode=${FALSE};
  fi

  return ${_rescode};
}

## Installs given locale.
## -> 1: The locale.
## <- 0/${TRUE} if the locale is installed; 1/${FALSE} otherwise.
## Example:
##   if install_locale "en_US UTF-8"; then
##     echo "Locale en_US UTF-8 installed successfully";
##   fi
function install_locale() {
  local _locale="${1}";
  local _encoding="${2}";
  local _rescode=${FALSE};

  local _lang="${_locale%_*}";
  local _country="${_locale#*_}";
  _country="${_country%@*}";
  local _extra="${_locale#*@}";
  if [ "${_extra}" == "${_locale}" ]; then
     _extra="";
  fi

  DEBIAN_FRONTEND="noninteractive" apt-get install -y language-pack-${_lang}-base
  logInfo -n "Checking if ${_lang}_${_country} is supported";
  if is_locale_supported "${_lang}_${_country}${_extra}"; then
      logInfoResult SUCCESS "valid";
      logInfo "Generating '${_lang}_${_country}${_extra} ${_encoding}' locale";
      echo "${_lang}_${_country}${_extra} ${_encoding}" >> ${LOCALEGEN};
      echo "${_lang}_${_country}${_extra}.${_encoding} ${_encoding}" >> ${LOCALEGEN};
      locale-gen
      dpkg-reconfigure locales
      localepurge
      _rescode=${TRUE};
  else
    logInfoResult FAILURE "unsupported";
  fi

  return ${_rescode};
}

## Main logic
## dry-wit hook
function main() {
  install_locale "${TARGET_LOCALE}" "${TARGET_ENCODING}";
}
