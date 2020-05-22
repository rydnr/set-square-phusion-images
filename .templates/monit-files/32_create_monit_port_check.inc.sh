# env: DOCKERFILES_LOCATION: The folder containing the dockerfiles. Defaults to /Dockerfiles.
defineEnvVar DOCKERFILES_LOCATION OPTIONAL "The folder containing the dockerfiles" "/Dockerfiles";
# env: MONIT_CONF_FOLDER: Monit's configuration folder. Defaults to /etc/monit/monitrc.d.
defineEnvVar MONIT_CONF_FOLDER OPTIONAL "Monit's configuration folder" "/etc/monit/monitrc.d";
# env: MONIT_CONF_FILE: The Monit configuration file to make it check the exposed ports are available. Defaults to ${MONIT_CONF_FOLDER}/ports.
defineEnvVar MONIT_CONF_FILE OPTIONAL "The Monit configuration file to make it check the exposed ports are available" '${MONIT_CONF_FOLDER}/ports';
# env: PORT_TIMEOUT: The timeout until the port is considered unavailable. Defaults to 10 seconds.
defineEnvVar PORT_TIMEOUT OPTIONAL "The timeout until the port is considered unavailable" "10 seconds";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
