defineEnvVar PARENT_IMAGE_TAG MANDATORY "The parent image tag" "0.11";
defineEnvVar TAG MANDATORY 'the tag' '${PARENT_IMAGE_TAG}';
defineEnvVar MESHROOM_VERSION MANDATORY 'The Meshroom version' 'v2019.2.0';
overrideEnvVar ENABLE_CRON MANDATORY "false";
overrideEnvVar ENABLE_MONIT MANDATORY "false";
overrideEnvVar ENABLE_RSNAPSHOT MANDATORY "false";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
