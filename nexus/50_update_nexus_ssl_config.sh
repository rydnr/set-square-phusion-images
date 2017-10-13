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
  addError "INVALID_OPTION" "Unrecognized option";
  addError "JAVA_NOT_AVAILABLE" "java is not installed";
  addError "CANNOT_UPDATE_KEYSTOREPATH_IN_JETTY_CONFIG" "Cannot update KeyStorePath in Jetty configuration";
  addError "CANNOT_UPDATE_TRUSTSTOREPATH_IN_JETTY_CONFIG" "Cannot update TrustStorePath in Jetty configuration";
  addError "CANNOT_UPDATE_KEYSTOREPASSWORD_IN_JETTY_CONFIG" "Cannot update KeyStorePassword in Jetty configuration";
  addError "CANNOT_UPDATE_TRUSTSTOREPASSWORD_IN_JETTY_CONFIG" "Cannot update TrustStorePassword in Jetty configuration";
  addError "CANNOT_UPDATE_KEYMANAGERPASSWORD_IN_JETTY_CONFIG" "Cannot update KeyManagerPassword in Jetty configuration";
  addError "CANNOT_ENABLE_JETTY_HTTPS" "Cannot enable Jetty HTTPS";
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

## Obfuscates given password.
## -> 1: The password to obfuscate.
## <- 0/${TRUE} if the password could be obfuscated successfully; 1/${FALSE} otherwise.
## <- RESULT: The obfuscated password.
## Example:
##   if obfuscatePassword "secret"; then
##     echo "secret -> ${RESULT}";
##   fi
function obfuscatePassword() {
  local _pass="${1}";
  local -i _rescode;

  checkNotEmpty "password" "${_pass}" 1;

  local _result="$(java -cp ${PASSWORD_JAR_FILE} ${PASSWORD_CLASS} "${_pass}" 2>&1 | grep -e '^OBF:')";
  _rescode=$?;

  if isTrue ${_rescode}; then
      export RESULT="${_result}";
  else
    export RESULT="";
  fi

  return ${_rescode};
}

## Updates the keystore path in given Jetty config file.
## -> 1: The keystore path.
## -> 2: The Jetty config file.
## Example:
##   updateKeyStorePath "/etc/ssl/keystore.jks" "/etc/jetty/jetty-https.xml";
function updateKeyStorePath() {
  local _keyStorePath="${1}";
  local _configFile="${2}";

  checkNotEmpty "keyStorePath" "${_keyStorePath}" 1;
  checkNotEmpty "configFile" "${_configFile}" 2;

  logInfo -n "Updating KeyStorePath in ${_configFile}";
  sed -i "s|<Set name=\"KeyStorePath\">.*</Set>|<Set name=\"KeyStorePath\">${_keyStorePath}</Set>|g" "${_configFile}";
  if isTrue $?; then
    logInfoResult SUCCESS "done";
  else
    logInfoResult FAILURE "failed";
    exitWithErrorCode CANNOT_UPDATE_KEYSTOREPATH_IN_JETTY_CONFIG;
  fi

  logInfo -n "Updating TrustStorePath in ${_configFile}";
  sed -i "s|<Set name=\"TrustStorePath\">.*</Set>|<Set name=\"TrustStorePath\">${_keyStorePath}</Set>|g" "${_configFile}";
  if isTrue $?; then
    logInfoResult SUCCESS "done";
  else
    logInfoResult FAILURE "failed";
    exitWithErrorCode CANNOT_UPDATE_TRUSTSTOREPATH_IN_JETTY_CONFIG;
  fi
}

## Updates the keystore password in given Jetty config file.
## -> 1: The keystore password.
## -> 2: The Jetty config file.
## Example:
##   updateKeyStorePassword "secret" "/etc/jetty/jetty-https.xml";
function updateKeyStorePassword() {
  local _keyStorePassword="${1}";
  local _configFile="${2}";

  checkNotEmpty "keyStorePassword" "${_keyStorePassword}" 1;
  checkNotEmpty "configFile" "${_configFile}" 2;

  logInfo -n "Updating KeyStorePassword in ${_configFile}";
  sed -i "s|<Set name=\"KeyStorePassword\">.*</Set>|<Set name=\"KeyStorePassword\">${_keyStorePassword}</Set>|g" "${_configFile}";
  if isTrue $?; then
    logInfoResult SUCCESS "done";
  else
    logInfoResult FAILURE "failed";
    exitWithErrorCode CANNOT_UPDATE_KEYSTOREPASSWORD_IN_JETTY_CONFIG;
  fi

  logInfo -n "Updating TrustStorePassword in ${_configFile}";
  sed -i "s|<Set name=\"TrustStorePassword\">.*</Set>|<Set name=\"TrustStorePassword\">${_keyStorePassword}</Set>|g" "${_configFile}";
  if isTrue $?; then
    logInfoResult SUCCESS "done";
  else
    logInfoResult FAILURE "failed";
    exitWithErrorCode CANNOT_UPDATE_TRUSTSTOREPASSWORD_IN_JETTY_CONFIG;
  fi
}

