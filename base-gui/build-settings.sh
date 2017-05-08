defineEnvVar PARENT_IMAGE_TAG "The parent image tag" "0.9.21";
defineEnvVar TAG 'the tag' '${PARENT_IMAGE_TAG}';
overrideEnvVar ENABLE_CRON "false";
overrideEnvVar ENABLE_MONIT "false";
overrideEnvVar ENABLE_RSNAPSHOT "false";
