# env: DEFAULTLOCALE_FILE: The /etc/default/locale file. Defaults to /etc/default/locale.
defineEnvVar DEFAULTLOCALE_FILE MANDATORY "The /etc/default/locale file" "/etc/default/locale";
# env: BASHLOCALE_FILE: The /etc/bash.locale file. Defaults to /etc/bash.locale.
defineEnvVar BASHLOCALE_FILE MANDATORY "The /etc/bash.locale file" "/etc/bash.locale";
# env: SUPPORTED_LOCALES_FOLDER: The /var/lib/locales/supported.d folder. Defaults to /var/lib/locales/supported.d.
defineEnvVar SUPPORTED_LOCALES_FOLDER MANDATORY "The /var/lib/locales/supported.d folder" "/var/lib/locales/supported.d";
# env: SUPPORTED_LOCALES_FILE: The /usr/share/i18n/SUPPORTED file. Defaults to /usr/share/i18n/SUPPORTED.
defineEnvVar SUPPORTED_LOCALES_FILE MANDATORY "The /usr/share/i18n/SUPPORTED file" "/usr/share/i18n/SUPPORTED";
# env: AVAILABLE_LOCALES_FOLDER: The /usr/share/i18n/locales/ folder. Defaults to /usr/share/i18n/locales.
defineEnvVar AVAILABLE_LOCALES_FOLDER MANDATORY "The /usr/share/i18n/locales/ folder" "/usr/share/i18n/locales";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
