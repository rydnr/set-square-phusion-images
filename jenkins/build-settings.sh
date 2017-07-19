defineEnvVar PARENT_IMAGE_TAG "The version of the parent image" "0.9.21";
defineEnvVar JENKINS_VERSION "The Jenkins version" "2.70";
defineEnvVar TAG "The image tag" '${JENKINS_VERSION}';
defineEnvVar SERVICE_USER "The service user" "jenkins";
defineEnvVar SERVICE_USER_PASSWORD "The jenkins password" "${RANDOM_PASSWORD}";
defineEnvVar SERVICE_GROUP "The service group" "jenkins";
defineEnvVar SERVICE_USER_HOME "The service user home" '/backup/jenkins-home';
defineEnvVar SERVICE_USER_SHELL "The shell of the service user" "/bin/bash";
overrideEnvVar ENABLE_LOGSTASH true;
