defineEnvVar CURA_VERSION "The Cura version" "15.04.2";
defineEnvVar CURA_ARTIFACT "The Cura artifact" 'cura_${CURA_VERSION}-debian_amd64.deb';
defineEnvVar CURA_URL 'The url to download the Cura artifact' 'http://software.ultimaker.com/current/${CURA_ARTIFACT}';
