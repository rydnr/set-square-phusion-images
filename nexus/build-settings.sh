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
defineEnvVar BACKUP_HOST_SSH_PORT \
             "The SSH port of the backup host" \
             "$(grep -e nexus sshports.txt || echo nexus 22 | awk '{print $2;}')";
