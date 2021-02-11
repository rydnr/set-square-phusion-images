defineEnvVar SERVICE_USER MANDATORY "The service user" postgresql;
defineEnvVar SERVICE_GROUP MANDATORY "The group of the service user" users;
defineEnvVar SERVICE_USER_HOME MANDATORY "The home of the service user" /home/postgresql;
defineEnvVar SERVICE_USER_SHELL MANDATORY "The service user shell" /bin/bash;
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet

