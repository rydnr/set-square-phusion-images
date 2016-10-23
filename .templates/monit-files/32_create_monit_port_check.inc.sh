defineEnvVar DOCKERFILES_LOCATION \
             "The folder containing the dockerfiles" \
             "/Dockerfiles";
defineEnvVar MONIT_CONF_FOLDER \
             "Monit's configuration folder" \
             "/etc/monit/monitrc.d";
defineEnvVar MONIT_CONF_FILE \
             "The Monit configuration file to make it check the exposed ports are available" \
             '${MONIT_CONF_FOLDER}/ports';
defineEnvVar PORT_TIMEOUT \
             "The timeout until the port is considered unavailable" \
             "10 seconds";
