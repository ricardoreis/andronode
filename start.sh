#!/bin/sh

# command to get datadir on config.json
# cat config.json | grep datadir | grep -oP '"\K[^"\047]+(?=["\047])' | tail -n1

#STORAGE=$(find /storage -type d -name "com.termux" 2>/dev/null)
#BLOCKCHAIN=$STORAGE/files/blockchain

DATADIR=$(cat config.json | grep datadir | grep -oP '"\K[^"\047]+(?=["\047])' | tail -n1)
CONF=$(cat config.json | grep conf | grep -oP '"\K[^"\047]+(?=["\047])' | tail -n1)

BLUE='\033[94m'
GREEN='\033[32;1m'
YELLOW='\033[33;1m'
RED='\033[91;1m'
RESET='\033[0m'

print_info() {
    printf "$BLUE$1$RESET\n"
}

print_success() {
    printf "$GREEN$1$RESET\n"
    sleep 1
}

print_warning() {
    printf "$YELLOW$1$RESET\n"
}

print_error() {
    printf "$RED$1$RESET\n"
    sleep 1
}
check_storage(){
  if [ -d "$DATADIR" ]; then
    ### Take action if $DATADIR exists ###
    print_info "External Drive detected ${DATADIR}..."
    check_blockchain
  else
    ###  Control will jump here if $DATADIR does NOT exists ###
    print_error "Error: External Drive not found. Can not continue."
    exit 1
  fi
}


check_pid() {
  if [ -f $DATADIR/bitcoind.pid ]; then
    PID=$(cat $DATADIR/bitcoind.pid)
    if kill -0 $PID > /dev/null 2>&1
      then
      print_warning "$PID is running"
      # Do something knowing the pid exists, i.e. the process with $PID is runn>
      else
      print_info "$PID not running"
      rm $DATADIR/bitcoind.pid
    fi
  else
  check_storage
  fi
}


start_bitcoin_core() {
    check_pid
    if [ ! -f $DATADIR/bitcoind.pid ]; then
        #print_info "\n\nStarting Bitcoin Core..."
        bitcoind -conf=$CONF -datadir=$DATADIR -daemon

        timer=0
        until [ -f $DATADIR/bitcoind.pid ] || [ $timer -eq 5 ]; do
            timer=$((timer + 1))
            sleep $timer
        done

        if [ -f $DATADIR/bitcoind.pid ]; then
            print_warning "\n\nBlockchain files folder:"
            echo "  $DATADIR"
            print_warning "\nUse the command below to check the debug.log file."
            echo "  ~/andronode/debug.sh\n"
            print_success "\n\nOK! Bitcoin Core is running!"
        else
            print_error "Failed to start Bitcoin Core."
            exit 1
        fi
    else
        print_warning "\nBitcoin Core is probably already running."
        print_warning "\nUse the command below to check the debug.log file."
        echo " ~/andronode/debug.sh\n"
    fi
}

start_bitcoin_core