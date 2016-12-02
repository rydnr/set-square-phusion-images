defineEnvVar PARENT_IMAGE_TAG "The tag of the parent image" "201612";
defineEnvVar COUCHBASE_VERSION "The version of Couchbase" "4.1.1";
overrideEnvVar TAG '${COUCHBASE_VERSION}';
defineEnvVar SERVICE_USER "The service user" "couchbase";
defineEnvVar SERVICE_GROUP "The service group" "couchbase";
defineEnvVar SERVICE_USER_HOME "The home of the service user" '/backup/${IMAGE}';
defineEnvVar SERVICE_USER_SHELL "The shell of the service user" "/sbin/nologin";
