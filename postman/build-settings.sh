defineEnvVar PARENT_IMAGE_TAG "The tag of the parent image" "0.9.21";
defineEnvVar POSTMAN_VERSION "The Postman version" '5.0.0';
defineEnvVar TAG "The image tag" '${POSTMAN_VERSION}';
defineEnvVar SERVICE_USER "The service user" 'postman';
defineEnvVar SERVICE_GROUP "The service group" 'postman';
defineEnvVar SERVICE_USER_SHELL "The shell of the service user" '/bin/bash';
defineEnvVar SERVICE_USER_HOME "The home of the service user" '/home/postman';
