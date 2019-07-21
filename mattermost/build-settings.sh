defineEnvVar MATTERMOST_VERSION MANDATORY "The Mattermost version" "2.1.0";
defineEnvVar MATTERMOST_ARTIFACT MANDATORY "The Mattermost artifact" 'mattermost-team-${MATTERMOST_VERSION}-linux-amd64.tar.gz';
defineEnvVar MATTERMOST_DOWNLOAD_URL MANDATORY "The url to download Mattermost" 'https://releases.mattermost.com/${MATTERMOST_VERSION}/${MATTERMOST_ARTIFACT}';
defineEnvVar MATTERMOST_DEFAULT_VIRTUAL_HOST MANDATORY "The default Mattermost virtual host" 'chat.${DOMAIN}';
defineEnvVar MATTERMOST_HTTP_UI_PORT MANDATORY "The port for Mattermost HTTP UI" "80";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
