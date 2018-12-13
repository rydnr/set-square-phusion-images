defineEnvVar PKG_REMOVE MANDATORY "The command to remove a package" "apt-get remove --purge -y";
defineEnvVar SYSTEM_CLEAN MANDATORY "The command to clean up the system" "apt-get clean";
defineEnvVar PKG_AUTOREMOVE MANDATORY "The command to automatically remove unused packages"  "apt-get autoremove -y";
defineEnvVar INSTALLED_PACKAGES_FILE MANDATORY "The file to annotate the explicitly-installed packages" "/var/local/docker-installed-packages.txt";
#
