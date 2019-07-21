defineEnvVar MCOLLECTIVE_ACTIVEMQ_PORT MANDATORY "The ActiveMQ port" "61613";
defineEnvVar MCOLLECTIVE_ACTIVEMQ_CLIENT_PASSWORD MANDATORY "The password for the ActiveMQ client" "secret" "${RANDOM_PASSWORD}";
defineEnvVar MCOLLECTIVE_ACTIVEMQ_SERVER_PASSWORD MANDATORY "The password for the ActiveMQ server" "secret" "${RANDOM_PASSWORD}";
defineEnvVar MCOLLECTIVE_ACTIVEMQ_PRE_SHARED_KEY MANDATORY "The pre-shared key for ActiveMQ" "secret" "${RANDOM_PASSWORD}";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
