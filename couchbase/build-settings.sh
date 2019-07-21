defineEnvVar PARENT_IMAGE_TAG MANDATORY "The tag of the parent image" "0.11";
defineEnvVar COUCHBASE_VERSION MANDATORY "The version of Couchbase" "4.1.1";
overrideEnvVar TAG '${COUCHBASE_VERSION}';
defineEnvVar SERVICE_USER MANDATORY "The service user" "couchbase";
defineEnvVar SERVICE_GROUP MANDATORY "The service group" "couchbase";
defineEnvVar SERVICE_USER_HOME MANDATORY "The home of the service user" '/backup/${IMAGE}';
defineEnvVar SERVICE_USER_SHELL MANDATORY "The shell of the service user" "/sbin/nologin";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
