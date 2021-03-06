defineEnvVar PARENT_IMAGE_TAG MANDATORY "The tag of the parent image" "0.11";
defineEnvVar LIGHTTABLE_VERSION MANDATORY "The LightTable version" '0.8.1';
defineEnvVar TAG MANDATORY "The image tag" '${LIGHTTABLE_VERSION}';
defineEnvVar SERVICE_USER MANDATORY "The service user" 'lighttable';
defineEnvVar SERVICE_GROUP MANDATORY "The service group" 'lighttable';
defineEnvVar SERVICE_USER_SHELL MANDATORY "The shell of the service user" '/bin/bash';
defineEnvVar SERVICE_USER_HOME MANDATORY "The home of the service user" '/home/lighttable';
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
