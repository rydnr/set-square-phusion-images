defineEnvVar PARENT_IMAGE_TAG "The tag of the parent image" "201701";
overrideEnvVar TAG "v1.0.0";
defineEnvVar PADLOCK_CLOUD_DOMAIN "The padlock-cloud domain" '${DOMAIN}';
defineEnvVar PADLOCK_CLOUD_VIRTUALHOST "The padlock-cloud virtual host" 'padlock.${PADLOCK_CLOUD_DOMAIN}';
defineEnvVar SERVICE_USER "The Padlock-Cloud service user" "padlock";
defineEnvVar SERVICE_GROUP "The Padlock-Cloud service group" "padlock";
defineEnvVar SERVICE_USER_SHELL "The Padlock-Cloud account shell" "/bin/bash";
defineEnvVar SERVICE_USER_HOME "The home of the Padlock-Cloud account" "/opt/padlock-cloud";
