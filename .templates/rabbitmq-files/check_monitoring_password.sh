#!/usr/bin/env dry-wit
# (c) 2017-today Automated Computing Machinery, S.L.
#
#    This file is part of set-square.
#
#    set-square is free software: you can redistribute it and/or
#    modify it under the terms of the GNU General Public License as published
#    by the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    set-square is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with set-square.
#    If not, see <http://www.gnu.org/licenses/>.
#
# mod: set-square/rabbitmq/check_monitoring_password.sh
# api: public
# txt: Checks the container is launched with the MONITORING_USER_NAME and MONITORING_USER_PASSWORD set.

# fun: main
# api: public
# txt: Returns 0/TRUE always.
function main() {
  echo -n "";
}

# script metadata
setScriptDescription "Checks the container is launched with the MONITORING_USER_NAME and MONITORING_USER_PASSWORD set.";

# env: MONITORING_USER_NAME: The name of the monitoring user.
defineEnvVar MONITORING_USER_PASSWORD MANDATORY "The name the monitoring user" "monitoring";
# env: MONITORING_USER_PASSWORD: The password for the monitoring user.
defineEnvVar MONITORING_USER_PASSWORD MANDATORY "The password for the monitoring user";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
