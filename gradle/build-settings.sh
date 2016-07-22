defineEnvVar GRADLE_VERSION "The Gradle version" "2.14";
overrideEnvVar ENABLE_LOGSTASH 'false';
defineEnvVar SERVICE_USER "The user account" "${NAMESPACE}";
defineEnvVar SERVICE_GROUP "The group" "users";
defineEnvVar DOCKER_VERSION "The docker version (inside the image)" "1.12.0-rc4";
defineEnvVar DOCKER_ARTIFACT "The docker artifact" 'docker-${DOCKER_VERSION}.tgz';
defineEnvVar DOCKER_URL "The docker url" 'https://test.docker.com/builds/Linux/x86_64/${DOCKER_ARTIFACT}';
defineEnvVar DOCKER_SHA256 "The docker artifact checksum" "fca3e76267d5dc9f6f9d42341c7daf525032a322e2ae16f0e69d71541abb6b6d";
