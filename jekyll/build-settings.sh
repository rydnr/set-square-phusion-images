defineEnvVar PARENT_IMAGE_TAG MANDATORY "The tag of the parent image" "0.11";
overrideEnvVar TAG "${PARENT_IMAGE_TAG}";
defineEnvVar SERVICE_USER MANDATORY "The service user" "jekyll";
defineEnvVar SERVICE_GROUP MANDATORY "The service group" "jekyll";
defineEnvVar SERVICE_USER_HOME MANDATORY "The home of the jekyll user" "/var/www/jekyll";
defineEnvVar SERVICE_USER_SHELL MANDATORY "The shell of the jekyll user" "/bin/bash";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
