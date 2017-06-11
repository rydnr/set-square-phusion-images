defineEnvVar PARENT_IMAGE_TAG "The tag of the parent image" "201702";
defineEnvVar MONGODB_MAJOR_VERSION "The MongoDB version" "3.4";
defineEnvVar MONGODB_VERSION "The MongoDB version" "3.4.4";
overrideEnvVar TAG '${MONGODB_VERSION}';
defineEnvVar SERVICE_USER "The service user" "mongodb";
defineEnvVar SERVICE_GROUP "The service group" "mongodb";
defineEnvVar SERVICE_USER_HOME "The home of the service user" '/backup/${IMAGE}';
defineEnvVar SERVICE_USER_SHELL "The shell of the service user" "/bin/bash";
