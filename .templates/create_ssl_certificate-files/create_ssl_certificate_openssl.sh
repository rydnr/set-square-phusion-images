#!/bin/bash dry-wit
# Copyright 2015-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3
# mod: create_ssl_certificate_openssl
# api: public
# txt: Creates a SSL certificate with OpenSSL. See http://www.eclipse.org/jetty/documentation/current/configuring-ssl.html

DW.import ssl;

# fun: main
# api: public
# txt: Creates a SSL certificate with OpenSSL. See http://www.eclipse.org/jetty/documentation/current/configuring-ssl.html
# txt: Always returns 0/TRUE, unless it exits with an error.
# use: main
function main() {
  local _key;
  local _csr;

  logInfo -n "Generating a new SSL key pair";
  if generateKeyPair "${SSL_KEY_FOLDER}" "${SSL_CERTIFICATE_ALIAS}" "${SSL_KEY_PASSWORD}" "${SSL_KEY_ENCRYPTION}"; then
    _key="${RESULT}";
    logInfoResult SUCCESS "done";
  else
    logInfoResult FAILURE "failed";
    exitWithErrorCode CANNOT_GENERATE_SSL_KEY;
  fi

  logInfo -n "Generating a new SSL certificate signing request";
  if generateCSR "${SSL_KEY_FOLDER}" "${SSL_CERTIFICATE_ALIAS}" "${_key}" "${SSL_KEY_PASSWORD}" "${SSL_CERTIFICATE_SUBJECT}"; then
      _csr="${RESULT}";
      logInfoResult SUCCESS "done";
  else
      logInfoResult FAILURE "failed";
      exitWithErrorCode CANNOT_GENERATE_SSL_CERTIFICATE;
  fi

  logInfo -n "Generating a new SSL certificate";
  if generateCertificate "${SSL_KEY_FOLDER}" "${SSL_CERTIFICATE_ALIAS}" "${_csr}" "${_key}" "${SSL_KEY_PASSWORD}" "${SSL_CERTIFICATE_EXPIRATION_DAYS}"; then
    logInfoResult SUCCESS "done";
  else
    logInfoResult FAILURE "failed";
    exitWithErrorCode CANNOT_GENERATE_SSL_CERTIFICATE;
  fi

  logInfo -n "Fixing permissions of ${SSL_KEY_FOLDER}";
  if changeOwnerOfFolderRecursively "${SSL_KEY_FOLDER}" "${SERVICE_USER}" "${SERVICE_GROUP}"; then
    logInfoResult SUCCESS "done";
  else
    logInfoResult FAILURE "failed";
    exitWithErrorCode CANNOT_UPDATE_SSL_KEY_FOLDER_PERMISSIONS;
  fi

  logInfo -n "Fixing permissions of ${_key}";
  if changeSslKeyPermissions "${_key}"; then
    logInfoResult SUCCESS "done";
  else
    logInfoResult FAILURE "failed";
    exitWithErrorCode CANNOT_UPDATE_SSL_KEY_PERMISSIONS "${_key}";
  fi

  logInfo -n "Fixing ownership of ${_key}";
  if changeSslKeyOwnership "${_key}" "${SERVICE_USER}" "${SERVICE_GROUP}"; then
    logInfoResult SUCCESS "done";
  else
    logInfoResult FAILURE "failed";
    exitWithErrorCode CANNOT_UPDATE_SSL_KEY_OWNERSHIP "${_key}";
  fi
}

## Script metadata and CLI options
setScriptDescription "Creates a SSL certificate with OpenSSL.
See http://www.eclipse.org/jetty/documentation/current/configuring-ssl.html";

checkReq openssl;

addError CANNOT_GENERATE_SSL_KEY "Cannot generate the SSL key pair";
addError CANNOT_GENERATE_SSL_CERTIFICATE "Cannot generate the SSL certificate";
addError CANNOT_SIGN_SSL_CERTIFICATE "Cannot sign the SSL certificate";
addError CANNOT_UPDATE_SSL_KEY_FOLDER_PERMISSIONS "Cannot update the permissions of ${SSL_KEY_FOLDER}";
addError CANNOT_UPDATE_SSL_KEY_PERMISSIONS "Cannot update the permissions of the generated key file";
addError CANNOT_UPDATE_SSL_KEY_OWNERSHIP "Cannot update the ownership of the generated key file";

defineButDoNotOverrideEnvVar SERVICE_USER "The name of the service user" "${SQ_SERVICE_USER}";
defineButDoNotOverrideEnvVar SERVICE_GROUP "The name of the service group" "${SQ_SERVICE_GROUP}";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
