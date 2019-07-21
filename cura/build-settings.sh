defineEnvVar CURA_VERSION MANDATORY "The Cura version" "15.04.2";
defineEnvVar CURA_ARTIFACT MANDATORY "The Cura artifact" 'cura_${CURA_VERSION}-debian_amd64.deb';
defineEnvVar CURA_URL MANDATORY "The url to download the Cura artifact" 'http://software.ultimaker.com/current/${CURA_ARTIFACT}';
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
