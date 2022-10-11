#!/usr/bin/env dry-wit
# Copyright 2015-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3
# mod: create_ssl_certificate_keytool
# api: public
# txt: Creates a SSL certificate. See http://www.eclipse.org/jetty/documentation/current/configuring-ssl.html

DW.import keytool

# fun: main
# api: public
# txt: Creates a SSL certificate using Java's keytool.
# txt: Always returns 0/TRUE, unless it exits with an error.
# use: main
function main() {
  generateAndSignCertificateUsingKeytool
  updateFolderPermissions "${SSL_KEYSTORE_FOLDER}" "${SERVICE_USER}" "${SERVICE_GROUP}"
}

# fun: generateAndSignCertificateUsingKeytool
# api: public
# txt: Generates and signs a new certificate.
function generateAndSignCertificateUsingKeytool() {

  logInfo -n "Generating and signing a certificate using keytool"
  generateAndSignCertificate \
    "${SSL_KEYSTORE_PATH}" \
    "${SSL_CERTIFICATE_ALIAS}" \
    "${SSL_CERTIFICATE_DNAME}" \
    "${SSL_KEY_ALGORITHM}" \
    "${SSL_KEY_PASSWORD}" \
    "${SSL_KEYSTORE_PASSWORD}" \
    "${SSL_KEYSTORE_TYPE}" \
    ${SSL_KEY_LENGTH} \
    ${SSL_CERTIFICATE_EXPIRATION_DAYS} \
    "${SSL_JAVA_SIGN_ALGORITHM}" \
    "${SSL_SAN_EXTENSIONS}"

  if isTrue $?; then
    logInfoResult SUCCESS "done"
  else
    logInfoResult FAILURE "failed"
    logDebug "${ERROR}"
    exitWithErrorCode CANNOT_SIGN_SSL_CERTIFICATE
  fi
}

# fun: updateFolderPermissions
# api: private
# txt: Changes the permissions of given folder.
# opt: dir: The folder to update.
# opt: user: The user.
# opt: group: The group.
function updateFolderPermissions() {
  local _dir="${1}"
  checkNotEmpty dir "${_dir}" 1
  local _user="${2}"
  checkNotEmpty user "${_user}" 2
  local _group="${3}"
  checkNotEmpty group "${_group}" 3

  logInfo -n "Fixing permissions of ${_dir}"

  chown -R ${_user}:${_group} ${_dir}

  if isTrue $?; then
    logInfoResult SUCCESS "done"
  else
    logInfoResult FAILURE "failed"
    exitWithErrorCode CANNOT_UPDATE_KEYSTORE_FOLDER_PERMISSIONS
  fi

}

addError CANNOT_SIGN_SSL_CERTIFICATE "Cannot sign the SSL certificate"
addError CANNOT_UPDATE_KEYSTORE_FOLDER_PERMISSIONS "Cannot update the permissions of ${SSL_KEYSTORE_FOLDER}"

## Script metadata and CLI options
setScriptDescription "Creates a SSL certificate with OpenSSL.
See http://www.eclipse.org/jetty/documentation/current/configuring-ssl.html"
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
