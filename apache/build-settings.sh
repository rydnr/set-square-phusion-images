defineEnvVar PARENT_IMAGE_TAG MANDATORY MANDATORY "The tag of the parent image" "0.11";
defineEnvVar UBUNTU_VERSION MANDATORY MANDATORY "The version available in Ubuntu" "$(docker run --rm -it ${REGISTRY}/${NAMESPACE}/base:${PARENT_IMAGE_TAG} remote-ubuntu-version apache2 | sed 's/[^0-9a-zA-Z\._-]//g')";
overrideEnvVar TAG '${UBUNTU_VERSION}';
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
