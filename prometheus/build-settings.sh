defineEnvVar PARENT_IMAGE_TAG MANDATORY "The tag of the parent image" "0.11";
defineEnvVar PROMETHEUS_VERSION MANDATORY "The Prometheus version" '1.5.0';
overrideEnvVar TAG '${PROMETHEUS_VERSION}';
defineEnvVar PROMETHEUS_FOLDER MANDATORY "The Prometheus folder" 'prometheus-${PROMETHEUS_VERSION}.linux-amd64';
defineEnvVar PROMETHEUS_ARTIFACT MANDATORY "The Prometheus artifact" '${PROMETHEUS_FOLDER}.tar.gz';
defineEnvVar PROMETHEUS_DOWNLOAD_URL MANDATORY "The Prometheus download url" 'https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/${PROMETHEUS_ARTIFACT}';
defineEnvVar SERVICE_USER MANDATORY "The Prometheus service user" "prometheus";
defineEnvVar SERVICE_GROUP MANDATORY "The Prometheus service group" "prometheus";
defineEnvVar SERVICE_USER_SHELL MANDATORY "The Prometheus account shell" "/bin/bash";
defineEnvVar SERVICE_USER_HOME MANDATORY "The Prometheus account home" "/opt/prometheus";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
