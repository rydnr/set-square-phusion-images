defineEnvVar PARENT_IMAGE_TAG MANDATORY "The tag of the parent image" "0.11";
defineEnvVar GRADLE_VERSION MANDATORY "The Gradle version" '3.3';
defineEnvVar GRAILS_VERSION MANDATORY "The Grails version" "3.2.12";
overrideEnvVar TAG '${GRADLE_VERSION}-${GRAILS_VERSION}';
overrideEnvVar ENABLE_LOGSTASH 'false';
defineEnvVar SERVICE_USER MANDATORY "The service user" "grails";
defineEnvVar SERVICE_GROUP MANDATORY "The service group" "grails";
defineEnvVar SERVICE_USER_HOME MANDATORY "The home of the service user" '/home/${SERVICE_USER}';
defineEnvVar SERVICE_USER_SHELL MANDATORY "The shell of the service user" "/bin/bash";
defineEnvVar WORKSPACE MANDATORY "The workspace folder" '${SERVICE_USER_HOME}/work';
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
