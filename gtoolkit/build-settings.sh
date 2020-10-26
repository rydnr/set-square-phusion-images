defineEnvVar PARENT_IMAGE_TAG MANDATORY "The tag of the parent image" "18.04-1.0.0-amd64";
overrideEnvVar TAG "$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/feenkcom/gtoolkit/releases/latest | awk -F/ '{print $NF;}')";
overrideEnvVar ENABLE_LOGSTASH false;
overrideEnvVar SERVICE_USER "pharo";
overrideEnvVar SERVICE_USER_PASSWORD '${RANDOM_PASSWORD}';
overrideEnvVar SERVICE_GROUP MANDATORY "pharo";
overrideEnvVar SERVICE_USER_HOME "/home/pharo";
defineEnvVar WORKSPACE MANDATORY "The workspace folder" '${SERVICE_USER_HOME}/work';
overrideEnvVar ENABLE_SSH "false";
overrideEnvVar ENABLE_MONIT "false";
overrideEnvVar ENABLE_SYSLOG "false";
overrideEnvVar ENABLE_CRON "false";
overrideEnvVar ENABLE_RSNAPSHOT "false";
overrideEnvVar ENABLE_LOCAL_SMTP "false";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
