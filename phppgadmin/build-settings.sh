defineEnvVar PARENT_IMAGE_TAG MANDATORY "The tag of the parent image" "0.11";
defineEnvVar PHPPGADMIN_VIRTUAL_HOST MANDATORY "The virtual host of phpPgAdmin application" 'phppgadmin.${DOMAIN}';
#defineEnvVar PHPPGADMIN_VERSION MANDATORY "The PhpPgAdmin version" "5.1";
#defineEnvVar PHPPGADMIN_ARTIFACT MANDATORY "The PhpPgAdmin artifact" 'phpPgAdmin-${PHPPGADMIN_VERSION}.tar.bz2';
#defineEnvVar PHPPGADMIN_DOWNLOAD_URL MANDATORY "The url to download PhpPgAdmin" 'http://downloads.sourceforge.net/project/phppgadmin/phpPgAdmin%20%5Bstable%5D/phpPgAdmin-5.1/${PHPPGADMIN_DOWNLOAD_URL}?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fphppgadmin%2F&ts=1472486538&use_mirror=freefr';
defineEnvVar POSTGRESQL_VERSION MANDATORY "The PostgreSQL version (of the client package)" "9.5";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