## Updates the key password in given Jetty config file.
## -> 1: The keystore password.
## -> 2: The Jetty config file.
## Example:
##   updateKeyPassword "secret" "/opt/sonatype/nexus/etc/jetty-https.xml"
function updateKeyPassword() {
  local _keyPassword="${1}";
  local _configFile="${2}";

  checkNotEmpty "keyPassword" "${_keyPassword}" 1;
  checkNotEmpty "configFile" "${_configFile}" 2;

  logInfo -n "Updating KeyManagerPassword in ${_configFile}";
  sed -i "s|<Set name=\"KeyManagerPassword\">.*</Set>|<Set name=\"KeyManagerPassword\">${_keyPassword}</Set>|g" "${_configFile}";
  if isTrue $?; then
    logInfoResult SUCCESS "done";
  else
    logInfoResult FAILURE "failed";
    exitWithErrorCode CANNOT_UPDATE_KEYMANAGERPASSWORD_IN_JETTY_CONFIG;
  fi
}

## Appends the HTTPS connector port to given file.
## -> 1: The file to update.
## -> 2: The HTTPS port.
## Example:
##   appendHttpsConnectorPort "/opt/sonatype/nexus/etc/org.sonatype.nexus.cfg" 8443
function appendHttpsConnectorPort() {
  local _file="${1}";
  local _port="${2}";

  checkNotEmpty "file" "${_file}" 1;
  checkNotEmpty "port" "${_port}" 2;

  logInfo -n "Updating SSL port ${_port} in ${_file}";
  echo "application-port-ssl=${_port}" >> "${_file}";
  logInfoResult SUCCESS "done";
}

## Appends the log-config-dir setting to given file.
## -> 1: The file to update.
## -> 2: The log folder.
## Example:
##   appendLogConfigDir "/opt/sonatype/nexus/etc/system.properties" "/backup/nexus-conf/"
function appendLogConfigDir() {
  local _file="${1}";
  local _dir="${2}";

  checkNotEmpty "file" "${_file}" 1;
  checkNotEmpty "dir" "${_dir}" 2;

  logInfo -n "Appending nexus.log-config-dir=${_dir} to ${_file}";
  echo "nexus.log-config-dir=${_dir}" >> "${_file}";
  logInfoResult SUCCESS "done";
}

## Appends the work-dir setting to given file.
## -> 1: The file to update.
## -> 2: The work folder.
## Example:
##   appendWorkDir "/opt/sonatype/nexus/etc/system.properties" "/sonatype-work"
function appendWorkDir() {
  local _file="${1}";
  local _dir="${2}";

  checkNotEmpty "file" "${_file}" 1;
  checkNotEmpty "dir" "${_dir}" 2;

  logInfo -n "Appending nexus.work-dir=${_dir} to ${_file}";
  echo "nexus.work-dir=${_dir}" >> "${_file}";
  logInfoResult SUCCESS "done";
}

## Enables the Jetty HTTPS configuration.
## -> 1: The nexus-default.properties file location.
## -> 2: The nexus.properties file location.
## Example:
##   enableJettyHttpsConfig "/opt/sonatype/nexus/etc/nexus-default.properties" "/opt-sonatype/nexus/etc/nexus.properties"
function enableJettyHttpsConfig() {
  local _file="${1}";
  local _output="${2}";

  checkNotEmpty "file" "${_file}" 1;
  checkNotEmpty "output" "${_output}" 2;

  logInfo -n "Enabling Jetty-https in ${_file}";
  grep 'nexus-args' "${_file}" | sed "s|nexus-args=\(.*\)|nexus-args=\1,\${jetty.etc}/jetty-https.xml|g" >> "${_output}";
  if isTrue $?; then
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

  [ -e "${ADDITIONAL_SETTINGS_PATH}" ] && source "${ADDITIONAL_SETTINGS_PATH}";
  obfuscatePassword "${SSL_KEYSTORE_PASSWORD}";
  _keyStorePassword="${RESULT}";
  obfuscatePassword "${SSL_KEY_PASSWORD}";
  _keyPassword="${RESULT}";
  updateKeyStorePath "${SSL_KEYSTORE_PATH}" "${JETTY_HTTPS_CONFIG_FILE}";
  updateKeyStorePassword "${_keyStorePassword}" "${JETTY_HTTPS_CONFIG_FILE}";
  updateKeyPassword "${_keyPassword}" "${JETTY_HTTPS_CONFIG_FILE}";
  appendLogConfigDir "${NEXUS_SYSTEM_PROPERTIES_FILE}" "${NEXUS_LOG_CONFIG_DIR}";
  appendWorkDir "${NEXUS_SYSTEM_PROPERTIES_FILE}" "${NEXUS_WORK_DIR}";
  enableJettyHttpsConfig "${NEXUS_DEFAULT_CONFIG_FILE}" "${NEXUS_CONFIG_FILE}";
  appendHttpsConnectorPort "${NEXUS_CONFIG_FILE}" "${NEXUS_DOCKER_GROUP_PORT}";
}

