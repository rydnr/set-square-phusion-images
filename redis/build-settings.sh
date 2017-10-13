defineEnvVar PARENT_IMAGE_TAG "The tag of the parent image" "0.9.22";
defineEnvVar REDIS_VERSION "The version of Redis" "3.0.6-1";
overrideEnvVar TAG '${REDIS_VERSION}';
defineEnvVar SERVICE_USER "The service user" 'redis';
defineEnvVar SERVICE_GROUP "The service group" 'redis';
defineEnvVar SERVICE_USER_SHELL "The service user shell" '/bin/bash';
defineEnvVar SERVICE_USER_HOME "The home of the service user" '/var/lib/redis';
