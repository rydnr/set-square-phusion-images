defineEnvVar DOCKERFILES_LOCATION MANDATORY \
             "The folder containing the dockerfiles" \
             "/Dockerfiles";
defineEnvVar MONIT_CONF_FOLDER MANDATORY \
             "Monit's configuration folder" \
             "/etc/monit/monitrc.d";
defineEnvVar MONIT_CONF_FILE MANDATORY \
             "The Monit configuration file to make it check the exposed ports are available" \
             '${MONIT_CONF_FOLDER}/ports';
defineEnvVar PORT_TIMEOUT MANDATORY \
             "The timeout until the port is considered unavailable" \
             "10 seconds";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
