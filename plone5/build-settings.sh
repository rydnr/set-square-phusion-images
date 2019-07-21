defineEnvVar PLONE_VIRTUAL_HOST MANDATORY "The virtual host" 'www.${DOMAIN}';
defineEnvVar PLONE_RELEASE_VERSION MANDATORY "The Plone release version" "5";
defineEnvVar PLONE_MAJOR_VERSION MANDATORY "The Plone major version" "0";
defineEnvVar PLONE_MINOR_VERSION MANDATORY "The Plone minor version" "5";
defineEnvVar PLONE_VERSION MANDATORY "The Plone version" '${PLONE_RELEASE_VERSION}.${PLONE_MAJOR_VERSION}.${PLONE_MINOR_VERSION}';
defineEnvVar PLONE_ARTIFACT MANDATORY "The Plone artifact" 'Plone-${PLONE_VERSION}-UnifiedInstaller';
defineEnvVar PLONE_FILE MANDATORY "The Plone file" '${PLONE_ARTIFACT}.tgz';
defineEnvVar PLONE_DOWNLOAD_URL MANDATORY "The url to download Plone3" 'https://launchpad.net/plone/${PLONE_RELEASE_VERSION}.${PLONE_MAJOR_VERSION}/${PLONE_VERSION}/+download/${PLONE_FILE}';
defineEnvVar PLONE_HOME MANDATORY "The home directory of the Plone installation" '/opt/plone';
defineEnvVar SERVICE_USER MANDATORY "The Plone user" "plone";
defineEnvVar SERVICE_GROUP MANDATORY "The Plone group" "plone";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
