defineEnvVar PARENT_IMAGE_TAG "The tag of the parent image" "201702";
defineEnvVar PHARO_VERSION "The Pharo version" "5.0";
overrideEnvVar TAG '${PHARO_VERSION}';
defineEnvVar SERVICE_USER "The service user" "pharo";
defineEnvVar SERVICE_GROUP "The service group" "pharo";
defineEnvVar SERVICE_USER_HOME "The home of the pharo user" "/home/pharo";
defineEnvVar SERVICE_USER_SHELL "The shell of the pharo user" "/bin/bash";

