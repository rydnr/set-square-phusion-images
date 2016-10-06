defineEnvVar GRADLE_VERSION "The Gradle version" "3.1";
overrideEnvVar ENABLE_LOGSTASH 'false';
defineEnvVar SERVICE_USER "The user account" "${NAMESPACE}";
defineEnvVar SERVICE_GROUP "The group" "users";
defineEnvVar DEFAULT_DOCKER_API_VERSION "The docker API version" "1.23";
