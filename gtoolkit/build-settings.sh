defineEnvVar PARENT_IMAGE_TAG MANDATORY "The tag of the parent image" "";
defineEnvVar TAG MANDATORY "The tag" 'latest';
overrideEnvVar ENABLE_LOGSTASH false;
overrideEnvVar SERVICE_USER MANDATORY "The service user" "pharo";
overrideEnvVar SERVICE_USER_PASSWORD MANDATORY "The service user password" '${RANDOM_PASSWORD}';
overrideEnvVar SERVICE_GROUP MANDATORY "The service group" "pharo";
overrideEnvVar SERVICE_USER_HOME MANDATORY "The home of the service user" "/home/pharo";
defineEnvVar WORKSPACE MANDATORY "The workspace folder" '${SERVICE_USER_HOME}/work';
overrideEnvVar ENABLE_SSH "false";
overrideEnvVar ENABLE_MONIT "false";
overrideEnvVar ENABLE_SYSLOG "false";
overrideEnvVar ENABLE_CRON "false";
overrideEnvVar ENABLE_RSNAPSHOT "false";
overrideEnvVar ENABLE_LOCAL_SMTP "false";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
