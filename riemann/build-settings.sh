defineEnvVar RIEMANN_VERSION MANDATORY "The version of Riemann" '0.2.11';
defineEnvVar RIEMANN_ARTIFACT MANDATORY "The Riemann artifact" 'riemann_${RIEMANN_VERSION}_all.deb';
defineEnvVar RIEMANN_URL MANDATORY "The url of the Riemann artifact" 'https://aphyr.com/riemann/${RIEMANN_ARTIFACT}';
overrideEnvVar TAG '${RIEMANN_VERSION}';
defineEnvVar RIEMANN_DIGEST MANDATORY "The md5 of the Riemann artifact" '8f074b9ad3321a962d3a32a7a54cf930';
defineEnvVar PARENT_IMAGE_TAG MANDATORY "The tag of the parent image" '201701';
defineEnvVar SERVICE_USER MANDATORY "The Riemann user" "riemann";
defineEnvVar SERVICE_GROUP MANDATORY "The Riemann group" "riemann";
defineEnvVar SERVICE_USER_HOME MANDATORY "The home of Riemann user" "/opt/riemann";
defineEnvVar SERVICE_USER_SHELL MANDATORY "The shell of Riemann user" "/bin/bash";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
