defineEnvVar DEFAULTLOCALE_FILE MANDATORY "The /etc/default/locale file" "/etc/default/locale";
defineEnvVar BASHLOCALE_FILE MANDATORY "The /etc/bash.locale file" "/etc/bash.locale";
defineEnvVar SUPPORTED_LOCALES_FOLDER MANDATORY "The /var/lib/locales/supported.d folder" "/var/lib/locales/supported.d";
defineEnvVar SUPPORTED_LOCALES_FILE MANDATORY "The /usr/share/i18n/SUPPORTED file" "/usr/share/i18n/SUPPORTED";
defineEnvVar AVAILABLE_LOCALES_FOLDER MANDATORY "The /usr/share/i18n/locales/ folder" "/usr/share/i18n/locales";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
