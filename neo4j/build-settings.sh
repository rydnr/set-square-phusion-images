defineEnvVar PARENT_IMAGE_TAG MANDATORY "The version of the parent image" "0.11";
defineEnvVar UBUNTU_VERSION MANDATORY "The version available in Ubuntu" "4.1.3"; #$(docker run --rm -it ${BASE_IMAGE_64BIT}:${PARENT_IMAGE_TAG} remote-ubuntu-version neo4j | sed 's/^.*://g' | sed 's/[^0-9a-zA-Z\._-]//g')";
overrideEnvVar TAG '${UBUNTU_VERSION}';
defineEnvVar SERVICE_USER MANDATORY "The service user" "${IMAGE}";
defineEnvVar SERVICE_USER_PASSWORD MANDATORY "The password of the service user" "${RANDOM_PASSWORD}";
defineEnvVar SERVICE_GROUP MANDATORY "The service group" "${IMAGE}";
defineEnvVar SERVICE_USER_HOME MANDATORY "The home of the service user" '/backup/${IMAGE}';
defineEnvVar SERVICE_USER_SHELL MANDATORY "The shell of the service user" "/bin/bash";
overrideEnvVar ENABLE_CRON false;
overrideEnvVar ENABLE_MONIT true;
overrideEnvVar ENABLE_RSNAPSHOT false;
overrideEnvVar ENABLE_SYSLOG true;
overrideEnvVar ENABLE_LOGSTASH true;
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
