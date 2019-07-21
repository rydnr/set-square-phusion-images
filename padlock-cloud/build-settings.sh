defineEnvVar PARENT_IMAGE_TAG MANDATORY "The tag of the parent image" "0.11";
overrideEnvVar TAG "v1.0.0";
defineEnvVar DEFAULT_PADLOCK_CLOUD_DOMAIN MANDATORY "The padlock-cloud domain" '${DOMAIN}';
defineEnvVar DEFAULT_PADLOCK_CLOUD_VIRTUALHOST MANDATORY "The padlock-cloud virtual host" 'padlock.${DEFAULT_PADLOCK_CLOUD_DOMAIN}';
defineEnvVar NGINX_SERVER_NAME MANDATORY "The nginx server name" '${PADLOCK_CLOUD_VIRTUALHOST}';
defineEnvVar LETSENCRYPT_RECOVERY_CONTACT_EMAIL MANDATORY "The email used for recovery or renewal purposes" 'letsencrypt@${DOMAIN}';
defineEnvVar SERVICE_USER MANDATORY "The Padlock-Cloud service user" "padlock";
defineEnvVar SERVICE_GROUP MANDATORY "The Padlock-Cloud service group" "padlock";
defineEnvVar SERVICE_USER_SHELL MANDATORY "The Padlock-Cloud account shell" "/bin/bash";
defineEnvVar SERVICE_USER_HOME MANDATORY "The home of the Padlock-Cloud account" "/opt/padlock-cloud";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
