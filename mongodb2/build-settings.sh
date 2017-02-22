defineEnvVar PARENT_IMAGE_TAG "The tag of the parent image" "201702";
defineEnvVar MONGODB_VERSION "The version of MongoDB" "2.6.12";
defineEnvVar TAG '${MONGODB_VERSION}';
defineEnvVar SERVICE_USER "The service user" "mongodb";
defineEnvVar SERVICE_GROUP "The service group" "mongodb";
defineEnvVar SERVICE_USER_SHELL "The shell" "/bin/bash";
defineEnvVar SERVICE_USER_HOME "The home of the service user" "/var/lib/mongodb";
