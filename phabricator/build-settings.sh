defineEnvVar PARENT_IMAGE_TAG MANDATORY "The version of the parent image" "0.11";
defineEnvVar GITHUB_PHABRICATOR_HASH MANDATORY "The hash of Phabricator's stable branch in github" "$(.templates/check-version-files/remote-git-version.sh -r https://github.com/phacility/phabricator.git stable)";
defineEnvVar GITHUB_ARCANIST_HASH MANDATORY "The hash of Arcanist's stable branch in github" "$(.templates/check-version-files/remote-git-version.sh -r https://github.com/phacility/arcanist.git stable)";
defineEnvVar GITHUB_LIBPHUTIL_HASH MANDATORY "The hash of Libphutil's stable branch in github" "$(.templates/check-version-files/remote-git-version.sh -r https://github.com/phacility/libphutil.git stable)";
overrideEnvVar TAG '${GITHUB_PHABRICATOR_HASH}';
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
