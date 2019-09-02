overrideEnvVar PARENT_IMAGE_TAG '0.11';
defineEnvVar PULSECONNECT_VERSION MANDATORY "The pulseconnect version" "9.0r4.0-b943";
overrideEnvVar TAG "0.11-9.0r4.0-b943";
defineEnvVar PULSECONNECT_ARTIFACT MANDATORY "The pulseconnect artifact" 'ps-pulse-linux-${PULSECONNECT_VERSION}-ubuntu-debian-64-bit-installer.deb';
defineEnvVar PULSECONNECT_DOWNLOAD_URL MANDATORY "The url to download the PulseConnect client" 'https://rwts.com.au/pulse/${PULSECONNECT_ARTIFACT}';
defineEnvVar SERVICE_USER MANDATORY 'The service user' 'pulse';
defineEnvVar SERVICE_GROUP MANDATORY 'The service group' 'pulse';
defineEnvVar SERVICE_HOME MANDATORY '/usr/local/pulse';
#
