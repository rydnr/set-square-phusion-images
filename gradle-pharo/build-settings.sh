defineEnvVar PARENT_IMAGE_TAG "The tag of the parent image" "3.2.1";
defineEnvVar PHARO_VERSION "The Pharo version" "5.0";
defineEnvVar PHARO_VERSION_ZEROCONF "The Pharo version, as expected by the Zeroconf script in get.pharo.org" '$(echo ${PHARO_VERSION} | tr -d '.')';
overrideEnvVar ENABLE_LOGSTASH 'false';
