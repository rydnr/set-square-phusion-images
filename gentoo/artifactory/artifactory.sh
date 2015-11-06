#!/bin/bash
#
# Startup script for Artifactory in Tomcat Servlet Engine
#
# chkconfig: 345 86 14
# description: Artifactory Tomcat Servlet Engine
# processname: artifactory
# pidfile: /home/chous/artifactory-3.0.1/run/artifactory.pid
#
### BEGIN INIT INFO
# Provides:          artifactory
# Required-Start:    $remote_fs $syslog $network
# Required-Stop:     $remote_fs $syslog $network
# Default-Start:     3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start Artifactory on Tomcat
# Description:       Manages the services needed to run Artifactory on a dedicated Tomcat
### END INIT INFO
#

errorArtHome() {
    echo
    echo -e "\033[31m** ERROR: $1\033[0m"
    echo
    exit 1
}

checkArtHome() {
    if [ -z "$ARTIFACTORY_HOME" ] || [ ! -d "$ARTIFACTORY_HOME" ]; then
        errorArtHome "Artifactory home folder not defined or does not exists at $ARTIFACTORY_HOME"
    fi
}

checkArtPid() {
    if [ -z "$ARTIFACTORY_PID" ]; then
        errorArtHome "Artifactory pid destination ARTIFACTORY_PID was not set in $artDefaultFile ! Please add it!"
    fi
}

checkTomcatHome() {
    if [ -z "$TOMCAT_HOME" ] || [ ! -d "$TOMCAT_HOME" ]; then
        errorArtHome "Tomcat Artifactory folder not defined or does not exists at $TOMCAT_HOME"
    fi
}

checkArtUser() {
    # User under which tomcat will run
    if [ -z "$ARTIFACTORY_USER" ]; then
        # Will run as current user (may be root!!!)
        ARTIFACTORY_USER=$USER
    fi
}

findShutdownPort() {
    SHUTDOWN_PORT=`netstat -vatn|grep LISTEN|grep $CATALINA_MGNT_PORT|wc -l`
}

isAlive() {
    pidValue=""
    javaPs=""
    if [ -e "$ARTIFACTORY_PID" ]; then
        pidValue=`cat $ARTIFACTORY_PID`
        if [ -n "$pidValue" ]; then
            javaPs="`ps -p $pidValue | grep java`"
        fi
    fi
}

start() {
    # Start Tomcat in normal mode
    isAlive
    findShutdownPort
    if [ $SHUTDOWN_PORT -ne 0 ] || [ -n "$javaPs" ]; then
        echo "Artifactory Tomcat already started"
    else
        echo "Starting Artifactory tomcat as user $ARTIFACTORY_USER..."
        noFileVal=`ulimit -n`
        minNoFileMax=32000
        if [ "$noFileVal" != "unlimited" ] && [ $noFileVal -lt $minNoFileMax ]; then
            ulimit -n $minNoFileMax || echo "WARNING: Max number of open files $noFileVal is too small!
You should add:
artifactory soft nofile $minNoFileMax
artifactory hard nofile $minNoFileMax
to your /etc/security/limits.conf file."
        fi
        su -l $ARTIFACTORY_USER -c "$TOMCAT_HOME/bin/startup.sh"
        RETVAL=$?
        if [ $RETVAL -ne 0 ]; then
            errorArtHome "Artifactory Tomcat server did not start. Please check the logs"
        fi
        findShutdownPort
        nbSeconds=1
        while [ $SHUTDOWN_PORT -eq 0 ] && [ $nbSeconds -lt 45 ]; do
            sleep 1
            let "nbSeconds = $nbSeconds + 1"
            findShutdownPort
        done
        if [ $SHUTDOWN_PORT -eq 0 ]; then
            errorArtHome "Artifactory Tomcat server did not start in 45 seconds. Please check the logs"
        fi
        echo "Artifactory Tomcat started in normal mode"
        [ $RETVAL=0 ] && touch $CATALINA_LOCK_FILE
    fi
}

