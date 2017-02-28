defineEnvVar PARENT_IMAGE_TAG "The version of the parent image" "201612";
defineEnvVar METRICBEAT_VERSION "The metricbeat version" "5.0.2";
overrideEnvVar TAG '${METRICBEAT_VERSION}';
overrideEnvVar ENABLE_LOGSTASH "false";
overrideEnvVar ENABLE_LOCAL_SMTP "false";
overrideEnvVar ENABLE_CRON "false";
overrideEnvVar ENABLE_RSNAPSHOT "false";
overrideEnvVar ENABLE_SYSLOG "false";
