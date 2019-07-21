defineEnvVar PARENT_IMAGE_TAG MANDATORY MANDATORY "The tag of the parent image" "0.11";
defineEnvVar GRADLE_VERSION MANDATORY MANDATORY "The Gradle version" '4.4';
defineEnvVar PHARO_VERSION MANDATORY MANDATORY "The Pharo version" "7.0";
defineEnvVar TAG MANDATORY MANDATORY "The tag" '${GRADLE_VERSION}-${PHARO_VERSION}-root';
overrideEnvVar ENABLE_LOGSTASH 'false';
defineEnvVar SERVICE_USER MANDATORY MANDATORY "The service user" "pharo";
defineEnvVar SERVICE_USER_PASSWORD MANDATORY MANDATORY "The service user password" '${RANDOM_PASSWORD}';
defineEnvVar SERVICE_GROUP MANDATORY MANDATORY "The service group" "pharo";
defineEnvVar SERVICE_USER_HOME MANDATORY MANDATORY "The home of the service user" "/home/pharo";
defineEnvVar SERVICE_USER_SHELL MANDATORY MANDATORY "The shell of the service user" "/bin/bash";
defineEnvVar WORKSPACE MANDATORY MANDATORY "The workspace folder" '${SERVICE_USER_HOME}/work';
defineEnvVar GIT_USER_NAME MANDATORY MANDATORY "The user.name for git" '${SERVICE_USER}';
defineEnvVar GIT_USER_EMAIL MANDATORY MANDATORY "The user.email for git" '${SERVICE_USER}@${DOMAIN}';
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
