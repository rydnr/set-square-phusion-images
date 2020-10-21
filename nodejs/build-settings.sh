defineEnvVar NODEJS_MAJOR_VERSION MANDATORY "The major version of NodeJS" "8";
overrideEnvVar TAG '${NODEJS_MAJOR_VERSION}';
overrideEnvVar SERVICE_USER '${NAMESPACE}';
overrideEnvVar ENABLE_RSNAPSHOT "false";
overrideEnvVar ENABLE_LOGSTASH "false";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
