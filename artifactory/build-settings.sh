defineEnvVar PARENT_IMAGE_TAG MANDATORY "The version of the parent image" "0.11";
defineEnvVar ARTIFACTORY_VERSION MANDATORY "The version of Artifactory" "7.2.1";
defineEnvVar TAG MANDATORY "The image tag" '${ARTIFACTORY_VERSION}';
defineEnvVar SERVICE_USER MANDATORY "The service user" "artifactory";
defineEnvVar SERVICE_USER_PASSWORD MANDATORY "The artifactory password" "${RANDOM_PASSWORD}";
defineEnvVar SERVICE_GROUP MANDATORY "The service group" "artifactory";
defineEnvVar SERVICE_USER_HOME MANDATORY "The service user home" '/home/artifactory';
defineEnvVar SERVICE_USER_SHELL MANDATORY "The shell of the service user" "/bin/bash";
overrideEnvVar ENABLE_LOGSTASH true;
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
