defineEnvVar PHARO_VERSION "The Pharo version" "4.0";
defineEnvVar PHARO_VERSION_ZEROCONF "The Pharo version, as expected by the Zeroconf script in get.pharo.org" '$(echo ${PHARO_VERSION} | tr -d '.')';
defineEnvVar LICENSE_FILE \
             "The file with the license details" \
             'LICENSE.gpl3';
defineEnvVar COPYRIGHT_PREAMBLE_FILE \
             "The file with the copyright preamble" \
             'copyright-preamble.default.txt';
overrideEnvVar ENABLE_LOGSTASH 'false';
