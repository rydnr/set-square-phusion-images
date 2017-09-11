defineEnvVar PARENT_IMAGE_TAG "The tag of the parent image" "0.9.22";
defineEnvVar MONGODB_MAJOR_VERSION "The MongoDB version" "3.4";
defineEnvVar MONGODB_VERSION "The MongoDB version" '${MONGODB_MAJOR_VERSION}.8';
overrideEnvVar TAG '${MONGODB_VERSION}';
defineEnvVar SERVICE_USER "The service user" "mongodb";
defineEnvVar SERVICE_USER_PASSWORD "The password of the service user" "${RANDOM_PASSWORD}";
defineEnvVar SERVICE_GROUP "The service group" "mongodb";
defineEnvVar SERVICE_USER_HOME "The home of the service user" '/backup/${IMAGE}';
defineEnvVar SERVICE_USER_SHELL "The shell of the service user" "/bin/bash";
