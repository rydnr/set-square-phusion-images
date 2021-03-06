#!/bin/env dry-wit
# Copyright 2015-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3
# mod: nexus/51_copy_nexus_data
# api: public
# txt: Copies Nexus data to the correct location.

# fun: main
# api: public
# txt: Copies Nexus data to the correct location.
# txt: Returns 0/TRUE always.
# use: main
function main() {
  rsync -avz /backup/nexus-conf/ /opt/sonatype/nexus/etc/ > /dev/null 2>&1
  rsync -avz /backup/nexus-conf/ /sonatype-work/etc/ > /dev/null 2>&1
  rsync -avz /opt/sonatype/nexus/etc/ /backup/nexus-conf/ > /dev/null 2>&1
  rm -rf /opt/sonatype/nexus/etc /sonatype-work/etc > /dev/null 2>&1
  ln -s /backup/nexus-conf /opt/sonatype/nexus/etc > /dev/null 2>&1
  ln -s /backup/nexus-conf /sonatype-work/etc > /dev/null 2>&1
  rm -rf /sonatype-work/blobs > /dev/null 2>&1
  ln -s /backup/nexus-blobs /sonatype-blobs > /dev/null 2>&1
  ln -s /backup/nexus-blobs /sonatype-work/blobs > /dev/null 2>&1
  ln -s /backup/nexus-db /sonatype-work/db > /dev/null 2>&1
  /etc/my_init.d/00_chown_volumes.sh
  chown -R ${SERVICE_USER}:${SERVICE_GROUP} /opt/sonatype /sonatype-work > /dev/null 2>&1
}

## Script metadata and CLI options

setScriptDescription "Copies Nexus data to the correct location.";

# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
