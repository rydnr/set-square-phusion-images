defineEnvVar PARENT_IMAGE_TAG MANDATORY "The tag of the parent image" "0.11";
defineEnvVar PHARO_VERSION MANDATORY "The Pharo version" "7.0";
overrideEnvVar TAG '${PHARO_VERSION}';
defineEnvVar SERVICE_USER MANDATORY "The service user" "pillar";
defineEnvVar SERVICE_GROUP MANDATORY "The service group" "pillar";
defineEnvVar SERVICE_USER_HOME MANDATORY "The home of the Pillar user" "/home/pillar";
defineEnvVar SERVICE_USER_SHELL MANDATORY "The shell of the Pillar user" "/bin/bash";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
