defineEnvVar PLONE_VIRTUAL_HOST "The virtual host" 'www.${DOMAIN}';
defineEnvVar PLONE_RELEASE_VERSION "The Plone release version" "5";
defineEnvVar PLONE_MAJOR_VERSION "The Plone major version" "0";
defineEnvVar PLONE_MINOR_VERSION "The Plone minor version" "5";
defineEnvVar PLONE_VERSION "The Plone version" '${PLONE_RELEASE_VERSION}.${PLONE_MAJOR_VERSION}.${PLONE_MINOR_VERSION}';
defineEnvVar PLONE_ARTIFACT \
             "The Plone artifact" \
             'Plone-${PLONE_VERSION}-UnifiedInstaller';
defineEnvVar PLONE_FILE \
             "The Plone file" \
             '${PLONE_ARTIFACT}.tgz';
defineEnvVar PLONE_DOWNLOAD_URL \
             "The url to download Plone3" \
             'https://launchpad.net/plone/${PLONE_RELEASE_VERSION}.${PLONE_MAJOR_VERSION}/${PLONE_VERSION}/+download/${PLONE_FILE}';
defineEnvVar PLONE_HOME \
             "The home directory of the Plone installation" \
             '/opt/plone';
defineEnvVar SERVICE_USER "The Plone user" "plone";
defineEnvVar SERVICE_GROUP "The Plone group" "plone";
defineEnvVar LICENSE_FILE \
             "The file with the license details" \
             'LICENSE.gpl3';
defineEnvVar COPYRIGHT_PREAMBLE_FILE \
             "The file with the copyright preamble" \
             'copyright-preamble.default.txt';
