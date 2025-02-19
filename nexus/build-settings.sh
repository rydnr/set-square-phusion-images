defineEnvVar PARENT_IMAGE_TAG MANDATORY "The version of the parent image" "latest"
defineEnvVar NEXUS_VERSION MANDATORY "The version of Sonatype Nexus" "3.77.1-01"
overrideEnvVar TAG "${NEXUS_VERSION}"
defineEnvVar NEXUS_ARTIFACT MANDATORY "The Nexus artifact" 'nexus-${NEXUS_VERSION}-unix.tar.gz'
# defineEnvVar NEXUS_ARTIFACT MANDATORY "The Nexus artifact" 'release-${NEXUS_VERSION}.tar.gz'
defineEnvVar NEXUS_DOWNLOAD_URL MANDATORY "The url to download Nexus from" 'https://download.sonatype.com/nexus/3/${NEXUS_ARTIFACT}'
# defineEnvVar NEXUS_DOWNLOAD_URL MANDATORY "The url to download Nexus from" 'https://github.com/sonatype/nexus-public/archive/refs/tags/${NEXUS_ARTIFACT}'
defineEnvVar JAVA_VERSION MANDATORY "The version of the Java VM" "17"
defineEnvVar NEXUS_MIN_MEMORY MANDATORY "The minimal memory setting for Nexus" "1024m"
defineEnvVar NEXUS_MAX_MEMORY MANDATORY "The maximum memory setting for Nexus" "4096m"
defineEnvVar NEXUS_MAX_PERM_SIZE MANDATORY "The maxPermSize setting for Nexus" "192m"
defineEnvVar NEXUS_DEFAULT_VIRTUAL_HOST MANDATORY "The default virtual host for Nexus" 'nexus.${DOMAIN}'
defineEnvVar NEXUS_UI_HTTP_PORT MANDATORY "The default HTTP port for Nexus" "8081"
defineEnvVar NEXUS_UI_HTTPS_PORT MANDATORY "The default HTTPS port for Nexus" "8083"
defineEnvVar NEXUS_DOCKER_REGISTRY_PORT MANDATORY "The HTTPS port for the Docker registry" "18443"
defineEnvVar NEXUS_DOCKER_GROUP_PORT MANDATORY "The HTTPS port for the Docker group (proxy + registry)" "18444"
defineEnvVar NEXUS_WORK_FOLDER MANDATORY "The work folder used in Nexus" "/opt/sonatype/sonatype-work/nexus3"
defineEnvVar SERVICE_USER MANDATORY "The service user" "nexus"
defineEnvVar SERVICE_GROUP MANDATORY "The service group" "nexus"
defineEnvVar SERVICE_USER_HOME MANDATORY 'The home of the ${SERVICE_USER} user' '${NEXUS_WORK_FOLDER}'
defineEnvVar SERVICE_USER_SHELL MANDATORY 'The shell of the ${SERVICE_USER} user' '/bin/bash'
defineEnvVar SERVICE_USER_PASSWORD MANDATORY 'The password of the ${SERVICE_USER} user' 'aoumlk]{(pk/3{'
overrideEnvVar ENABLE_LOGSTASH "true"
defineEnvVar SSL_KEY_FOLDER MANDATORY "The folder storing the SSL key pairs" "/opt/sonatype/nexus/etc/ssl"
defineEnvVar SSL_KEYSTORE_NAME MANDATORY "The name of the keystore" "nexus.jks"
defineEnvVar SSL_CERTIFICATE_COMMON_NAME MANDATORY "The common name for the SSL certificate" 'nexus.${DOMAIN}'
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
