defineEnvVar PARENT_IMAGE_TAG "The tag of the parent image" "201703";
defineEnvVar SERVICE_USER "The name of the service user" '${NAMESPACE}';
defineEnvVar SERVICE_GROUP "The group of the service user" 'users';
defineEnvVar SERVICE_USER_HOME "The home of the service user" "/home/${NAMESPACE}";
defineEnvVar SERVICE_USER_SHELL "The shell of the service user" "/bin/bash";
defineEnvVar WORKSPACE "The workspace" "/work";
