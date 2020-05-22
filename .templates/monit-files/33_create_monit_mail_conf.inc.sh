# env: MONIT_MAIL_OUTPUT_FILE: The Monit configuration file for sending emails. Defaults to /etc/monit/conf-enabled/monit-mail.conf.
defineEnvVar MONIT_MAIL_OUTPUT_FILE OPTIONAL "The Monit configuration file for sending emails" "/etc/monit/conf-enabled/monit-mail.conf";
# env: MONIT_MAIL_TEMPLATE_FILE: The Monit template file for configuring email alerts. Defaults to /var/local/monit-mail.conf.tmpl.
defineEnvVar MONIT_MAIL_TEMPLATE_FILE OPTIONAL "The Monit template file for configuring email alerts" "/var/local/monit-mail.conf.tmpl";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
