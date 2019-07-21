defineEnvVar PARENT_IMAGE_TAG MANDATORY "The version of the parent image" "0.11";
defineEnvVar PACKETBEAT_VERSION MANDATORY "The packetbeat version" "1.3.1";
overrideEnvVar TAG '${PACKETBEAT_VERSION}';
overrideEnvVar ENABLE_LOGSTASH "false";
overrideEnvVar ENABLE_LOCAL_SMTP "false";
overrideEnvVar ENABLE_CRON "false";
overrideEnvVar ENABLE_RSNAPSHOT "false";
overrideEnvVar ENABLE_SYSLOG "false";
defineEnvVar SERVICE_USER MANDATORY "The service user" "packetbeat";
defineEnvVar SERVICE_GROUP MANDATORY "The group of the service account" "packetbeat";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
