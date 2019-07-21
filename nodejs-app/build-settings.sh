defineEnvVar PARENT_IMAGE_TAG MANDATORY "The base tag" "0.11";
defineEnvVar NODEJS_MAJOR_VERSION MANDATORY "The major version of NodeJS" "8";
overrideEnvVar TAG '${NODEJS_MAJOR_VERSION}';
defineEnvVar SERVICE_USER MANDATORY "The name of the user" '${NAMESPACE}';
defineEnvVar SERVICE_GROUP MANDATORY "The name of the group" "users";
defineEnvVar SERVICE_USER_HOME MANDATORY "The home of the nodejs user" '/home/${NAMESPACE}';
defineEnvVar SERVICE_USER_SHELL MANDATORY "The shell of the nodejs user" "/bin/bash";
overrideEnvVar ENABLE_RSNAPSHOT "false";
overrideEnvVar ENABLE_LOGSTASH "false";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
