defineEnvVar SLACK_VERSION MANDATORY "The Slack client version" '2.0.6';
defineEnvVar SLACK_ARTIFACT MANDATORY "The Slack artifact" 'slack-desktop-${SLACK_VERSION}-amd64.deb';
defineEnvVar SLACK_DOWNLOAD_URL MANDATORY "The download URL for slack" 'https://downloads.slack-edge.com/linux_releases/${SLACK_ARTIFACT}';
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
