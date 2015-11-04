defineEnvVar GHOST_VERSION "The version of Ghost" "0.7.1";
defineEnvVar GHOST_ARTIFACT "The Ghost artifact" 'ghost-${GHOST_VERSION}.zip';
defineEnvVar GHOST_URL "The url to download Ghost" 'https://ghost.org/zip/${GHOST_ARTIFACT}';
defineEnvVar GHOST_DOMAIN "The domain for the Ghost application" 'ghost.${NAMESPACE}.com';
defineEnvVar LICENSE_FILE \
             "The file with the license details" \
             'LICENSE.gpl3';
defineEnvVar COPYRIGHT_PREAMBLE_FILE \
             "The file with the copyright preamble" \
             'copyright-preamble.default.txt';
