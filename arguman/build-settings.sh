defineEnvVar PARENT_IMAGE_TAG "The tag of the parent image" "0.9.21";
defineEnvVar SERVICE_USER "The service user" "apache";
defineEnvVar SERVICE_GROUP "The service group" "apache";
defineEnvVar SERVICE_USER_HOME "The home of the service user" '/home/${SERVICE_USER}';
defineEnvVar SERVICE_USER_SHELL "The shell of the service user" "/bin/bash";
