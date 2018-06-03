defineEnvVar PARENT_IMAGE_TAG "The tag of the parent image" "0.9.22";
defineEnvVar STUDIO3T_VERSION "The Studio3T version" '2018.3.1';
defineEnvVar TAG "The image tag" '${STUDIO3T_VERSION}';
defineEnvVar SERVICE_USER "The service user" 'studio3t';
defineEnvVar SERVICE_GROUP "The service group" 'studio3t';
defineEnvVar SERVICE_USER_SHELL "The shell of the service user" '/bin/bash';
defineEnvVar SERVICE_USER_HOME "The home of the service user" '/home/studio3t';
