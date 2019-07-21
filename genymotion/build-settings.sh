defineEnvVar GENYMOTION_VERSION MANDATORY "The version of Genymotion" "2.6.0";
defineEnvVar GENYMOTION_ARTIFACT MANDATORY "The Genymotion artifact" 'genymotion-${GENYMOTION_VERSION}-ubuntu15_x64.bin';
defineEnvVar GENYMOTION_DOWNLOAD_URL MANDATORY "The url to download NodeJS artifact" 'http://files2.genymotion.com/genymotion/genymotion-${GENYMOTION_VERSION}/${GENYMOTION_ARTIFACT}';
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
