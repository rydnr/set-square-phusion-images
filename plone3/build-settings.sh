defineEnvVar PLONE_VIRTUAL_HOST MANDATORY "The virtual host" 'www.${DOMAIN}';
defineEnvVar PLONE3_RELEASE_VERSION MANDATORY "The Plone release version" "3";
defineEnvVar PLONE3_MAJOR_VERSION MANDATORY "The Plone major version" "1";
defineEnvVar PLONE3_MINOR_VERSION MANDATORY "The Plone minor version" "7";
defineEnvVar PLONE3_VERSION MANDATORY "The Plone version" '${PLONE3_RELEASE_VERSION}.${PLONE3_MAJOR_VERSION}.${PLONE3_MINOR_VERSION}';
defineEnvVar PLONE3_ARTIFACT MANDATORY "The Plone artifact" 'Plone-${PLONE3_VERSION}-UnifiedInstaller';
defineEnvVar PLONE3_FILE MANDATORY "The Plone file" '${PLONE3_ARTIFACT}.tgz';
defineEnvVar PLONE3_DOWNLOAD_URL MANDATORY "The url to download Plone3" 'https://launchpad.net/plone/${PLONE3_RELEASE_VERSION}.${PLONE3_MAJOR_VERSION}/${PLONE3_VERSION}/+download/${PLONE3_FILE}';
defineEnvVar PLONE3_HOME MANDATORY "The home directory of the Plone installation" '/opt/plone';
defineEnvVar SERVICE_USER MANDATORY "The Plone user" "plone";
defineEnvVar SERVICE_GROUP MANDATORY "The Plone group" "plone";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
