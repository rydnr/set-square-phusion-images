defineEnvVar FILEBEAT_YML_FILE MANDATORY "The filebeat.yml file" "/etc/filebeat/filebeat.yml";
defineEnvVar LOG_FILES MANDATORY "Which log files to forward" "/var/log/auth.log /var/log/syslog";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
