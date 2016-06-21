defineEnvVar GRADLE_VERSION "The Gradle version" "2.9";
overrideEnvVar ENABLE_LOGSTASH 'false';
defineEnvVar SERVICE_USER "The user account" "${NAMESPACE}";
defineEnvVar SERVICE_GROUP "The group" "users";
