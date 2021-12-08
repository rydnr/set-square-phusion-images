defineEnvVar PARENT_IMAGE_TAG MANDATORY "The tag of the base image" "latest"
defineEnvVar SERVICE_USER MANDATORY "The service user" 'pcp'
defineEnvVar SERVICE_GROUP MANDATORY "The service group" 'pcp'
defineEnvVar SERVICE_USER_HOME MANDATORY "The home of the service user" '/home/${SERVICE_USER}'
defineEnvVar SERVICE_USER_SHELL MANDATORY "The shell of the service user" '/bin/bash'
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
