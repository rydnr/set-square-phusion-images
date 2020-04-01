defineEnvVar PARENT_IMAGE_TAG MANDATORY "The parent image tag" "0.11";
overrideEnvVar TAG '20180906';
defineEnvVar SERVICE_USER MANDATORY "The Tensorflow user" "tensorflow";
defineEnvVar SERVICE_USER_PASSWORD MANDATORY "The Tensorflow user's password" "${RANDOM_PASSWORD}";
defineEnvVar SERVICE_GROUP MANDATORY "The Tensorflow group" "tensorflow";
defineEnvVar SERVICE_USER_HOME MANDATORY "The home of Tensorflow user" "/work/tensorflow";
defineEnvVar SERVICE_USER_SHELL MANDATORY "The shell of Tensorflow user" "/bin/bash";
defineEnvVar ENTRYPOINT MANDATORY "The entrypoint" "/bin/bash";
defineEnvVar IMAGE_USER MANDATORY "The image user" "${SERVICE_USER}";
cp .templates/tacotron-files/service.template tacotron/
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
