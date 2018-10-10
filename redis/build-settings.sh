defineEnvVar PARENT_IMAGE_TAG "The tag of the parent image" "0.11";
defineEnvVar REDIS_VERSION "The version of Redis" "4.0.9-1";
defineEnvVar UBUNTU_REDIS_VERSION "The version of Redis" '5:${REDIS_VERSION}';
overrideEnvVar TAG '${REDIS_VERSION}';
defineEnvVar SERVICE_USER "The service user" 'redis';
defineEnvVar SERVICE_GROUP "The service group" 'redis';
defineEnvVar SERVICE_USER_SHELL "The service user shell" '/bin/bash';
defineEnvVar SERVICE_USER_HOME "The home of the service user" '/var/lib/redis';
