defineEnvVar PKG_UPDATE MANDATORY "The command to update the system" "apt-get update -y";
defineEnvVar PKG_INSTALL MANDATORY "The command to install a package" "apt-get install -y";
defineEnvVar INSTALLED_PACKAGES_FILE MANDATORY "The file to annotate the explicitly-installed packages" "/var/local/docker-installed-packages.txt";
defineEnvVar PIN_PACKAGE MANDATORY "The command to hold/pin a package so that it doesn't get removed" "apt-mark hold";
defineEnvVar APT_CACHE_FOLDER MANDATORY "The Ubuntu cache folder" "/var/lib/apt/lists";
#
