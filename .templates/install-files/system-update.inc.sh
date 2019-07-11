defineEnvVar PKG_REMOVE MANDATORY "The command to remove a package" "apt-get remove --purge -y";
defineEnvVar SYSTEM_UPDATE MANDATORY "The command to update the system" "apt-get update";
defineEnvVar INSTALLED_PACKAGES_FILE MANDATORY "The file to annotate the explicitly-installed packages" "/var/local/docker-installed-packages.txt";
#
#
