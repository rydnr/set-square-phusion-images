#!/bin/bash dry-wit
# Copyright 2015-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3

function usage() {
cat <<EOF
$SCRIPT_NAME
$SCRIPT_NAME [-h|--help]
(c) 2015-today Automated Computing Machinery S.L.
    Distributed under the terms of the GNU General Public License v3

Creates a SSL certificate.
See http://www.eclipse.org/jetty/documentation/current/configuring-ssl.html

Common flags:
    * -h | --help: Display this message.
    * -v: Increase the verbosity.
    * -vv: Increase the verbosity further.
    * -q | --quiet: Be silent.
EOF
}

## Defines required dependencies
## dry-wit hook
function defineReq() {
  checkReq keytool KEYTOOL_NOT_AVAILABLE;
}

## Defines the errors
## dry-wit hook
function defineErrors() {
  export INVALID_OPTION="Unrecognized option";
  export KEYTOOL_NOT_AVAILABLE="keytool is not installed";
  export CANNOT_CREATE_SSL_KEY="Cannot create the SSL key pair";
  export CANNOT_SIGN_SSL_CERTIFICATE="Cannot sign the SSL certificate";

  ERROR_MESSAGES=(\
    INVALID_OPTION \
    KEYTOOL_NOT_AVAILABLE \
    CANNOT_CREATE_SSL_KEY \
    CANNOT_SIGN_SSL_CERTIFICATE \
  );

  export ERROR_MESSAGES;
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

  logDebugResult SUCCESS "valid";
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
}

## Generates a key pair.
## -> 1: The output folder.
function generateKeyPair() {
  local _outputDir="${1}";
  logInfo -n "Generating new SSL keys and certificates";
  pushd "${_outputDir}" > /dev/null;
  keytool -keystore "${SSL_KEYSTORE_NAME}" \
          -alias "${SSL_CERTIFICATE_ALIAS}" \
          -genkey \
          -noprompt \
          -dname "${SSL_CERTIFICATE_DNAME}" \
          -keyalg "${SSL_KEY_ALGORITHM}" \
          -keypass "${SSL_KEY_PASSWORD}" \
          -storepass "${SSL_STORE_PASSWORD}";
  if [ $? -eq 0 ]; then
      export RESULT="${_result}";
      logInfoResult SUCCESS "done";
  else
    export RESULT="";
    logInfoResult FAILURE "failed";
    exitWithErrorCode CANNOT_CREATE_SSL_KEY;
  fi
  popd > /dev/null;
}

## Signs the certificate with the default key.
## -> 1: The output folder.
function signCertificate() {
  local _outputDir="${1}";
  logInfo -n "Signing the SSL certificate";
  pushd "${_outputDir}" > /dev/null;
  keytool -keystore "${SSL_KEYSTORE_NAME}" \
          -alias "${SSL_CERTIFICATE_ALIAS}" \
          -genkey \
          -noprompt \
          -dname "${SSL_CERTIFICATE_DNAME}" \
          -keyalg "${SSL_KEY_ALGORITHM}" \
          -keypass "${SSL_KEY_PASSWORD}" \
          -storepass "${SSL_STORE_PASSWORD}" \
          -sigalg "${SSL_SIGN_ALGORITHM}" \
          -ext "SAN=${SSL_SAN_EXTENSIONS}";
  if [ $? -eq 0 ]; then
      export RESULT="${_result}";
      logInfoResult SUCCESS "done";
  else
    export RESULT="";
    logInfoResult FAILURE "failed";
    exitWithErrorCode CANNOT_SIGN_SSL_CERTIFICATE;
  fi
  popd > /dev/null;
}

## Main logic
## dry-wit hook
function main() {
  generateKeyPair ${SSL_KEY_FOLDER};
  signCertificate ${SSL_KEY_FOLDER};
}
