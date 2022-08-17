#!/bin/bash

STORAGE=$(find /storage -type d -name "com.termux" 2>/dev/null)

ANDRONODE=$HOME/andronode
DATADIR=$(cat $ANDRONODE/config.json | grep datadir | grep -oP '"\K[^"\047]+(?=["\047])' | tail -n1)


check_storage(){
  if [ -d "$STORAGE" ]; then
    ### Take action if $STORAGE exists ###
    EXTERNALDRIVE="detected"
  else
    ###  Control will jump here if $STORAGE does NOT exists ###
    EXTERNALDRIVE="error"
  fi
}

check_size(){
  if [ -d "$DATADIR" ]; then
    SIZE=$(du -smh $DATADIR | awk '{print $1}')
  else
    SIZE="error"
  fi
}

check_pid() {
PID=0
  if [ -f $DATADIR/bitcoind.pid ]; then
    PID=$(cat $DATADIR/bitcoind.pid)
    if kill -0 $PID > /dev/null 2>&1
      then
      PID="$PID"
      PIDSTOP=$(ps -o pid,args -C bash | awk '/stop.sh/ { print $1 }')
      PIDSTART=$(ps -o pid,args -C bash | awk '/start.sh/ { print $1 }')
      # Do something knowing the pid exists, i.e. the process with $PID is runn>
      else
      PID=0
    fi
  fi
}

check_debug(){
  if [ -f $DATADIR/debug.log ]; then
    HEIGHT=$(grep -oP '(?<=height=)[0-9]+' $DATADIR/debug.log | tail -1)
    PROGRESS=$(grep -oP '(?<=progress=)[0-9.0-9]+' $DATADIR/debug.log | tail -1)
    tail -5 $DATADIR/debug.log > debug.txt
  else
    HEIGHT=0
    PROGRESS=0
fi
}



check_status(){
# starting
#   PID and !Progress
if [ "$PIDSTART" != "" ]; then
  STATUS="starting"

# stoping
#   PID and stop.sh PID
elif [ "$PIDSTOP" != "" ]; then
  STATUS="stopping"

# running
#   PID and Progress
elif [ "$PID" != "0"  ]; then
  STATUS="running"

# stoped
#   !PID
else
  STATUS="stoped"
fi
}

check_storage
check_pid
check_debug
check_size
check_status



echo "{\
\"height\":$HEIGHT,\
\"progress\":$PROGRESS,\
\"external\":\"$EXTERNALDRIVE\",\
\"pid\":$PID,\
\"pidstart\":\"$PIDSTART\",\
\"pidstop\":\"$PIDSTOP\",\
\"status\":$STATUS,\
\"size\":\"$SIZE\"\
}"