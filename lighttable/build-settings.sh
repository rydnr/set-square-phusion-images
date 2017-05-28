defineEnvVar PARENT_IMAGE_TAG "The tag of the parent image" "0.9.21";
defineEnvVar LIGHTTABLE_VERSION "The LightTable version" '0.8.1';
defineEnvVar TAG "The image tag" '${LIGHTTABLE_VERSION}';
defineEnvVar SERVICE_USER "The service user" 'lighttable';
defineEnvVar SERVICE_GROUP "The service group" 'lighttable';
defineEnvVar SERVICE_USER_SHELL "The shell of the service user" '/bin/bash';
defineEnvVar SERVICE_USER_HOME "The home of the service user" '/home/lighttable';
