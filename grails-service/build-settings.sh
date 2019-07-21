defineEnvVar PARENT_IMAGE_TAG MANDATORY "The tag of the parent image" "0.11";
defineEnvVar APP_HOME MANDATORY "The application home" "/opt/grails";
defineEnvVar SERVICE_USER MANDATORY "The service user" "grails";
defineEnvVar SERVICE_GROUP MANDATORY "The service group" "grails";
defineEnvVar SERVICE_USER_HOME MANDATORY "The home of the service user" '${APP_HOME}';
defineEnvVar SERVICE_USER_SHELL MANDATORY "The shell of the service user" "/bin/bash";
defineEnvVar DEFAULT_LOCALE MANDATORY "The default locale" "en_US";
defineEnvVar DEFAULT_ENCODING MANDATORY "The default encoding" "UTF-8";
defineEnvVar DEFAULT_JAVA_OPTS MANDATORY "The default JAVA_OPTS" "";
overrideEnvVar ENABLE_CRON 'false';
overrideEnvVar ENABLE_RSNAPSHOT 'false';
overrideEnvVar ENABLE_MONIT 'false';
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
