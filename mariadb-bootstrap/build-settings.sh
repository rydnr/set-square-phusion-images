defineEnvVar PARENT_IMAGE_TAG MANDATORY "The version of the parent image" "latest"
defineEnvVar UBUNTU_VERSION MANDATORY "The version available in Ubuntu" "$(docker run --rm -it ${BASE_IMAGE_64BIT}:${PARENT_IMAGE_TAG} remote-ubuntu-version mariadb-client | sed 's/^.*://g' | sed 's/[^0-9a-zA-Z\._-]//g')"
overrideEnvVar TAG '${UBUNTU_VERSION}'
overrideEnvVar ENABLE_CRON "false"
overrideEnvVar ENABLE_MONIT "false"
overrideEnvVar ENABLE_RSNAPSHOT "false"
overrideEnvVar ENABLE_SYSLOG "false"
overrideEnvVar ENABLE_LOCAL_SMTP "false"
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
