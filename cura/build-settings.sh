defineEnvVar CURA_VERSION "The Cura version" "15.04.2";
defineEnvVar CURA_ARTIFACT "The Cura artifact" 'cura_${CURA_VERSION}-debian_amd64.deb';
defineEnvVar CURA_URL 'The url to download the Cura artifact' 'http://software.ultimaker.com/current/${CURA_ARTIFACT}';
defineEnvVar LICENSE_FILE \
             "The file with the license details" \
             'LICENSE.gpl3';
defineEnvVar COPYRIGHT_PREAMBLE_FILE \
             "The file with the copyright preamble" \
             'copyright-preamble.default.txt';
