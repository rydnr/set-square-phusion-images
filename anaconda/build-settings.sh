defineEnvVar PARENT_IMAGE_TAG MANDATORY "The parent image tag" "0.11";
defineEnvVar ANACONDA_PYTHON_VERSION MANDATORY "The Python version used in Anaconda" "3";
defineEnvVar ANACONDA_VERSION MANDATORY "The Anaconda version" '5.3.1';
overrideEnvVar TAG '${ANACONDA_PYTHON_VERSION}-${ANACONDA_VERSION}';
defineEnvVar ANACONDA_ARTIFACT MANDATORY "The Anaconda artifact" 'Anaconda${TAG}-Linux-x86_64.sh';
defineEnvVar ANACONDA_DOWNLOAD_URL MANDATORY "The url to download the Anaconda artifact" 'https://repo.continuum.io/archive/${ANACONDA_ARTIFACT}';
defineEnvVar SERVICE_USER MANDATORY "The Anaconda user" "anaconda";
defineEnvVar SERVICE_GROUP MANDATORY "The Anaconda group" "anaconda";
defineEnvVar SERVICE_USER_HOME MANDATORY "The home of Anaconda user" "/work/anaconda";
defineEnvVar SERVICE_USER_SHELL MANDATORY "The shell of Anaconda user" "/bin/bash";
#
