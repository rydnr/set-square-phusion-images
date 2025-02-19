# env: LOCALEGEN: The /etc/locale.gen file. Defaults to /etc/locale.gen.
defineEnvVar LOCALEGEN MANDATORY "The /etc/locale.gen file" "/etc/locale.gen"
# env: SUPPORTED_LOCALES_FOLDER: The /var/lib/locales/supported.d folder. Defaults to /var/lib/locales/supported.d.
defineEnvVar SUPPORTED_LOCALES_FOLDER MANDATORY "The /var/lib/locales/supported.d folder" "/var/lib/locales/supported.d"
# env: SUPPORTED_LOCALES_FILE: The /usr/share/i18n/SUPPORTED file. Defaults to /usr/share/i18n/SUPPORTED.
defineEnvVar SUPPORTED_LOCALES_FILE MANDATORY "The /usr/share/i18n/SUPPORTED file" "/usr/share/i18n/SUPPORTED"
# env: AVAILABLE_LOCALES_FOLDER: The /usr/share/i18n/locales/ folder. Defaults to /usr/share/i18n/locales.
defineEnvVar AVAILABLE_LOCALES_FOLDER MANDATORY "The /usr/share/i18n/locales/ folder" "/usr/share/i18n/locales"
# env: LOCALENOPURGE: The /etc/locale.nopurge file. Defaults to /etc/locale.nopurge.
defineEnvVar LOCALENOPURGE MANDATORY "The /etc/locale.nopurge file" "/etc/locale.nopurge"
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
