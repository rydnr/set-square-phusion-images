overrideEnvVar ENABLE_LOGSTASH "true";
defineEnvVar NEXUS_VERSION \
             "The version of Nexus" \
             "3.0.0-m5";
defineEnvVar NEXUS_ARTIFACT \
             "The Nexus artifact" \
             'nexus-${NEXUS_VERSION}-bundle.tar.gz';
defineEnvVar NEXUS_DOWNLOAD_URL \
             "The url to download Nexus from" \
             'https://download.sonatype.com/nexus/oss/${NEXUS_ARTIFACT}';
defineEnvVar NEXUS_DEFAULT_VIRTUAL_HOST "The default virtual host for Nexus" 'nexus.${DOMAIN}';
defineEnvVar NEXUS_HTTP_PORT "The default HTTP por for Nexus" "8081";
defineEnvVar NEXUS_DOCKER_GROUP_PORT "The HTTPS port for the Dcoker group (proxy + registry)" "8084";
defineEnvVar NEXUS_DOCKER_REGISTRY_PORT "The HTTPS port for the Docker registry" "8443";
