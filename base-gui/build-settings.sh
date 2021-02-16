defineEnvVar TAG MANDATORY 'the tag' '${PARENT_IMAGE_TAG}';
overrideEnvVar ENABLE_CRON MANDATORY "false";
overrideEnvVar ENABLE_MONIT MANDATORY "false";
overrideEnvVar ENABLE_RSNAPSHOT MANDATORY "false";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
