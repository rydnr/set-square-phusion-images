defineEnvVar PARENT_IMAGE_TAG MANDATORY "The tag of the parent image" "0.11";
defineEnvVar RABBITMQ_PERF_TEST_VERSION MANDATORY "The rabbitmq-perf-test version" "1.1.0";
defineEnvVar RABBITMQ_PERF_TEST_ARTIFACT MANDATORY "The rabbitmq-perf-test artifact" 'rabbitmq-perf-test-${RABBITMQ_PERF_TEST_VERSION}-bin.tar.gz'; #'perf-test-${RABBITMQ_PERF_TEST_VERSION}.jar';
defineEnvVar RABBITMQ_PERF_TEST_DOWNLOAD_URL MANDATORY "The download url for rabbitmq-perf-test" 'https://github.com/rabbitmq/rabbitmq-perf-test/releases/download/v${RABBITMQ_PERF_TEST_VERSION}/${RABBITMQ_PERF_TEST_ARTIFACT}'; # 'http://central.maven.org/maven2/com/rabbitmq/perf-test/${RABBITMQ_PERF_TEST_VERSION}/${RABBITMQ_PERF_TEST_ARTIFACT}';
defineEnvVar RABBITMQ_PERF_TEST_HOME MANDATORY "The home folder of RabbitMQ perf test" "/opt/rabbitmq-perf-test";
defineEnvVar SERVICE_USER MANDATORY "The service user" "rabbitmq-perf-test";
defineEnvVar SERVICE_GROUP MANDATORY "The service group" "rabbitmq-perf-test";
defineEnvVar SERVICE_USER_HOME MANDATORY "The home of the service user" '${RABBITMQ_PERF_TEST_HOME}';
defineEnvVar SERVICE_USER_SHELL MANDATORY "The shell of the service user" "/bin/false";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
