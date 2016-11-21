defineEnvVar SLACK_VERSION "The Slack client version" '2.0.6';
defineEnvVar SLACK_ARTIFACT "The Slack artifact" 'slack-desktop-${SLACK_VERSION}-amd64.deb';
defineEnvVar SLACK_DOWNLOAD_URL "The download URL for slack" 'https://downloads.slack-edge.com/linux_releases/${SLACK_ARTIFACT}';
