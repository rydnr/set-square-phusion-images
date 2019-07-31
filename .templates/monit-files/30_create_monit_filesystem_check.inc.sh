defineEnvVar MONIT_CONF_FOLDER MANDATORY \
             "Monit's configuration folder" \
             "/etc/monit/monitrc.d";
defineEnvVar MONIT_CONF_FILE MANDATORY \
             "The Monit configuration file to make it check the root filesystem usage" \
             '${MONIT_CONF_FOLDER}/rootfs';
defineEnvVar DISK_SPACE_THRESHOLD MANDATORY \
             "The threshold used to decide whether to send disk usage alerts" \
             "80%";
defineEnvVar DISK_SPACE_POSITIVES MANDATORY \
             "The number of positives within the specified cycles to decide whether to send disk usage alerts" \
             "5";
defineEnvVar DISK_SPACE_CYCLES MANDATORY \
             "The number of cycles used to decide whether to send disk usage alerts" \
             "15";
defineEnvVar INODE_USAGE_THRESHOLD MANDATORY \
             "The threshold used to decide whether to send inode usage alerts" \
             "90%";
defineEnvVar INODE_USAGE_POSITIVES MANDATORY \
             "The number of positives within the specified cycles to decide whether to send inode usage alerts" \
             "5";
defineEnvVar INODE_USAGE_CYCLES MANDATORY \
             "The number of cycles used to decide whether to send inode usage alerts" \
             "15";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
