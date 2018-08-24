defineEnvVar PARENT_IMAGE_TAG "The tag of the parent image" "0.10.1";
defineEnvVar GRADLE_VERSION "The Gradle version" '3.3';
defineEnvVar GRAILS_VERSION "The Grails version" "3.2.12";
overrideEnvVar TAG '${GRADLE_VERSION}-${GRAILS_VERSION}';
overrideEnvVar ENABLE_LOGSTASH 'false';
defineEnvVar SERVICE_USER "The service user" "grails";
defineEnvVar SERVICE_GROUP "The service group" "grails";
defineEnvVar SERVICE_USER_HOME "The home of the service user" '/home/${SERVICE_USER}';
defineEnvVar SERVICE_USER_SHELL "The shell of the service user" "/bin/bash";
defineEnvVar WORKSPACE "The workspace folder" '${SERVICE_USER_HOME}/work';
