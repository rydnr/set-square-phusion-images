defineEnvVar PARENT_IMAGE_TAG MANDATORY "The tag of the parent image" "latest"
defineEnvVar MONGODB_MAJOR_VERSION MANDATORY "The MongoDB version" "6.0"
defineEnvVar MONGODB_VERSION MANDATORY "The MongoDB version" '${MONGODB_MAJOR_VERSION}.0'
overrideEnvVar TAG '${MONGODB_VERSION}'
defineEnvVar REPLICA_SET_NAME MANDATORY "The name of the replica set" '${NAMESPACE}'
defineEnvVar SERVICE_USER MANDATORY "The service user" "mongodb"
defineEnvVar SERVICE_USER_PASSWORD MANDATORY "The password of the service user" "${RANDOM_PASSWORD}"
defineEnvVar SERVICE_GROUP MANDATORY "The service group" "mongodb"
defineEnvVar SERVICE_USER_HOME MANDATORY "The home of the service user" '/backup/${IMAGE}'
defineEnvVar SERVICE_USER_SHELL MANDATORY "The shell of the service user" "/bin/bash"
#
