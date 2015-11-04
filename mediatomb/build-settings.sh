defineEnvVar MEDIATOMB_USER "The MediaTomb user" "mediatomb";
defineEnvVar MEDIATOMB_PASSWORD "The MediaTomb password" "secret" "${RANDOM_PASSWORD}";
defineEnvVar LICENSE_FILE \
             "The file with the license details" \
             'LICENSE.gpl3';
defineEnvVar COPYRIGHT_PREAMBLE_FILE \
             "The file with the copyright preamble" \
             'copyright-preamble.default.txt';
