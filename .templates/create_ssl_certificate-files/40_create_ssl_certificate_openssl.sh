#!/bin/bash dry-wit
# Copyright 2015-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3

function usage() {
cat <<EOF
$SCRIPT_NAME
$SCRIPT_NAME [-h|--help]
(c) 2015-today Automated Computing Machinery S.L.
    Distributed under the terms of the GNU General Public License v3

Creates a SSL certificate with OpenSSL.
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
  checkReq openssl;
}

## Defines the errors
## dry-wit hook
function defineErrors() {
  addError "INVALID_OPTION" "Unrecognized option";
  addError "OPENSSL_NOT_AVAILABLE" "openssl is not installed";
  addError "CANNOT_GENERATE_SSL_KEY" "Cannot generate the SSL key pair";
  addError "CANNOT_GENERATE_SSL_CERTIFICATE" "Cannot generate the SSL certificate";
  addError "CANNOT_SIGN_SSL_CERTIFICATE" "Cannot sign the SSL certificate";
  addError "CANNOT_UPDATE_SSL_KEY_FOLDER_PERMISSIONS" "Cannot update the permissions of ${SSL_KEY_FOLDER}";
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
## <- RESULT: The file with the private key.
function generateKeyPair() {
  local _outputDir="${1}";
  local _result="${_outputDir}/${SSL_CERTIFICATE_ALIAS}.key";

  logInfo -n "Generating a new SSL key pair";
  openssl genrsa -${SSL_KEY_ENCRYPTION} \
          -passout pass:"${SSL_KEY_PASSWORD}" \
          -out "${_result}" > /dev/null 2>&1;
  if [ $? -eq 0 ]; then
    logInfoResult SUCCESS "done";
  else
    _result="";
    logInfoResult FAILURE "failed";
    exitWithErrorCode CANNOT_GENERATE_SSL_KEY;
  fi

  export RESULT="${_result}";
}

## Generates a certificate signing request.
## -> 1: The output folder.
function generateCSR() {
  local _outputDir="${1}";
  local _result="${_outputDir}/${SSL_CERTIFICATE_ALIAS}.csr";

  logInfo -n "Generating a new SSL certificate signing request";

  openssl req \
          -new \
          -passin pass:"${SSL_KEY_PASSWORD}" \
          -passout pass:"${SSL_KEY_PASSWORD}" \
          -key "${_key}" -out "${_result}" \
          -subj "${SSL_CERTIFICATE_SUBJECT}" > /dev/null 2>&1;
  if [ $? -eq 0 ]; then
    logInfoResult SUCCESS "done";
  else
    _result="";
    logInfoResult FAILURE "failed";
    exitWithErrorCode CANNOT_GENERATE_SSL_CERTIFICATE;
  fi

  export RESULT="${_result}";
}

## Generates a certificate for a given key.
## -> 1: The output folder.
## -> 2: The key.
function generateCertificate() {
  local _outputDir="${1}";
  local _key="${2}";
  local _result="${_outputDir}/${SSL_CERTIFICATE_ALIAS}.crt";

  logInfo -n "Generating a new SSL certificate";

  openssl x509 \
          -in "${_csr}" \
          -out "${_result}" \
          -req \
          -signkey "${_key}" \
          -days ${SSL_CERTIFICATE_EXPIRATION_DAYS} \
          -passin pass:"${SSL_KEY_PASSWORD}" > /dev/null 2>&1;
  if [ $? -eq 0 ]; then
    logInfoResult SUCCESS "done";
  else
    _result="";
    logInfoResult FAILURE "failed";
    exitWithErrorCode CANNOT_GENERATE_SSL_CERTIFICATE;
  fi

  export RESULT="${_result}";
}

## Changes the permissions of given folder.
## -> 1: The folder to update.
## -> 2: The user.
## -> 3: The group.
function updateFolderPermissions() {
  local _dir="${1}";
  local _user="${2}";
  local _group="${3}";

  logInfo -n "Fixing permissions of ${_dir}";

  chown -R ${_user}:${_group} ${_dir};

  if [ $? -eq 0 ]; then
      logInfoResult SUCCESS "done";
  else
    logInfoResult FAILURE "failed";
    exitWithErrorCode CANNOT_UPDATE_SSL_KEY_FOLDER_PERMISSIONS;
  fi
}

## Main logic
## dry-wit hook
function main() {
  local _key;
  local _csr;
  generateKeyPair ${SSL_KEY_FOLDER};
  _key="${RESULT}";
  generateCSR "${SSL_KEY_FOLDER}" "${_key}";
  _csr="${RESULT}";
  generateCertificate "${SSL_KEY_FOLDER}" "${_key}" "${_csr}";

  updateFolderPermissions "${SSL_KEY_FOLDER}" "${SERVICE_USER}" "${SERVICE_GROUP}";
}
