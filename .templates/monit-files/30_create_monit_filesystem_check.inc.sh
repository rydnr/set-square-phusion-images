# env: MONIT_CONF_FOLDER: Monit's configuration folder. Defaults to /etc/monit/monitrc.d.
defineEnvVar MONIT_CONF_FOLDER OPTIONAL "Monit's configuration folder" "/etc/monit/monitrc.d";
# env: MONIT_CONF_FILE: The Monit configuration file to make it check the root filesystem usage. Defaults to ${MONIT_CONF_FOLDER}/rootfs.
defineEnvVar MONIT_CONF_FILE OPTIONAL "The Monit configuration file to make it check the root filesystem usage" '${MONIT_CONF_FOLDER}/rootfs';
# env: DISK_SPACE_THRESHOLD: The threshold used to decide whether to send disk usage alerts. Defaults to 80%.
defineEnvVar DISK_SPACE_THRESHOLD OPTIONAL "The threshold used to decide whether to send disk usage alerts" "80%";
# env: DISK_SPACE_POSITIVES: The number of positives within the specified cycles to decide whether to send disk usage alerts. Defaults to 5.
defineEnvVar DISK_SPACE_POSITIVES OPTIONAL "The number of positives within the specified cycles to decide whether to send disk usage alerts" "5";
# env: DISK_SPACE_CYCLES: The number of cycles used to decide whether to send disk usage alerts. Defaults to 15.
defineEnvVar DISK_SPACE_CYCLES OPTIONAL "The number of cycles used to decide whether to send disk usage alerts" "15";
# env: INODE_USAGE_THRESHOLD: The threshold used to decide whether to send inode usage alerts. Defaults to 90%.
defineEnvVar INODE_USAGE_THRESHOLD OPTIONAL "The threshold used to decide whether to send inode usage alerts" "90%";
# env: INODE_USAGE_POSITIVES: The number of positives within the specified cycles to decide whether to send inode usage alerts. Defaults to 5.
defineEnvVar INODE_USAGE_POSITIVES OPTIONAL "The number of positives within the specified cycles to decide whether to send inode usage alerts" "5";
# env: INODE_USAGE_CYCLES: The number of cycles used to decide whether to send inode usage alerts. Defaults to 15.
defineEnvVar INODE_USAGE_CYCLES OPTIONAL "The number of cycles used to decide whether to send inode usage alerts" "15";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
