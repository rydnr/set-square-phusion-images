defineEnvVar PARENT_IMAGE_TAG MANDATORY "The tag of the parent image" "0.11";
defineEnvVar ROBOMONGO_VERSION MANDATORY "The Robomongo version" '1.1.1';
defineEnvVar ROBOMONGO_HASH MANDATORY "The Robomongo hash" 'c93c6b0';
defineEnvVar TAG MANDATORY "The image tag" '${ROBOMONGO_VERSION}-${ROBOMONGO_HASH}';
defineEnvVar SERVICE_USER MANDATORY "The service user" 'robomongo';
defineEnvVar SERVICE_GROUP MANDATORY "The service group" 'robomongo';
defineEnvVar SERVICE_USER_SHELL MANDATORY "The shell of the service user" '/bin/bash';
defineEnvVar SERVICE_USER_HOME MANDATORY "The home of the service user" '/home/robomongo';
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
