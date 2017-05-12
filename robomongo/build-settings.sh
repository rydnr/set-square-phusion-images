defineEnvVar PARENT_IMAGE_TAG "The tag of the parent image" "0.9.21";
defineEnvVar ROBOMONGO_VERSION "The Robomongo version" '1.0.0';
defineEnvVar ROBOMONGO_HASH "The Robomongo hash" '89f24ea';
defineEnvVar TAG "The image tag" '${ROBOMONGO_VERSION}-${ROBOMONGO_HASH}';
defineEnvVar SERVICE_USER "The service user" 'robomongo';
defineEnvVar SERVICE_GROUP "The service group" 'robomongo';
defineEnvVar SERVICE_USER_SHELL "The shell of the service user" '/bin/bash';
defineEnvVar SERVICE_USER_HOME "The home of the service user" '/home/robomongo';
