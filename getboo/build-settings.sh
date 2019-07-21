defineEnvVar GETBOO_VERSION MANDATORY "The getboo version" "1.04";
defineEnvVar GETBOO_DB_TABLE_PREFIX MANDATORY "The prefix for getboo tables" "";
defineEnvVar GETBOO_DB_NAME MANDATORY "The getboo database name" "getboo";
defineEnvVar GETBOO_DB_USERNAME MANDATORY "The getboo database user" "getboo";
defineEnvVar GETBOO_DB_PASSWORD MANDATORY "The password for the getboo database user" "secret" "${RANDOM_PASSWORD}";
defineEnvVar GETBOO_ADMIN_USERNAME MANDATORY "The getboo admin user" "admin";
defineEnvVar GETBOO_ADMIN_PASSWORD MANDATORY "The getboo admin password" "secret" "${RANDOM_PASSWORD}";
defineEnvVar GETBOO_DEFAULT_LANGUAGE MANDATORY "The default language for getboo" "en_US";
defineEnvVar GETBOO_DOMAIN MANDATORY "The getboo domain" "http://getboo.example.com";
defineEnvVar GETBOO_HTTPS_DOMAIN MANDATORY "The https domain" 'https://getboo.example.com';
defineEnvVar GETBOO_ADMIN_EMAIL MANDATORY "The admin email for getboo" 'admin-getboo@${GETBOO_DOMAIN}';
defineEnvVar GETBOO_FOLDER MANDATORY "The GetBoo folder" 'getboo.${GETBOO_VERSION}';
defineEnvVar GETBOO_FILE MANDATORY "The GetBoo artifact" '${GETBOO_FOLDER}.zip';
defineEnvVar GETBOO_DOWNLOAD_URL MANDATORY "The url to download GetBoo" 'http://downloads.sourceforge.net/project/getboo/getboo/${GETBOO_VERSION}/${GETBOO_FILE}';
defineEnvVar GETBOO_HOME MANDATORY "The home folder for GetBoo" "/usr/local/src";
defineEnvVar APACHE_USER MANDATORY "The Apache user" "www-data";
defineEnvVar APACHE_GROUP MANDATORY "The Apache group" "www-data";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
