#!/bin/bash
echo "Starting Android"

cleanup ()
{
  echo "Exiting"
  vncserver -kill :1
  pkill -15 emulator
  exit $?
}

trap cleanup SIGTERM

vncserver
emulator @Nexus_5X_API_21 &

IP=`hostname -i`
socat tcp-listen:5554,bind=$IP,fork tcp:127.0.0.1:5554 &
socat tcp-listen:5555,bind=$IP,fork tcp:127.0.0.1:5555 &
adb logcat &
wait ${!}