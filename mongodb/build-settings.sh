defineEnvVar PARENT_IMAGE_TAG "The tag of the parent image" "201611";
defineEnvVar MONGODB_VERSION "The MongoDB version" "3.2";
overrideEnvVar TAG '${MONGODB_VERSION}';
defineEnvVar SERVICE_USER "The service user" "mongo";
defineEnvVar SERVICE_GROUP "The service group" "mongo";
defineEnvVar SERVICE_USER_HOME "The home of the service user" '/backup/${IMAGE}';
defineEnvVar SERVICE_USER_SHELL "The shell of the service user" "/bin/bash";
