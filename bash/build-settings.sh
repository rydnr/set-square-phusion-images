defineEnvVar PARENT_IMAGE_TAG MANDATORY "The tag of the parent image" "0.11";
defineEnvVar TAG MANDATORY "The tag of the image" '${PARENT_IMAGE_TAG}';
defineEnvVar SERVICE_USER MANDATORY "The name of the service user" '${NAMESPACE}';
defineEnvVar SERVICE_GROUP MANDATORY "The group of the service user" 'users';
defineEnvVar SERVICE_USER_HOME MANDATORY "The home of the service user" "/home/${NAMESPACE}";
defineEnvVar SERVICE_USER_SHELL MANDATORY "The shell of the service user" "/bin/bash";
defineEnvVar WORKSPACE MANDATORY "The workspace" "/work";
defineEnvVar DOCKER_API_VERSION MANDATORY "The docker API version" "1.23";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
