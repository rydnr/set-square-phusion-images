defineEnvVar PARENT_IMAGE_TAG "The version of the parent image" "${TAG}";
defineEnvVar NEXUS_VERSION "The version of Sonatype Nexus" "3.1.0-04";
defineEnvVar TAG "The image tag" '${NEXUS_VERSION}';
defineEnvVar NEXUS_ARTIFACT \
             "The Nexus artifact" \
             'nexus-${NEXUS_VERSION}-unix.tar.gz';
defineEnvVar NEXUS_DOWNLOAD_URL \
             "The url to download Nexus from" \
             'https://download.sonatype.com/nexus/3/${NEXUS_ARTIFACT}';
defineEnvVar NEXUS_MIN_MEMORY "The minimal memory setting for Nexus" "1024m";
defineEnvVar NEXUS_MAX_MEMORY "The maximum memory setting for Nexus" "4096m";
defineEnvVar NEXUS_MAX_PERM_SIZE "The maxPermSize setting for Nexus" "192m";
defineEnvVar NEXUS_DEFAULT_VIRTUAL_HOST "The default virtual host for Nexus" 'nexus.${DOMAIN}';
defineEnvVar NEXUS_UI_HTTP_PORT "The default HTTP por for Nexus" "8081";
defineEnvVar NEXUS_UI_HTTPS_PORT "The default HTTPS por for Nexus" "8083";
defineEnvVar NEXUS_DOCKER_REGISTRY_PORT "The HTTPS port for the Docker registry" "18443";
defineEnvVar NEXUS_DOCKER_GROUP_PORT "The HTTPS port for the Dcoker group (proxy + registry)" "18444";
defineEnvVar NEXUS_WORK_FOLDER "The work folder used in Nexus" "/opt/sonatype/sonatype-work";
defineEnvVar SERVICE_USER "The service user" "nexus";
defineEnvVar SERVICE_GROUP "The service group" "nexus";
overrideEnvVar ENABLE_LOGSTASH "true";
defineEnvVar SERVICE_USER_HOME \
             'The home of the ${SERVICE_USER} user' \
             '/opt/sonatype/nexus/sonatype-work';
defineEnvVar SERVICE_USER_SHELL \
             'The shell of the ${SERVICE_USER} user' \
             '/bin/false';

