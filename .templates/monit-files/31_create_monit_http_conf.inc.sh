defineEnvVar MONIT_CONF_FOLDER \
             "Monit's configuration folder" \
             "/etc/monit/conf.d";
defineEnvVar MONIT_CONF_FILE \
             "The Monit configuration file to make it check the root filesystem usage" \
             '${MONIT_CONF_FOLDER}/httpd.conf';
defineEnvVar MONIT_HTTP_PORT \
             "The port used by Monit's webapp" \
             "2812";
defineEnvVar MONIT_HTTP_USER \
             "The user to login in monit's webapp" \
             "monit";
defineEnvVar MONIT_HTTP_PASSWORD \
             "The password to login in monit's webapp" \
             "secret";
defineEnvVar MONIT_HTTP_TIMEOUT \
             "The timeout before alerting that monit's own http interface is down" \
             "15 seconds";

