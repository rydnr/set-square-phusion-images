defineEnvVar PARENT_IMAGE_TAG "The tag of the parent image" "0.9.22";
defineEnvVar ROBO3T_VERSION "The Robo3T version" '1.2.1';
defineEnvVar ROBO3T_HASH "The Robo3T hash" '3e50a65';
defineEnvVar TAG "The image tag" '${ROBO3T_VERSION}-${ROBO3T_HASH}';
defineEnvVar SERVICE_USER "The service user" 'robo3t';
defineEnvVar SERVICE_GROUP "The service group" 'robo3t';
defineEnvVar SERVICE_USER_SHELL "The shell of the service user" '/bin/bash';
defineEnvVar SERVICE_USER_HOME "The home of the service user" '/home/robo3t';
