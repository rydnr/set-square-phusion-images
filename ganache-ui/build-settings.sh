defineEnvVar PARENT_IMAGE_TAG MANDATORY "The tag of the parent image" "0.11";
defineEnvVar POSTMAN_VERSION MANDATORY "The Postman version" '5.0.0';
defineEnvVar TAG MANDATORY "The image tag" '${POSTMAN_VERSION}';
defineEnvVar SERVICE_USER MANDATORY "The service user" 'postman';
defineEnvVar SERVICE_GROUP MANDATORY "The service group" 'postman';
defineEnvVar SERVICE_USER_SHELL MANDATORY "The shell of the service user" '/bin/bash';
defineEnvVar SERVICE_USER_HOME MANDATORY "The home of the service user" '/home/postman';
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
