defineEnvVar PARENT_IMAGE_TAG MANDATORY "The tag of the parent image" "latest";
defineEnvVar BLOOMRPC_VERSION MANDATORY "The BloomRPC version" '1.4.1';
defineEnvVar TAG MANDATORY "The image tag" '${BLOOMRPC_VERSION}';
defineEnvVar SERVICE_USER MANDATORY "The service user" 'bloomrpc';
defineEnvVar SERVICE_GROUP MANDATORY "The service group" 'bloomrpc';
defineEnvVar SERVICE_USER_SHELL MANDATORY "The shell of the service user" '/bin/bash';
defineEnvVar SERVICE_USER_HOME MANDATORY "The home of the service user" '/home/bloomrpc';
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
