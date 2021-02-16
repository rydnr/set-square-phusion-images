defineEnvVar SERVICE_USER MANDATORY "The service user" 'minecraft';
defineEnvVar SERVICE_GROUP MANDATORY "The service group" 'minecraft';
defineEnvVar SERVICE_USER_SHELL MANDATORY "The shell of the service user" '/bin/bash';
defineEnvVar SERVICE_USER_HOME MANDATORY "The home of the service user" '/home/minecraft';
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
