defineEnvVar PARENT_IMAGE_TAG MANDATORY "The tag of the parent image" "0.11";
defineEnvVar PENCIL_VERSION MANDATORY "The Pencil version" '3.0.3';
defineEnvVar TAG MANDATORY "The image tag" '${PENCIL_VERSION}';
defineEnvVar SERVICE_USER MANDATORY "The service user" 'pencil';
defineEnvVar SERVICE_GROUP MANDATORY "The service group" 'pencil';
defineEnvVar SERVICE_USER_SHELL MANDATORY "The shell of the service user" '/bin/bash';
defineEnvVar SERVICE_USER_HOME MANDATORY "The home of the service user" '/home/pencil';
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
