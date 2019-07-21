defineEnvVar GHOST_VERSION MANDATORY "The version of Ghost" "0.7.1";
defineEnvVar GHOST_ARTIFACT MANDATORY "The Ghost artifact" 'ghost-${GHOST_VERSION}.zip';
defineEnvVar GHOST_URL MANDATORY "The url to download Ghost" 'https://ghost.org/zip/${GHOST_ARTIFACT}';
defineEnvVar GHOST_DOMAIN MANDATORY "The domain for the Ghost application" 'ghost.${NAMESPACE}.com';
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
