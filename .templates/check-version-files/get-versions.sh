#!/bin/bash dry-wit
# Copyright 2016-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3
# mod: check-version/get-versions
# api: public
# txt: Retrieves the available versions of a package.

# fun: main
# api: public
# txt: Retrieves the available versions of a package.
function main() {
  cat <(apt-cache --recurse --no-pre-depends --no-recommends --no-suggests --no-enhances --no-conflicts --no-breaks --no-replaces depends $PKG) <(echo $PKG) | grep "^[a-z]" | xargs apt-cache show | grep ^Package | sed 's/^Package: \(.*\)/dpkg -l \1 | grep ^ii | awk "{print \\$2,\\$3}"/g' | sh 2>/dev/null | sed 's/\(.*\) \(.*\)/\1=\2/' | tr '\n' ' '
}

## Script metadata and CLI options
setScriptDescription "Retrieves the available versions of a package.";

addCommandLineParameter "package" "The software package" MANDATORY SINGLE;

checkReq apt-get;
checkReq apt-cache;
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
