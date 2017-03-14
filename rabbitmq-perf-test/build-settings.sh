defineEnvVar PARENT_IMAGE_TAG "The tag of the parent image" "201701";
defineEnvVar RABBITMQ_PERF_TEST_VERSION "The rabbitmq-perf-test version" "1.1.0";
defineEnvVar RABBITMQ_PERF_TEST_ARTIFACT "The rabbitmq-perf-test artifact" 'rabbitmq-perf-test-${RABBITMQ_PERF_TEST_VERSION}-bin.tar.gz'; #'perf-test-${RABBITMQ_PERF_TEST_VERSION}.jar';
defineEnvVar RABBITMQ_PERF_TEST_DOWNLOAD_URL "The download url for rabbitmq-perf-test" 'https://github.com/rabbitmq/rabbitmq-perf-test/releases/download/v${RABBITMQ_PERF_TEST_VERSION}/${RABBITMQ_PERF_TEST_ARTIFACT}'; # 'http://central.maven.org/maven2/com/rabbitmq/perf-test/${RABBITMQ_PERF_TEST_VERSION}/${RABBITMQ_PERF_TEST_ARTIFACT}';
defineEnvVar RABBITMQ_PERF_TEST_HOME "The home folder of RabbitMQ perf test" "/opt/rabbitmq-perf-test";
defineEnvVar SERVICE_USER "The service user" "rabbitmq-perf-test";
defineEnvVar SERVICE_GROUP "The service group" "rabbitmq-perf-test";
defineEnvVar SERVICE_USER_HOME "The home of the service user" '${RABBITMQ_PERF_TEST_HOME}';
defineEnvVar SERVICE_USER_SHELL "The shell of the service user" "/bin/false";
