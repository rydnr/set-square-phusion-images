defineEnvVar PARENT_IMAGE_TAG "The tag of the parent image" "0.9.22";
defineEnvVar SUPERSET_DEFAULT_VIRTUAL_HOST "The default virtual host" 'superset.${DOMAIN}';
defineEnvVar SERVICE_USER "The service user" "superset";
defineEnvVar SERVICE_GROUP "The group of the service user" "superset";
defineEnvVar SERVICE_USER_SHELL "The shell of the service user" "/bin/bash";
defineEnvVar SERVICE_USER_HOME "The home of the service user" '/opt/superset';
defineEnvVar SERVICE_USER_PASSWORD "The password of the service user" '${RANDOM_PASSWORD}';
