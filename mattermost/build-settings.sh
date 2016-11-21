defineEnvVar MATTERMOST_VERSION "The Mattermost version" "2.1.0";
defineEnvVar MATTERMOST_ARTIFACT "The Mattermost artifact" 'mattermost-team-${MATTERMOST_VERSION}-linux-amd64.tar.gz';
defineEnvVar MATTERMOST_DOWNLOAD_URL "The url to download Mattermost" 'https://releases.mattermost.com/${MATTERMOST_VERSION}/${MATTERMOST_ARTIFACT}';
defineEnvVar MATTERMOST_DEFAULT_VIRTUAL_HOST "The default Mattermost virtual host" 'chat.${DOMAIN}';
defineEnvVar MATTERMOST_HTTP_UI_PORT "The port for Mattermost HTTP UI" "80";
