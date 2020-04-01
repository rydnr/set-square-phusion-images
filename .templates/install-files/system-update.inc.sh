defineEnvVar PKG_REMOVE MANDATORY "The command to remove a package" "apt-get remove --purge -y";
defineEnvVar SYSTEM_UPDATE MANDATORY "The command to update the system" "apt -y update";
defineEnvVar SYSTEM_UPGRADE MANDATORY "The command to upgrade the system" "apt -y upgrade";
defineEnvVar INSTALLED_PACKAGES_FILE MANDATORY "The file to annotate the explicitly-installed packages" "/var/local/docker-installed-packages.txt";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
