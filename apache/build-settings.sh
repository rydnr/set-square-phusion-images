defineEnvVar PARENT_IMAGE_TAG "The version of the parent image" '201610';
defineEnvVar UBUNTU_VERSION "The version available in Ubuntu" "$(docker run --rm -it ${REGISTRY}/${NAMESPACE}/base:${PARENT_IMAGE_TAG} remote-ubuntu-version apache2 | sed 's/[^0-9a-zA-Z\._-]//g')";
overrideEnvVar TAG '${UBUNTU_VERSION}';
