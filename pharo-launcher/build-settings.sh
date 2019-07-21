defineEnvVar PARENT_IMAGE_TAG MANDATORY "The tag of the parent image" "0.11";
defineEnvVar TAG MANDATORY "The tag" 'latest';
overrideEnvVar ENABLE_LOGSTASH 'false';
defineEnvVar SERVICE_USER MANDATORY "The service user" "pharo";
defineEnvVar SERVICE_USER_PASSWORD MANDATORY "The service user password" '${RANDOM_PASSWORD}';
defineEnvVar SERVICE_GROUP MANDATORY "The service group" "pharo";
defineEnvVar SERVICE_USER_HOME MANDATORY "The home of the service user" "/home/pharo";
defineEnvVar SERVICE_USER_SHELL MANDATORY "The shell of the service user" "/bin/bash";
defineEnvVar WORKSPACE MANDATORY "The workspace folder" '${SERVICE_USER_HOME}/work';
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
