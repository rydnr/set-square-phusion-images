#!/bin/bash dry-wit
# Copyright 2015-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3
# mod: locale/02_change_default_locale
# api: public
# txt: Changes the system's default locale.

DW.import locale;

# fun: main
# api: public
# txt: Changes the locale and encoding (available after re-login).
# txt: Returns 0/TRUE always.
# use: main
function main() {
  change_default_locale "${LOCALE}" "${ENCODING}";
}

## Script metadata and CLI settings.

setScriptDescription "Changes the locale and encoding (available after re-login)";
addCommandLineFlag "locale" "l" "The locale to use (en_US, es_ES, ...)" OPTIONAL EXPECTS_ARGUMENT "${DEFAULT_LOCALE}";
addCommandLineFlag "encoding" "e" "The encoding (UTF-8, ISO-8859-1, ...)" OPTIONAL EXPECTS_ARGUMENT "${DEFAULT_ENCODING}";

function dw_parse_locale_cli_flag() {
  export LOCALE="${1}";
}

function dw_parse_encoding_cli_flag() {
  export ENCODING="${1}";
}

addError "LOCALE_ENCODING_PAIR_IS_NOT_SUPPORTED" "The provided locale-encoding pair is not supported";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
