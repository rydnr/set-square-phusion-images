defineEnvVar PARENT_IMAGE_TAG "The version of the parent image" "${TAG}";
overrideEnvVar ENABLE_CRON "false";
overrideEnvVar ENABLE_MONIT "false";
overrideEnvVar ENABLE_RSNAPSHOT "false";
overrideEnvVar ENABLE_SYSLOG "false";
overrideEnvVar ENABLE_LOCAL_SMTP "false";
