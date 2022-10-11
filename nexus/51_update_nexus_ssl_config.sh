#!/usr/bin/env dry-wit
# Copyright 2015-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3
# mod: nexus/50_update_nexus_ssl_config
# api: public
# txt: Updates the SSL configuration for Nexus.

DW.import jetty;
DW.import nexus;

# fun: main
# api: public
# txt: Updates the SSL configuration for Nexus.
# txt: Returns 0/TRUE always, unless an error is thrown.
# use: main
function main() {
  local _keyStorePassword;
  local _keyPassword;

  if jettyConfAlreadyUpdated "${JETTY_HTTPS_CONFIG_FILE}"; then
    logInfo "${JETTY_HTTPS_CONFIG_FILE} already updated"
  else
    if fileExists "${ADDITIONAL_SETTINGS_PATH}"; then
      source "${ADDITIONAL_SETTINGS_PATH}";
    fi

    logInfo -n "Obfuscating ${SSL_KEYSTORE_PASSWORD}";
    if obfuscatePassword "${SSL_KEYSTORE_PASSWORD}"; then
      _keyStorePassword="${RESULT}";
      logInfoResult SUCCESS "done";
    else
      logInfoResult FAILURE "failed";
      exitWithErrorCode CANNOT_OBFUSCATE_SSL_KEYSTORE_PASSWORD;
    fi

    logInfo -n "Obfuscating ${SSL_KEY_PASSWORD}";
    if obfuscatePassword "${SSL_KEY_PASSWORD}"; then
      _keyPassword="${RESULT}";
      logInfoResult SUCCESS "done";
    else
      logInfoResult FAILURE "failed";
      exitWithErrorCode CANNOT_OBFUSCATE_SSL_KEY_PASSWORD;
    fi

    logInfo -n "Updating KeyStorePath in ${JETTY_HTTPS_CONFIG_FILE}";
    if updateKeyStorePathInJettyConf "${SSL_KEYSTORE_PATH}" "${JETTY_HTTPS_CONFIG_FILE}"; then
      logInfoResult SUCCESS "done";
    else
      logInfoResult FAILURE "failed";
      exitWithErrorCode CANNOT_UPDATE_KEYSTOREPATH_IN_JETTY_CONFIG;
    fi

    logInfo -n "Updating TrustStorePath in ${JETTY_HTTPS_CONFIG_FILE}";
    if updateTrustStorePathInJettyConf "${SSL_KEYSTORE_PATH}" "${JETTY_HTTPS_CONFIG_FILE}"; then
      logInfoResult SUCCESS "done";
    else
      logInfoResult FAILURE "failed";
      exitWithErrorCode CANNOT_UPDATE_TRUSTSTOREPATH_IN_JETTY_CONFIG;
    fi

    logInfo -n "Updating KeyStorePassword in ${JETTY_HTTPS_CONFIG_FILE}";
    if updateKeyStorePasswordInJettyConf "${_keyStorePassword}" "${JETTY_HTTPS_CONFIG_FILE}"; then
      logInfoResult SUCCESS "done";
    else
      logInfoResult FAILURE "failed";
      exitWithErrorCode CANNOT_UPDATE_KEYSTOREPASSWORD_IN_JETTY_CONFIG;
    fi

    logInfo -n "Updating TrustStorePassword in ${JETTY_HTTPS_CONFIG_FILE}";
    if updateTrustStorePasswordInJettyConf "${_keyStorePassword}" "${JETTY_HTTPS_CONFIG_FILE}"; then
      logInfoResult SUCCESS "done";
    else
      logInfoResult FAILURE "failed";
      exitWithErrorCode CANNOT_UPDATE_TRUSTSTOREPASSWORD_IN_JETTY_CONFIG;
    fi

    logInfo -n "Updating KeyManagerPassword in ${JETTY_HTTPS_CONFIG_FILE}";
    if updateKeyManagerPasswordInJettyConf "${_keyPassword}" "${JETTY_HTTPS_CONFIG_FILE}"; then
      logInfoResult SUCCESS "done";
    else
      logInfoResult FAILURE "failed";
      exitWithErrorCode CANNOT_UPDATE_KEYMANAGERPASSWORD_IN_JETTY_CONFIG;
    fi

    logInfo -n "Adding update mark to ${JETTY_HTTPS_CONFIG_FILE}";
    if appendUpdateMarkInJettyConf "${JETTY_HTTPS_CONFIG_FILE}" "${_scriptName}"; then
      logInfoResult SUCCESS "done";
    else
      logInfoResult FAILURE "failed";
      exitWithErrorCode CANNOT_APPEND_UPDATE_MARK_IN_JETTY_CONFIG;
    fi
  fi

  if nexusSystemPropertiesAlreadyUpdated "${NEXUS_SYSTEM_PROPERTIES_FILE}"; then
    logInfo "${NEXUS_SYSTEM_PROPERTIES_FILE} already updated"
  else
    logInfo -n "Appending nexus.log-config-dir=${NEXUS_LOG_CONFIG_DIR} to ${NEXUS_SYSTEM_PROPERTIES_FILE}";
    if appendLogConfigDirToNexusSystemProperties "${NEXUS_SYSTEM_PROPERTIES_FILE}" "${NEXUS_LOG_CONFIG_DIR}"; then
      logInfoResult SUCCESS "done";
    else
      logInfoResult FAILURE "failed";
      exitWithErrorCode CANNOT_CONFIGURE_LOG_IN_NEXUS_SYSTEM_PROPERTIES;
    fi

    logInfo -n "Appending nexus.work-dir=${NEXUS_WORK_DIR} to ${NEXUS_SYSTEM_PROPERTIES_FILE}";
    if appendWorkDirInNexusSystemProperties "${NEXUS_SYSTEM_PROPERTIES_FILE}" "${NEXUS_WORK_DIR}"; then
      logInfoResult SUCCESS "done";
    else
      logInfoResult FAILURE "failed";
      exitWithErrorCode CANNOT_CONFIGURE_WORK_DIR_IN_SYSTEM_PROPERTIES;
    fi

    logInfo -n "Adding update mark to ${NEXUS_SYSTEM_PROPERTIES_FILE}";
    if appendUpdateMarkInJettyConf "${NEXUS_SYSTEM_PROPERTIES_FILE}" "${_scriptName}"; then
      logInfoResult SUCCESS "done";
    else
      logInfoResult FAILURE "failed";
      exitWithErrorCode CANNOT_APPEND_UPDATE_MARK_IN_NEXUS_SYSTEM_PROPERTIES;
    fi
  fi

  if nexusCfgAlreadyUpdated "${NEXUS_CONFIG_FILE}"; then
    logInfo "${NEXUS_CONFIG_FILE} already updated"
  else
    logInfo -n "Enabling Jetty-https in ${NEXUS_CONFIG_FILE} overriding ${NEXUS_DEFAULT_CONFIG_FILE}";
    if enableJettyHttpsConfigInNexusCfg "${NEXUS_DEFAULT_CONFIG_FILE}" "${NEXUS_CONFIG_FILE}"; then
      logInfoResult SUCCESS "done";
    else
      logInfoResult FAILURE "failed";
      exitWithErrorCode CANNOT_ENABLE_JETTY_HTTPS;
    fi

    logInfo -n "Updating SSL port ${NEXUS_DOCKER_REGISTRY_PORT} in ${NEXUS_CONFIG_FILE}";
    if appendHttpsConnectorPortToNexusCfg "${NEXUS_CONFIG_FILE}" "${NEXUS_DOCKER_REGISTRY_PORT}"; then
      logInfoResult SUCCESS "done";
    else
      logInfoResult FAILURE "failed";
      exitWithErrorCode CANNOT_ENABLE_SSL_IN_NEXUS_CFG;
    fi

    logInfo -n "Adding update mark to ${NEXUS_CONFIG_FILE}";
    if appendUpdateMarkInNexusCfg "${NEXUS_CONFIG_FILE}" "${_scriptName}"; then
      logInfoResult SUCCESS "done";
    else
      logInfoResult FAILURE "failed";
      exitWithErrorCode CANNOT_APPEND_UPDATE_MARK_IN_NEXUS_CFG;
    fi
  fi
}

