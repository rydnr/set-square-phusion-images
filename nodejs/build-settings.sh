defineEnvVar NODEJS_MAJOR_VERSION "The major version of NodeJS" "6";
defineEnvVar NODEJS_DOWNLOAD_URL "The url to download NodeJS artifact" 'https://deb.nodesource.com/setup_${NODEJS_MAJOR_VERSION}.x';
defineEnvVar NODEJS_MODULES "The NodeJS modules to install" "inherits uncss json5 eslint gh-pages mountebank";
defineEnvVar SERVICE_USER "The name of the user" '${NAMESPACE}';
defineEnvVar SERVICE_GROUP "The name of the group" "users";
