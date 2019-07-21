defineEnvVar PADLOCKIO_VERSION MANDATORY "The padlock version" "v1.2.0-beta.2";
defineEnvVar PARENT_IMAGE_TAG MANDATORY "The tag of the parent image" "0.11";
overrideEnvVar TAG '${PADLOCKIO_VERSION}';
defineEnvVar PADLOCK_DOMAIN MANDATORY "The padlock domain" '${DOMAIN}';
defineEnvVar SERVICE_USER MANDATORY "The user service" "padlock";
defineEnvVar SERVICE_GROUP MANDATORY "The group service" "www-data";
defineEnvVar SERVICE_USER_HOME MANDATORY "The home of the service account" "/opt/padlock";
defineEnvVar SERVICE_USER_SHELL MANDATORY "The shell of the service account" "/bin/bash";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
