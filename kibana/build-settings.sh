defineEnvVar PARENT_IMAGE_TAG MANDATORY "The tag of the parent image" "0.11";
defineEnvVar KIBANA_MAJOR MANDATORY "The Kibana major version" "6.4";
defineEnvVar KIBANA_VERSION MANDATORY "The Kibana version" '${KIBANA_MAJOR}.0';
defineEnvVar TAG MANDATORY "The image tag" '${KIBANA_VERSION}';
defineEnvVar SERVER_NAME MANDATORY "The Kibana's server name" 'kibana.${DOMAIN}';
defineEnvVar SERVICE_USER MANDATORY "The service user" "kibana";
defineEnvVar SERVICE_GROUP MANDATORY "The service group" "kibana";
defineEnvVar SERVICE_USER_HOME MANDATORY "The home of the Kibana user" "/usr/share/kibana";
defineEnvVar SERVICE_USER_SHELL MANDATORY "The shell of the Kibana user" "/bin/bash";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
