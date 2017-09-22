defineEnvVar PARENT_IMAGE_TAG "The tag of the parent image" "0.9.21";
defineEnvVar GRADLE_VERSION "The Gradle version" '4.2';
defineEnvVar PHARO_VERSION "The Pharo version" "6.0";
defineEnvVar TAG "The tag" '${GRADLE_VERSION}-${PHARO_VERSION}';
defineEnvVar PHARO_VERSION_ZEROCONF "The Pharo version, as expected by the Zeroconf script in get.pharo.org" '$(echo ${PHARO_VERSION} | tr -d '.')';
overrideEnvVar ENABLE_LOGSTASH 'false';
defineEnvVar SERVICE_USER "The service user" "pharo";
defineEnvVar SERVICE_USER_PASSWORD "The service user password" '${RANDOM_PASSWORD}';
defineEnvVar SERVICE_GROUP "The service group" "pharo";
defineEnvVar SERVICE_USER_HOME "The home of the service user" "/home/pharo";
defineEnvVar SERVICE_USER_SHELL "The shell of the service user" "/bin/bash";
defineEnvVar WORKSPACE "The workspace folder" '${SERVICE_USER_HOME}/work';
defineEnvVar GIT_USER_NAME "The user.name for git" '${SERVICE_USER}';
defineEnvVar GIT_USER_EMAIL "The user.email for git" '${SERVICE_USER}@${DOMAIN}';
