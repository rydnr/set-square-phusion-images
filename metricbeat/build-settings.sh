defineEnvVar PARENT_IMAGE_TAG MANDATORY "The version of the parent image" "0.11";
defineEnvVar METRICBEAT_VERSION MANDATORY "The metricbeat version" "5.0.2";
overrideEnvVar TAG '${METRICBEAT_VERSION}';
overrideEnvVar ENABLE_LOGSTASH "false";
overrideEnvVar ENABLE_LOCAL_SMTP "false";
overrideEnvVar ENABLE_CRON "false";
overrideEnvVar ENABLE_RSNAPSHOT "false";
overrideEnvVar ENABLE_SYSLOG "false";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
