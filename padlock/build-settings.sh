defineEnvVar PADLOCKIO_VERSION "The padlock version" "v1.2.0-beta.2";
defineEnvVar PARENT_IMAGE_TAG "The tag of the parent image" "201701";
overrideEnvVar TAG '${PADLOCKIO_VERSION}';
defineEnvVar PADLOCK_DOMAIN "The padlock domain" '${DOMAIN}';
defineEnvVar SERVICE_USER "The user service" "padlock";
defineEnvVar SERVICE_GROUP "The group service" "www-data";
defineEnvVar SERVICE_USER_HOME "The home of the service account" "/opt/padlock";
defineEnvVar SERVICE_USER_SHELL "The shell of the service account" "/bin/bash";
