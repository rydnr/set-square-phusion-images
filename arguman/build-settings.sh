defineEnvVar PARENT_IMAGE_TAG MANDATORY "The tag of the parent image" "0.11";
defineEnvVar SERVICE_USER MANDATORY "The service user" "apache";
defineEnvVar SERVICE_GROUP MANDATORY "The service group" "apache";
defineEnvVar SERVICE_USER_HOME MANDATORY "The home of the service user" '/home/${SERVICE_USER}';
defineEnvVar SERVICE_USER_SHELL MANDATORY "The shell of the service user" "/bin/bash";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
