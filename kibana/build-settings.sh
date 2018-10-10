defineEnvVar PARENT_IMAGE_TAG "The tag of the parent image" "0.11";
defineEnvVar KIBANA_MAJOR "The Kibana major version" "6.4";
defineEnvVar KIBANA_VERSION "The Kibana version" '${KIBANA_MAJOR}.0';
defineEnvVar TAG "The image tag" '${KIBANA_VERSION}';
defineEnvVar SERVER_NAME "The Kibana's server name" 'kibana.${DOMAIN}';
defineEnvVar SERVICE_USER "The service user" "kibana";
defineEnvVar SERVICE_GROUP "The service group" "kibana";
defineEnvVar SERVICE_USER_HOME "The home of the Kibana user" "/usr/share/kibana";
defineEnvVar SERVICE_USER_SHELL "The shell of the Kibana user" "/bin/bash";
