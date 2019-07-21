defineEnvVar BLOCKCYPHER_DB_PASSWORD MANDATORY "The password to connect to PostgreSQL" '${RANDOM_PASSWORD}';
defineEnvVar BLOCKCYPHER_DB_URL MANDATORY "The PostgreSQL URL" 'postgres://postgres:${BLOCKCYPHER_DB_PASSWORD}@localhost:5432/explorer_local';
defineEnvVar BLOCKCYPHER_SECRET_KEY MANDATORY "The secret key" "$(head -c50 /dev/random | uuencode -m - | sed -n '2s/=*$//;2p')";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
