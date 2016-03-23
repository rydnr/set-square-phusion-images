#!/bin/bash dry-wit
# Copyright 2015-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3

function usage() {
cat <<EOF
$SCRIPT_NAME
$SCRIPT_NAME [-h|--help]
(c) 2015-today Automated Computing Machinery S.L.
    Distributed under the terms of the GNU General Public License v3

Updates the SSL configuration for Nexus.

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
  checkReq java JAVA_NOT_AVAILABLE;
}

## Defines the errors
## dry-wit hook
function defineErrors() {
  export INVALID_OPTION="Unrecognized option";
  export JAVA_NOT_AVAILABLE="java is not installed";
  export CANNOT_UPDATE_KEYSTOREPATH_IN_JETTY_CONFIG="Cannot update KeyStorePath in Jetty configuration";
  export CANNOT_UPDATE_TRUSTSTOREPATH_IN_JETTY_CONFIG="Cannot update TrustStorePath in Jetty configuration";
  export CANNOT_UPDATE_KEYSTOREPASSWORD_IN_JETTY_CONFIG="Cannot update KeyStorePassword in Jetty configuration";
  export CANNOT_UPDATE_TRUSTSTOREPASSWORD_IN_JETTY_CONFIG="Cannot update TrustStorePassword in Jetty configuration";
  export CANNOT_UPDATE_KEYMANAGERPASSWORD_IN_JETTY_CONFIG="Cannot update KeyManagerPassword in Jetty configuration";
  export CANNOT_ENABLE_JETTY_HTTPS="Cannot enable Jetty HTTPS";

  ERROR_MESSAGES=(\
    INVALID_OPTION \
    JAVA_NOT_AVAILABLE \
    CANNOT_UPDATE_KEYSTOREPATH_IN_JETTY_CONFIG \
    CANNOT_UPDATE_TRUSTSTOREPATH_IN_JETTY_CONFIG \
    CANNOT_UPDATE_KEYSTOREPASSWORD_IN_JETTY_CONFIG \
    CANNOT_UPDATE_TRUSTSTOREPASSWORD_IN_JETTY_CONFIG \
    CANNOT_UPDATE_KEYMANAGERPASSWORD_IN_JETTY_CONFIG \
    CANNOT_ENABLE_JETTY_HTTPS \
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

## Obfuscates given password.
## -> 1: The password to obfuscate.
## <- RESULT: The obfuscated password.
function obfuscatePassword() {
  local _pass="${1}";
  local _result="$(java -cp "${PASSWORD_JAR_FILE}" ${PASSWORD_CLASS} "${_pass}" 2>&1 | grep -e '^OBF:')";
  export RESULT="${_result}";
}

## Updates the keystore path in given Jetty config file.
## -> 1: The keystore path.
## -> 2: The Jetty config file.
function updateKeyStorePath() {
  local _keyStorePath="${1}";
  local _configFile="${2}";

  logInfo -n "Updating KeyStorePath in ${_configFile}";
  sed -i "s|<Set name=\"KeyStorePath\">.*</Set>|<Set name=\"KeyStorePath\">${_keyStorePath}</Set>|g" "${_configFile}";
  if [ $? -eq 0 ]; then
    logInfoResult SUCCESS "done";
  else
    logInfoResult FAILURE "failed";
    exitWithErrorCode CANNOT_UPDATE_KEYSTOREPATH_IN_JETTY_CONFIG;
  fi

  logInfo -n "Updating TrustStorePath in ${_configFile}";
  sed -i "s|<Set name=\"TrustStorePath\">.*</Set>|<Set name=\"TrustStorePath\">${_keyStorePath}</Set>|g" "${_configFile}";
  if [ $? -eq 0 ]; then
    logInfoResult SUCCESS "done";
  else
    logInfoResult FAILURE "failed";
    exitWithErrorCode CANNOT_UPDATE_TRUSTSTOREPATH_IN_JETTY_CONFIG;
  fi
}

## Updates the keystore password in given Jetty config file.
## -> 1: The keystore password.
## -> 2: The Jetty config file.
function updateKeyStorePassword() {
  local _keyStorePassword="${1}";
  local _configFile="${2}";

  logInfo -n "Updating KeyStorePassword in ${_configFile}";
  sed -i "s|<Set name=\"KeyStorePassword\">.*</Set>|<Set name=\"KeyStorePassword\">${_keyStorePassword}</Set>|g" "${_configFile}";
  if [ $? -eq 0 ]; then
    logInfoResult SUCCESS "done";
  else
    logInfoResult FAILURE "failed";
    exitWithErrorCode CANNOT_UPDATE_KEYSTOREPASSWORD_IN_JETTY_CONFIG;
  fi

  logInfo -n "Updating TrustStorePassword in ${_configFile}";
  sed -i "s|<Set name=\"TrustStorePassword\">.*</Set>|<Set name=\"TrustStorePassword\">${_keyStorePassword}</Set>|g" "${_configFile}";
  if [ $? -eq 0 ]; then
    logInfoResult SUCCESS "done";
  else
    logInfoResult FAILURE "failed";
    exitWithErrorCode CANNOT_UPDATE_TRUSTSTOREPASSWORD_IN_JETTY_CONFIG;
  fi
}

## Updates the key password in given Jetty config file.
## -> 1: The keystore password.
## -> 2: The Jetty config file.
function updateKeyPassword() {
  local _keyPassword="${1}";
  local _configFile="${2}";

  logInfo -n "Updating KeyManagerPassword in ${_configFile}";
  sed -i "s|<Set name=\"KeyManagerPassword\">.*</Set>|<Set name=\"KeyManagerPassword\">${_keyPassword}</Set>|g" "${_configFile}";
  if [ $? -eq 0 ]; then
    logInfoResult SUCCESS "done";
  else
    logInfoResult FAILURE "failed";
    exitWithErrorCode CANNOT_UPDATE_KEYMANAGERPASSWORD_IN_JETTY_CONFIG;
  fi
}

function appendHttpsConnectorPort() {
  local _file="${1}";
  local _port="${2}";

  logInfo -n "Updating SSL port ${_port} in ${_file}";
  echo "application-port-ssl=${_port}" >> "${_file}";
  logInfoResult SUCCESS "done";
}

function enableJettyHttpsConfig() {
  local _file="${1}";

  logInfo -n "Enabling Jetty-https in ${_file}";
  sed -i "s|nexus-args=\(.*\)|nexus-args=\1,\${karaf.base}/etc/jetty-https.xml|g" "${_file}";
  if [ $? -eq 0 ]; then
    logInfoResult SUCCESS "done";
  else
    logInfoResult FAILURE "failed";
    exitWithErrorCode CANNOT_ENABLE_JETTY_HTTPS;
  fi
}

## Main logic
## dry-wit hook
function main() {
  local _keyStorePassword;
  local _keyPassword;
  source /etc/my_init.d/40_create_ssl_certificate.inc.sh
  obfuscatePassword "${SSL_KEYSTORE_PASSWORD}";
  _keyStorePassword="${RESULT}";
  obfuscatePassword "${SSL_KEY_PASSWORD}";
  _keyPassword="${RESULT}";
  updateKeyStorePath "${SSL_KEYSTORE_PATH}" "${JETTY_HTTPS_CONFIG_FILE}";
  updateKeyStorePassword "${_keyStorePassword}" "${JETTY_HTTPS_CONFIG_FILE}";
  updateKeyPassword "${_keyPassword}" "${JETTY_HTTPS_CONFIG_FILE}";
  appendHttpsConnectorPort "${NEXUS_CONFIG_FILE}" "${DOCKER_REGISTRY_PORT}";
  enableJettyHttpsConfig "${NEXUS_PROPERTIES_FILE}";
}

