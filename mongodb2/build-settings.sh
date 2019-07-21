defineEnvVar PARENT_IMAGE_TAG MANDATORY "The tag of the parent image" "0.11";
defineEnvVar MONGODB_VERSION MANDATORY "The version of MongoDB" "2.6.12";
defineEnvVar TAG MANDATORY '${MONGODB_VERSION}';
defineEnvVar SERVICE_USER MANDATORY "The service user" "mongodb";
defineEnvVar SERVICE_GROUP MANDATORY "The service group" "mongodb";
defineEnvVar SERVICE_USER_SHELL MANDATORY "The shell" "/bin/bash";
defineEnvVar SERVICE_USER_HOME MANDATORY "The home of the service user" "/var/lib/mongodb";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
