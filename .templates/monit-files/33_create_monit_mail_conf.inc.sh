defineEnvVar MONIT_MAIL_OUTPUT_FILE MANDATORY "The Monit configuration file for sending emails" "/etc/monit/conf-enabled/monit-mail.conf";
defineEnvVar MONIT_MAIL_TEMPLATE_FILE MANDATORY "The Monit template file for configuring email alerts" "/var/local/monit-mail.conf.tmpl";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
