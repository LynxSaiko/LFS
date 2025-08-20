#!/bin/bash
### BEGIN INIT INFO
# Provides:          tor
# Required-Start:    $local_fs $network $named $time $syslog
# Required-Stop:     $local_fs $network $named $time $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start the Tor network daemon
### END INIT INFO

TOR_BIN="/usr/bin/tor"
TORRC="/etc/tor/torrc"

start() {
    echo "Starting Tor..."
    $TOR_BIN -f $TORRC
}

stop() {
    echo "Stopping Tor..."
    kill $(cat /var/run/tor.pid)
}

status() {
    if [ -e "/var/run/tor.pid" ]; then
        echo "Tor is running"
    else
        echo "Tor is not running"
    fi
}

case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    status)
        status
        ;;
    restart)
        stop
        start
        ;;
    *)
        echo "Usage: $0 {start|stop|status|restart}"
        exit 1
        ;;
esac
