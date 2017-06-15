defineEnvVar PARENT_IMAGE_TAG "The tag of the parent image" "0.9.21";
defineEnvVar PENCIL_VERSION "The Pencil version" '3.0.3';
defineEnvVar TAG "The image tag" '${PENCIL_VERSION}';
defineEnvVar SERVICE_USER "The service user" 'pencil';
defineEnvVar SERVICE_GROUP "The service group" 'pencil';
defineEnvVar SERVICE_USER_SHELL "The shell of the service user" '/bin/bash';
defineEnvVar SERVICE_USER_HOME "The home of the service user" '/home/pencil';
