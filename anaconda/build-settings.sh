defineEnvVar PARENT_IMAGE_TAG MANDATORY "The parent image tag" "jammy-1.0.2";
defineEnvVar ANACONDA_PYTHON_VERSION MANDATORY "The Python version used in Anaconda" "3";
defineEnvVar ANACONDA_VERSION MANDATORY "The Anaconda version" '2023.09';
overrideEnvVar TAG '${ANACONDA_PYTHON_VERSION}-${ANACONDA_VERSION}';
defineEnvVar ANACONDA_ARTIFACT MANDATORY "The Anaconda artifact" 'Anaconda${TAG}-Linux-x86_64.sh';
defineEnvVar ANACONDA_DOWNLOAD_URL MANDATORY "The url to download the Anaconda artifact" 'https://repo.continuum.io/archive/${ANACONDA_ARTIFACT}';
defineEnvVar SERVICE_USER MANDATORY "The Anaconda user" "anaconda";
defineEnvVar SERVICE_USER_PASSWORD MANDATORY "The Anaconda user's password" "${RANDOM_PASSWORD}";
defineEnvVar SERVICE_GROUP MANDATORY "The Anaconda group" "anaconda";
defineEnvVar SERVICE_USER_HOME MANDATORY "The home of Anaconda user" "/work/anaconda";
defineEnvVar SERVICE_USER_SHELL MANDATORY "The shell of Anaconda user" "/bin/bash";
defineEnvVar ENTRYPOINT MANDATORY "The entrypoint" "/bin/bash";
defineEnvVar IMAGE_USER MANDATORY "The image user" "${SERVICE_USER}";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
