# env: PARENT_IMAGE_TAG: The tag of the parent image. Defaults to 18.04-1.0.0-amd64.
overrideEnvVar PARENT_IMAGE_TAG "latest"
# env: GRADLE_VERSION: The Gradle version. Defaults to 7.4.1.
defineEnvVar GRADLE_VERSION MANDATORY "The Gradle version" '7.4.1'
# env: PHARO_VERSION: The Pharo version. Defaults to 8.0.
defineEnvVar PHARO_VERSION MANDATORY "The Pharo version" "10.0"
overrideEnvVar TAG '${GRADLE_VERSION}-${PHARO_VERSION}-root'
overrideEnvVar ENABLE_LOGSTASH 'false'
# env: SERVICE_USER: The service use. Defaults to pharo.
defineEnvVar SERVICE_USER MANDATORY "The service user" "pharo"
# env: SERVICE_USER_PASSWORD: The service user password. Defaults to ${RANDOM_PASSWORD}.
defineEnvVar SERVICE_USER_PASSWORD MANDATORY "The service user password" '${RANDOM_PASSWORD}'
# env: SERVICE_GROUP: The service group. Defaults to pharo.
defineEnvVar SERVICE_GROUP MANDATORY "The service group" "pharo"
# env: SERVICE_USER_HOME: The home of the service user. Defaults to /home/pharo.
defineEnvVar SERVICE_USER_HOME MANDATORY "The home of the service user" "/home/pharo"
# env; SERVICE_USER_SHELL: The shell of the service user. Defaults to /bin/bash.
defineEnvVar SERVICE_USER_SHELL MANDATORY "The shell of the service user" "/bin/bash"
# edv: WORKSPACE: The workspace folder. Defaults to ${SERVICE_USER_HOME}/work.
defineEnvVar WORKSPACE MANDATORY "The workspace folder" '${SERVICE_USER_HOME}/work'
# env: GIT_USER_NAME: The user.name for git. Defaults to ${SERVICE_USER}.
defineEnvVar GIT_USER_NAME MANDATORY "The user.name for git" '${SERVICE_USER}'
#env: GIT_USER_EMAIL: The user.email for git. Defaults to ${SERVICE_USER}@${DOMAIN}.
defineEnvVar GIT_USER_EMAIL MANDATORY "The user.email for git" '${SERVICE_USER}@${DOMAIN}'
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
