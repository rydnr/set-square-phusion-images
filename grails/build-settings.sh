defineEnvVar PARENT_IMAGE_TAG MANDATORY "The tag of the sdkman image" "0.11";
defineEnvVar GRAILS_VERSION MANDATORY "The Grails version" "${TAG}";
defineEnvVar SERVICE_USER MANDATORY "The user account" "${NAMESPACE}";
defineEnvVar SERVICE_GROUP MANDATORY "The group" "users";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
