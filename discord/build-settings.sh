defineEnvVar PARENT_IMAGE_TAG "The parent image tag" "201704";
defineEnvVar DISCORD_VERSION "The discord version" "0.0.1";
overrideEnvVar TAG '${DISCORD_VERSION}';
defineEnvVar DISCORD_ARTIFACT "The discord file" 'discord-${DISCORD_VERSION}.deb';
defineEnvVar DOWNLOAD_URL "The download url" 'https://cdn.discordapp.com/apps/linux/${DISCORD_VERSION}/${DISCORD_ARTIFACT}';
