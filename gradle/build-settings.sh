defineEnvVar GRADLE_VERSION "The Gradle version" "2.8";
defineEnvVar LICENSE_FILE \
             "The file with the license details" \
             'LICENSE.gpl3';
defineEnvVar COPYRIGHT_PREAMBLE_FILE \
             "The file with the copyright preamble" \
             'copyright-preamble.default.txt';
overrideEnvVar ENABLE_LOGSTASH 'false';
