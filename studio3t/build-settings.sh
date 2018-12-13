defineEnvVar PARENT_IMAGE_TAG MANDATORY "The tag of the parent image" "0.11";
defineEnvVar STUDIO3T_VERSION MANDATORY "The Studio3T version" '2018.3.1';
defineEnvVar TAG MANDATORY "The image tag" '${STUDIO3T_VERSION}';
defineEnvVar SERVICE_USER MANDATORY "The service user" 'studio3t';
defineEnvVar SERVICE_GROUP MANDATORY "The service group" 'studio3t';
defineEnvVar SERVICE_USER_SHELL MANDATORY "The shell of the service user" '/bin/bash';
defineEnvVar SERVICE_USER_HOME MANDATORY "The home of the service user" '/home/studio3t';
