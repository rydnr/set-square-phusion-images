defineEnvVar PARENT_IMAGE_TAG "The tag of the parent image" "0.9.21";
defineEnvVar TAG "The image tag" '0.1';
defineEnvVar SERVICE_USER "The service user" 'pika';
defineEnvVar SERVICE_GROUP "The service group" 'pika';
defineEnvVar SERVICE_USER_SHELL "The shell of the service user" '/bin/bash';
defineEnvVar SERVICE_USER_HOME "The home of the service user" '/home/${SERVICE_USER}';
