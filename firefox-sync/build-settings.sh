defineEnvVar FIREFOX_SYNC_DOMAIN MANDATORY "The Firefox-Sync domain" "firefox-sync.example.com";
defineEnvVar FIREFOX_SYNC_SECRET MANDATORY "The secret string for the Firefox Sync server" "secret" "${RANDOM_PASSWORD}";
defineEnvVar FIREFOX_SYNC_DB_NAME MANDATORY "The Firefox-Sync database name" "firefoxsync";
defineEnvVar FIREFOX_SYNC_DB_USER MANDATORY "The username to connect to the Firefox Sync database" "firefoxsync";
defineEnvVar FIREFOX_SYNC_DB_PASSWORD MANDATORY "The password of the Firefox Sync database user" "secret" "${RANDOM_PASSWORD}";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
