defineEnvVar PLONE_VIRTUAL_HOST "The virtual host" 'www.${DOMAIN}';
defineEnvVar PLONE3_RELEASE_VERSION "The Plone release version" "3";
defineEnvVar PLONE3_MAJOR_VERSION "The Plone major version" "1";
defineEnvVar PLONE3_MINOR_VERSION "The Plone minor version" "7";
defineEnvVar PLONE3_VERSION "The Plone version" '${PLONE3_RELEASE_VERSION}.${PLONE3_MAJOR_VERSION}.${PLONE3_MINOR_VERSION}';
defineEnvVar PLONE3_ARTIFACT \
             "The Plone artifact" \
             'Plone-${PLONE3_VERSION}-UnifiedInstaller';
defineEnvVar PLONE3_FILE \
             "The Plone file" \
             '${PLONE3_ARTIFACT}.tgz';
defineEnvVar PLONE3_DOWNLOAD_URL \
             "The url to download Plone3" \
             'https://launchpad.net/plone/${PLONE3_RELEASE_VERSION}.${PLONE3_MAJOR_VERSION}/${PLONE3_VERSION}/+download/${PLONE3_FILE}';
defineEnvVar PLONE3_HOME \
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
