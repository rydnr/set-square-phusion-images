defineEnvVar PARENT_IMAGE_TAG MANDATORY "The parent image tag" "0.11";
defineEnvVar DISCORD_VERSION MANDATORY "The discord version" "0.0.1";
overrideEnvVar TAG '${DISCORD_VERSION}';
defineEnvVar DISCORD_ARTIFACT MANDATORY "The discord file" 'discord-${DISCORD_VERSION}.deb';
defineEnvVar DOWNLOAD_URL MANDATORY "The download url" 'https://cdn.discordapp.com/apps/linux/${DISCORD_VERSION}/${DISCORD_ARTIFACT}';
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
