defineEnvVar PARENT_IMAGE_TAG MANDATORY "The tag of the parent image" "18.04-1.0.0-amd64";
#defineEnvVar ROBO3T_VERSION MANDATORY "The Robo3T version" '1.2.1';
#defineEnvVar ROBO3T_HASH MANDATORY "The Robo3T hash" '3e50a65';
defineEnvVar TAG MANDATORY "The image tag" '1.4';
defineEnvVar SERVICE_USER MANDATORY "The service user" 'robo3t';
defineEnvVar SERVICE_GROUP MANDATORY "The service group" 'robo3t';
defineEnvVar SERVICE_USER_SHELL MANDATORY "The shell of the service user" '/bin/bash';
defineEnvVar SERVICE_USER_HOME MANDATORY "The home of the service user" '/home/robo3t';
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
