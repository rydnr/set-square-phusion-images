# env: PARENT_IMAGE_TAG: The tag of the parent image. Defaults to master.
overrideEnvVar PARENT_IMAGE_TAG "master";
# env: TAG: The tag of the image. Defaults to ${PARENT_IMAGE_TAG}.
overrideEnvVar TAG "${PARENT_IMAGE_TAG}";
# env: DISABLE_ANSI_COLORS: Whether to disable ANSI colors. Defaults to true.
defineEnvVar DISABLE_ANSI_COLORS MANDATORY "Whether to disable ANSI colors" true;
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
