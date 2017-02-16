defineEnvVar PARENT_IMAGE_TAG "The tag of the parent image" "201701";
defineEnvVar GRADLE_VERSION "The Gradle version" '3.2.1';
defineEnvVar PHARO_VERSION "The Pharo version" "5.0";
overrideEnvVar TAG '${GRADLE_VERSION}-${PHARO_VERSION}';
defineEnvVar PHARO_VERSION_ZEROCONF "The Pharo version, as expected by the Zeroconf script in get.pharo.org" '$(echo ${PHARO_VERSION} | tr -d '.')';
overrideEnvVar ENABLE_LOGSTASH 'false';
