defineEnvVar BASE_TAG "The base tag" "201611";
defineEnvVar NODEJS_MAJOR_VERSION "The major version of NodeJS" "6";
overrideEnvVar TAG '${NODEJS_MAJOR_VERSION}';
defineEnvVar SERVICE_USER "The name of the user" '${NAMESPACE}';
defineEnvVar SERVICE_GROUP "The name of the group" "users";
overrideEnvVar ENABLE_RSNAPSHOT "false";
overrideEnvVar ENABLE_LOGSTASH "false";
