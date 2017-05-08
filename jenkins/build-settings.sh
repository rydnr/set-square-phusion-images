defineEnvVar PARENT_IMAGE_TAG "The version of the parent image" "201704";
defineEnvVar JENKINS_VERSION "The Jenkins version" "2.46.2";
defineEnvVar TAG "The image tag" '${JENKINS_VERSION}';
defineEnvVar SERVICE_USER "The service user" "jenkins";
defineEnvVar SERVICE_GROUP "The service group" "jenkins";
defineEnvVar SERVICE_USER_HOME "The service user home" '/backup/jenkins-home';
defineEnvVar SERVICE_USER_SHELL "The shell of the service user" "/bin/bash";
overrideEnvVar ENABLE_LOGSTASH true;
