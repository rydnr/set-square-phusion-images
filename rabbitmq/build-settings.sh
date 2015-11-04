defineEnvVar RABBITMQ_USER "The RabbitMQ user" "rabbitmq";
defineEnvVar RABBITMQ_PASSWORD "The RabbitMQ password" "secret" "${RANDOM_PASSWORD}";
defineEnvVar RABBITMQ_EXCHANGE "The RabbitMQ exchange" '${NAMESPACE}';
defineEnvVar RABBITMQ_VIRTUALHOST "The RabbitMQ virtual host" '${NAMESPACE}';
defineEnvVar RABBITMQ_QUEUE "The queue in RabbitMQ" "exchange@queue";
defineEnvVar RABBITMQ_ROUTING_KEY "The RabbitMQ routing queue" "#";
defineEnvVar LICENSE_FILE \
             "The file with the license details" \
             'LICENSE.gpl3';
defineEnvVar COPYRIGHT_PREAMBLE_FILE \
             "The file with the copyright preamble" \
             'copyright-preamble.default.txt';
