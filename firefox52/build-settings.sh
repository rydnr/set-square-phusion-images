defineEnvVar PARENT_IMAGE_TAG MANDATORY "The tag of the parent image" "0.11";
defineEnvVar TAG MANDATORY "The image tag" '52';
defineEnvVar SERVICE_USER MANDATORY "The service user" 'firefox';
defineEnvVar SERVICE_GROUP MANDATORY "The service group" 'firefox';
defineEnvVar SERVICE_USER_SHELL MANDATORY "The shell of the service user" '/bin/bash';
defineEnvVar SERVICE_USER_HOME MANDATORY "The home of the service user" '/home/firefox';
overrideEnvVar ENABLE_LOGSTASH false;
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
