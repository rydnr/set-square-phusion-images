defineEnvVar COPYRIGHT_PREAMBLE_FILE \
             "The file with the copyright preamble" \
             'copyright-preamble.default.txt';
defineEnvVar LICENSE_FILE \
             "The file with the license details" \
             'LICENSE.gpl3';
overrideEnvVar ENABLE_CRON true;
overrideEnvVar ENABLE_MONIT true;
overrideEnvVar ENABLE_RSNAPSHOT true;
overrideEnvVar ENABLE_SYSLOG true;
overrideEnvVar ENABLE_LOGSTASH false;
overrideEnvVar ENABLE_SSH false;
