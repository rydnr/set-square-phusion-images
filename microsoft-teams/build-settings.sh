defineEnvVar PARENT_IMAGE_TAG MANDATORY "The tag of the parent image" "0.11";
defineEnvVar MICROSOFT_TEAMS_VERSION MANDATORY "The BloomRPC version" '1.3.00.958';
defineEnvVar TAG MANDATORY "The image tag" '${MICROSOFT_TEAMS_VERSION}';
defineEnvVar SERVICE_USER MANDATORY "The service user" 'teams';
defineEnvVar SERVICE_GROUP MANDATORY "The service group" 'teams';
defineEnvVar SERVICE_USER_SHELL MANDATORY "The shell of the service user" '/bin/bash';
defineEnvVar SERVICE_USER_HOME MANDATORY "The home of the service user" '/home/teams';
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
