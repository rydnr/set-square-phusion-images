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
  checkReq openssl OPENSSL_NOT_AVAILABLE;
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
  addError "CANNOT_UPDATE_SSL_KEY_PERMISSIONS" "Cannot update the permissions of the generated key file in ${SSL_KEY_FOLDER}";
  addError "SSL_CERTIFICATE_ALIAS_IS_MANDATORY" "SSL_CERTIFICATE_ALIAS environment variable is mandatory";
  addError "SSL_KEY_ENCRYPTION_IS_MANDATORY" "SSL_KEY_ENCRYPTION environment variable is mandatory";
  addError "SSL_KEY_PASSWORD_IS_MANDATORY" "SSL_KEY_PASSWORD environment variable is mandatory";
  addError "SSL_CERTIFICATE_SUBJECT_IS_MANDATORY" "SSL_CERTIFICATE_SUBJECT environment variable is mandatory";
  addError "SSL_KEY_FOLDER_IS_MANDATORY" "SSL_KEY_FOLDER environment variable is mandatory";
  addError "SERVICE_USER_IS_MANDATORY" "SERVICE_USER environment variable is mandatory";
  addError "SERVICE_GROUP_IS_MANDATORY" "SERVICE_GROUP environment variable is mandatory";
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
      --)
        shift;
        break;
        ;;
      *) logDebugResult FAILURE "failed";
         exitWithErrorCode INVALID_OPTION;
         ;;
    esac
  done

  if isEmpty "${SSL_CERTIFICATE_ALIAS}"; then
    logDebugResult FAILURE "failed";
    exitWithErrorCode SSL_CERTIFICATE_ALIAS_IS_MANDATORY;
  fi

  if isEmpty "${SSL_KEY_ENCRYPTION}"; then
    logDebugResult FAILURE "failed";
    exitWithErrorCode SSL_KEY_ENCRYPTION_IS_MANDATORY;
  fi

  if isEmpty "${SSL_KEY_PASSWORD}"; then
    logDebugResult FAILURE "failed";
    exitWithErrorCode SSL_KEY_PASSWORD_IS_MANDATORY;
  fi

  if isEmpty "${SSL_CERTIFICATE_SUBJECT}"; then
    logDebugResult FAILURE "failed";
    exitWithErrorCode SSL_CERTIFICATE_SUBJECT_IS_MANDATORY;
  fi

  if isEmpty "${SSL_KEY_FOLDER}"; then
      logDebugResult FAILURE "failed";
      exitWithErrorCode SSL_KEY_FOLDER_IS_MANDATORY;
  fi

  if isEmpty "${SERVICE_USER}"; then
    logDebugResult FAILURE "failed";
    exitWithErrorCode SERVICE_USER_IS_MANDATORY;
  fi

  if isEmpty "${SERVICE_GROUP}"; then
    logDebugResult FAILURE "failed";
    exitWithErrorCode SERVICE_GROUP_IS_MANDATORY;
  fi

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
      --)
        shift;
        break;
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
  local _output;

  logInfo -n "Generating a new SSL key pair";
  _output="$(openssl genrsa -${SSL_KEY_ENCRYPTION} -passout pass:"${SSL_KEY_PASSWORD}" -out "${_result}" 2>&1)";
  if isTrue $?; then
    logInfoResult SUCCESS "done";
    export RESULT="${_result}";
  else
    logInfoResult FAILURE "failed";
    logInfo "openssl genrsa -${SSL_KEY_ENCRYPTION} -passout pass:\"${SSL_KEY_PASSWORD}\" -out \"${_result}\"";
    logInfo "${_output}";
    exitWithErrorCode CANNOT_GENERATE_SSL_KEY;
  fi
}

## Generates a certificate signing request.
## -> 1: The output folder.
function generateCSR() {
  local _outputDir="${1}";
  local _result="${_outputDir}/${SSL_CERTIFICATE_ALIAS}.csr";
  local _output;

  logInfo -n "Generating a new SSL certificate signing request";

  _output="$(openssl req \
          -new \
          -passin pass:"${SSL_KEY_PASSWORD}" \
          -passout pass:"${SSL_KEY_PASSWORD}" \
          -key "${_key}" -out "${_result}" \
          -subj "${SSL_CERTIFICATE_SUBJECT}" 2>&1)";

  if isTrue $?; then
    logInfoResult SUCCESS "done";
    export RESULT="${_result}";
  else
    logInfoResult FAILURE "failed";
    logInfo "openssl req -new -passin pass:\"${SSL_KEY_PASSWORD}\" -passout pass:\"${SSL_KEY_PASSWORD}\" -key \"${_key}\" -out \"${_result}\" -subj \"${SSL_CERTIFICATE_SUBJECT}\"";
    logInfo "${_output}";
    exitWithErrorCode CANNOT_GENERATE_SSL_CERTIFICATE;
  fi

}

## Generates a certificate for a given key.
## -> 1: The output folder.
## -> 2: The key.
function generateCertificate() {
  local _outputDir="${1}";
  local _key="${2}";
  local _result="${_outputDir}/${SSL_CERTIFICATE_ALIAS}.crt";
  local _output;

  logInfo -n "Generating a new SSL certificate";

  _output="$(openssl x509 \
          -in "${_csr}" \
          -out "${_result}" \
          -req \
          -signkey "${_key}" \
          -days ${SSL_CERTIFICATE_EXPIRATION_DAYS} \
          -passin pass:"${SSL_KEY_PASSWORD}" 2>&1)";
  if isTrue $?; then
    export RESULT="${_result}";
    logInfoResult SUCCESS "done";
  else
    logInfoResult FAILURE "failed";
    logInfo "openssl x509 \
          -in \"${_csr}\" \
          -out \"${_result}\" \
          -req \
          -signkey \"${_key}\" \
          -days ${SSL_CERTIFICATE_EXPIRATION_DAYS} \
          -passin pass:\"${SSL_KEY_PASSWORD}\"";
    logInfo "${_output}";
    exitWithErrorCode CANNOT_GENERATE_SSL_CERTIFICATE;
  fi

}

## Changes the permissions of given folder.
## -> 1: The folder to update.
## -> 2: The user.
## -> 3: The group.
function updateFolderPermissions() {
  local _dir="${1}";
  local _user="${2}";
  local _group="${3}";
  local _output;

  logInfo -n "Fixing permissions of ${_dir}";

  _output="$(chown -R ${_user}:${_group} ${_dir})";

  if isTrue $?; then
      logInfoResult SUCCESS "done";
  else
    logInfoResult FAILURE "failed";
    logInfo "chown -R ${_user}:${_group} ${_dir}";
    logInfo "${_output}";
    exitWithErrorCode CANNOT_UPDATE_SSL_KEY_FOLDER_PERMISSIONS;
  fi
}

## Changes the permissions of given SSL key.
## -> 1: The key file to update.
function updateSslKeyPermissions() {
  local _keyFile="${1}";
  local _output;

  checkNotEmpty "keyFile" "${_keyFile}" 1;

  logInfo -n "Fixing permissions of ${_dir}";

  _output="$(chmod 0700 ${_keyFile})";

  if isTrue $?; then
      logInfoResult SUCCESS "done";
  else
    logInfoResult FAILURE "failed";
    logInfo "chmod 0700 ${_keyFile}";
    logInfo "${_output}";
    exitWithErrorCode CANNOT_UPDATE_SSL_KEY_PERMISSIONS;
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

  updateSslKeyPermissions "${_key}";
}
