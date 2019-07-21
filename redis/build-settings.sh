defineEnvVar PARENT_IMAGE_TAG MANDATORY "The tag of the parent image" "0.11";
defineEnvVar REDIS_VERSION MANDATORY "The version of Redis" "4.0.9-1";
defineEnvVar UBUNTU_REDIS_VERSION MANDATORY "The version of Redis" '5:${REDIS_VERSION}';
overrideEnvVar TAG '${REDIS_VERSION}';
defineEnvVar SERVICE_USER MANDATORY "The service user" 'redis';
defineEnvVar SERVICE_GROUP MANDATORY "The service group" 'redis';
defineEnvVar SERVICE_USER_SHELL MANDATORY "The service user shell" '/bin/bash';
defineEnvVar SERVICE_USER_HOME MANDATORY "The home of the service user" '/var/lib/redis';
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
