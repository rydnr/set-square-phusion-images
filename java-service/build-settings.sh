defineEnvVar PARENT_IMAGE_TAG MANDATORY "The tag of the parent image" "0.11";
defineEnvVar APP_HOME MANDATORY "The Grails application directory" "/opt/java-app";
defineEnvVar SERVICE_USER MANDATORY "The service user" '${NAMESPACE}';
defineEnvVar SERVICE_GROUP MANDATORY "The service group" '${SERVICE_USER}';
defineEnvVar SERVICE_USER_HOME MANDATORY "The service user home" '${APP_HOME}';
defineEnvVar SERVICE_USER_SHELL MANDATORY "The service user shell" "/bin/bash";
defineEnvVar JAVA_DEFAULT_LOCALE MANDATORY "The default locale for grails" "es_ES";
defineEnvVar JAVA_DEFAULT_ENCODING MANDATORY "The default enconding for grails" "UTF-8";
defineEnvVar DEFAULT_JAVA_OPTS MANDATORY "The default java options" "-Djava.security.egd=file:/dev/./urandom";
defineEnvVar JAVA_OPTS MANDATORY "The default Java options" '${DEFAULT_JAVA_OPTS}';
overrideEnvVar ENABLE_LOCAL_SMTP "false";
overrideEnvVar ENABLE_RSNAPSHOT "false";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
