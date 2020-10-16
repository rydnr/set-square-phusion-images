defineEnvVar PARENT_IMAGE_TAG MANDATORY "The parent image tag" "18.04-1.0.0-amd64";
defineEnvVar TAG MANDATORY "The tag" "${PARENT_IMAGE_TAG}";
defineEnvVar DISABLE_ANSI_COLORS MANDATORY "Whether to disable ANSI colors" false;
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
