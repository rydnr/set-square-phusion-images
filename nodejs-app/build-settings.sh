defineEnvVar PARENT_IMAGE_TAG "The base tag" "201702";
defineEnvVar NODEJS_MAJOR_VERSION "The major version of NodeJS" "6";
overrideEnvVar TAG '${NODEJS_MAJOR_VERSION}';
defineEnvVar SERVICE_USER "The name of the user" '${NAMESPACE}';
defineEnvVar SERVICE_GROUP "The name of the group" "users";
defineEnvVar SERVICE_USER_HOME "The home of the nodejs user" '/home/${NAMESPACE}';
defineEnvVar SERVICE_USER_SHELL "The shell of the nodejs user" "/bin/bash";
overrideEnvVar ENABLE_RSNAPSHOT "false";
overrideEnvVar ENABLE_LOGSTASH "false";