stop() {
    isAlive
    findShutdownPort
    if [ $SHUTDOWN_PORT -eq 0 ] && [ -z "$javaPs" ]; then
        echo "Artifactory Tomcat already stopped"
        RETVAL=0
    else
        echo "Stopping Artifactory Tomcat..."
        if [ $SHUTDOWN_PORT -ne 0 ]; then
            su -l $ARTIFACTORY_USER -c "$TOMCAT_HOME/bin/shutdown.sh"
            RETVAL=$?
        else
            RETVAL=1
        fi
        killed=false
        if [ $RETVAL -ne 0 ]; then
            echo "WARN: Artifactory Tomcat server shutdown script failed. Sending kill signal to $pidValue"
            if [ -n "$pidValue" ]; then
                killed=true
                kill $pidValue
                RETVAL=$?
            fi
        fi
        # Wait 2 seconds for process to die
        sleep 2
        findShutdownPort
        isAlive
        nbSeconds=1
        while [ $SHUTDOWN_PORT -ne 0 ] || [ -n "$javaPs" ] && [ $nbSeconds -lt 30 ]; do
            if [ $nbSeconds -eq 10 ] && [ -n "$pidValue" ]; then
                # After 10 seconds try to kill the process
                echo "WARN: Artifactory Tomcat server shutdown not done after 10 seconds. Sending kill signal"
                kill $pidValue
                RETVAL=$?
            fi
            if [ $nbSeconds -eq 25 ] && [ -n "$pidValue" ]; then
                # After 25 seconds try to kill -9 the process
                echo "WARN: Artifactory Tomcat server shutdown not done after 25 seconds. Sending kill -9 signal"
                kill -9 $pidValue
                RETVAL=$?
            fi
            sleep 1
            let "nbSeconds = $nbSeconds + 1"
            findShutdownPort
            isAlive
        done
        if [ $SHUTDOWN_PORT -eq 0 ] && [ -z "$javaPs" ]; then
           echo "Artifactory Tomcat stopped"
        else
           echo "ERROR: Artifactory Tomcat did not stop"
           RETVAL=1
        fi
    fi
    [ $RETVAL=0 ] && rm -f "$CATALINA_LOCK_FILE" "$ARTIFACTORY_PID"
}

status() {
    findShutdownPort
    if [ $SHUTDOWN_PORT -eq 0 ]; then
        if [ -e "$ARTIFACTORY_PID" ]; then
            echo "ERROR: Artifactory is stopped but the pid file $ARTIFACTORY_PID still exist"
            RETVAL=1
        else
            if [ -e "$CATALINA_LOCK_FILE" ]; then
                echo "ERROR: Artifactory is stopped but the lock file $CATALINA_LOCK_FILE still exist"
                RETVAL=2
            else
                echo "Artifactory Tomcat stopped"
                RETVAL=3
            fi
        fi
    else
        echo "Artifactory Tomcat running"
        RETVAL=0
    fi
}

check() {
    if [ -f $ARTIFACTORY_PID ]; then
        echo "Artifactory is running, on pid="`cat $ARTIFACTORY_PID`
        echo ""
        exit 0
    fi

    echo "Checking arguments to Artifactory: "
    echo "ARTIFACTORY_HOME     =  $ARTIFACTORY_HOME"
    echo "ARTIFACTORY_USER     =  $ARTIFACTORY_USER"
    echo "TOMCAT_HOME          =  $TOMCAT_HOME"
    echo "ARTIFACTORY_PID      =  $ARTIFACTORY_PID"
    echo "JAVA_HOME            =  $JAVA_HOME"
    echo "JAVA_OPTIONS         =  $JAVA_OPTIONS"
    echo

    exit 1
}

#
ARTIFACTORY_PID=""
artDefaultFile="/etc/conf.d/artifactory"

. $artDefaultFile || errorArtHome "ERROR: $artDefaultFile does not exist or not executable"

checkArtHome

checkArtPid

checkTomcatHome

# Basic variables used
CATALINA_MGNT_PORT=8015
CATALINA_PID_FOLDER="$(dirname "$ARTIFACTORY_PID")"
CATALINA_LOCK_FILE=$CATALINA_PID_FOLDER/lock
RETVAL=0

checkArtUser

case "$1" in
  start)
        start
        ;;
  stop)
        stop
        ;;
  restart)
        stop
        start
        ;;
  redebug)
        stop
        debug
        ;;
  status)
        status
        ;;
  check)
        check
        ;;
  *)
        echo "Usage: $0 {start|stop|restart|redebug|status|check}"
        exit 1
        ;;
esac

exit $RETVAL