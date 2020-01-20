defineEnvVar PARENT_IMAGE_TAG MANDATORY "The version of the parent image" "0.11";
defineEnvVar JENKINS_VERSION MANDATORY "The Jenkins version" "2.215";
defineEnvVar TAG MANDATORY "The image tag" '${JENKINS_VERSION}';
defineEnvVar SERVICE_USER MANDATORY "The service user" "jenkins";
defineEnvVar SERVICE_USER_PASSWORD MANDATORY "The jenkins password" "${RANDOM_PASSWORD}";
defineEnvVar SERVICE_GROUP MANDATORY "The service group" "jenkins";
defineEnvVar SERVICE_USER_HOME MANDATORY "The service user home" '/home/jenkins';
defineEnvVar SERVICE_USER_SHELL MANDATORY "The shell of the service user" "/bin/bash";
overrideEnvVar ENABLE_LOGSTASH true;
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
