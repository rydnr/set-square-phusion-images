defineEnvVar PARENT_IMAGE_TAG MANDATORY "The tag of the base image" "0.11";
defineEnvVar UBUNTU_VERSION MANDATORY "The version available in Ubuntu" "$(docker run --rm -it ${REGISTRY}/${NAMESPACE}/base:${PARENT_IMAGE_TAG} remote-ubuntu-version rabbitmq-server | sed 's/[^0-9a-zA-Z\._-]//g')";
overrideEnvVar TAG '${UBUNTU_VERSION}';
defineEnvVar RABBITMQ_USER MANDATORY "The RabbitMQ user" "rabbitmq";
defineEnvVar RABBITMQ_PASSWORD MANDATORY "The RabbitMQ password" "secret" "${RANDOM_PASSWORD}";
defineEnvVar RABBITMQ_EXCHANGE MANDATORY "The RabbitMQ exchange" '${NAMESPACE}';
defineEnvVar RABBITMQ_VIRTUALHOST MANDATORY "The RabbitMQ virtual host" '${NAMESPACE}';
defineEnvVar RABBITMQ_QUEUE MANDATORY "The queue in RabbitMQ" "exchange@queue";
defineEnvVar RABBITMQ_ROUTING_KEY MANDATORY "The RabbitMQ routing queue" "#";
defineEnvVar RABBITMQ_ULIMIT_N MANDATORY "The ulimit -n value to use when launching RabbitMQ" "50000";
defineEnvVar SERVICE_USER MANDATORY "The service user" '${RABBITMQ_USER}';
defineEnvVar SERVICE_GROUP MANDATORY "The service group" '${SERVICE_USER}';
defineEnvVar SERVICE_USER_HOME MANDATORY "The home of the service user" '/home/${SERVICE_USER}';
defineEnvVar SERVICE_USER_SHELL MANDATORY "The shell of the service user" '/bin/bash';
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
