defineEnvVar PARENT_IMAGE_TAG MANDATORY "The tag of the parent image" "0.11";
defineEnvVar DEFAULT_JAVA_OPTS MANDATORY "The default Java opts" "-Djava.security.egd=file:/dev/./urandom";
defineEnvVar APP_HOME MANDATORY "The home of the Java app" "/opt/java-app";
defineEnvVar JAVA_DEFAULT_LOCALE MANDATORY "The default locale" "es_ES";
defineEnvVar JAVA_DEFAULT_ENCODING MANDATORY "The default encoding" "UTF-8";
defineEnvVar ENABLE_CRON MANDATORY "Whether cron is enabled" "false";
defineEnvVar ENABLE_MONIT MANDATORY "Whether monit is enabled" "false";
defineEnvVar ENABLE_RSNAPSHOT MANDATORY "Whether rsnapshot is enabled" "false";
defineEnvVar ENABLE_SSH MANDATORY "Whether ssh is enabled" "false";
defineEnvVar ENABLE_SYSLOG MANDATORY "Whether syslog is enabled" "true";
defineEnvVar ENABLE_LOCAL_SMTP MANDATORY "Whether local SMTP is enabled" "true";
defineEnvVar ENABLE_LOGSTASH MANDATORY "Whether logstash is enabled" "false";
defineEnvVar SERVICE_USER MANDATORY "The service user" "osoco";
defineEnvVar SERVICE_GROUP MANDATORY "The service group" "osoco";
defineEnvVar SERVICE_USER_SHELL MANDATORY "The shell of the service user" "/bin/bash";
defineEnvVar SERVICE_USER_HOME MANDATORY "The home of the service user" '${APP_HOME}';
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
