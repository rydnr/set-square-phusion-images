defineEnvVar PARENT_IMAGE_TAG MANDATORY "The parent image tag" "0.11";
defineEnvVar DBEAVER_VERSION MANDATORY "The DBeaver version" "4.0.6";
defineEnvVar TAG MANDATORY "The image tag" '${DBEAVER_VERSION}';
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