# fun: obfuscatePassword
# api: public
# txt: Obfuscates given password.
# opt: password: The password to obfuscate.
# txt: Returns 0/TRUE if the password could be obfuscated successfully; 1/FALSE otherwise.
# txt: If the password could be obfuscated, the variable RESULT contains the obfuscated password.
# use: if obfuscatePassword "secret"; then echo "secret -> ${RESULT}"; fi
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

## Script metadata and CLI options
setScriptDescription "Updates the SSL configuration for Nexus.";

checkReq java;

addError CANNOT_OBFUSCATE_SSL_KEYSTORE_PASSWORD "Cannot update the SSL key store password";
addError CANNOT_OBFUSCATE_SSL_KEY_PASSWORD "Cannot update the SSL key password";
addError CANNOT_UPDATE_KEYSTOREPATH_IN_JETTY_CONFIG "Cannot update KeyStorePath in Jetty configuration";
addError CANNOT_UPDATE_TRUSTSTOREPATH_IN_JETTY_CONFIG "Cannot update TrustStorePath in Jetty configuration";
addError CANNOT_UPDATE_KEYSTOREPASSWORD_IN_JETTY_CONFIG "Cannot update KeyStorePassword in Jetty configuration";
addError CANNOT_UPDATE_TRUSTSTOREPASSWORD_IN_JETTY_CONFIG "Cannot update TrustStorePassword in Jetty configuration";
addError CANNOT_UPDATE_KEYMANAGERPASSWORD_IN_JETTY_CONFIG "Cannot update KeyManagerPassword in Jetty configuration";
addError CANNOT_ENABLE_JETTY_HTTPS "Cannot enable Jetty HTTPS";
addError CANNOT_CONFIGURE_LOG_IN_SYSTEM_PROPERTIES "Cannot configure logging in ${NEXUS_SYSTEM_PROPERTIES_FILE}";
addError CANNOT_CONFIGURE_WORK_DIR_IN_SYSTEM_PROPERTIES "Cannot configure the working directory in ${NEXUS_SYSTEM_PROPERTIES_FILE}";
addError CANNOT_ENABLE_SSL_IN_NEXUS_CFG "Cannot enable SSL in ${NEXUS_CONFIG_FILE}";
addError CANNOT_APPEND_UPDATE_MARK_IN_JETTY_CONFIG "Cannot append update mark in ${JETTY_HTTPS_CONFIG_FILE}";
addError CANNOT_APPEND_UPDATE_MARK_IN_NEXUS_SYSTEM_PROPERTIES "Cannot append update mark in ${NEXUS_SYSTEM_PROPERTIES_FILE}";
addError CANNOT_APPEND_UPDATE_MARK_IN_NEXUS_CFG "Cannot append update mark in ${NEXUS_CONFIG_FILE}";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
