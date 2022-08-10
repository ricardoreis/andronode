#!/bin/sh

# command to get datadir on config.json
# cat config.json | grep datadir | grep -oP '"\K[^"\047]+(?=["\047])' | tail -n1

STORAGE=$(find /storage -type d -name "com.termux" 2>/dev/null)
BLOCKCHAIN=$STORAGE/files/blockchain
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
  if [ -d "$STORAGE" ]; then
    ### Take action if $STORAGE exists ###
    print_info "External Drive detected ${STORAGE}..."
    check_blockchain
  else
    ###  Control will jump here if $STORAGE does NOT exists ###
    print_error "Error: External Drive not found. Can not continue."
    exit 1
  fi
}

check_blockchain(){
  if [ -d "$BLOCKCHAIN" ]; then
    print_info "blockchain folder detected ${BLOCKCHAIN}"
  else
    print_error "Error: blockchain folder on Extenal Drive not found. Create folder to continue."
    mkdir $STORAGE/files/blockchain
    print_success "blockchain folder created."
    check_blockchain
  fi

}

check_pid() {
  if [ -f $BLOCKCHAIN/bitcoind.pid ]; then
    PID=$(cat $BLOCKCHAIN/bitcoind.pid)
    if kill -0 $PID > /dev/null 2>&1
      then
      print_warning "$PID is running"
      # Do something knowing the pid exists, i.e. the process with $PID is runn>
      else
      print_info "$PID not running"
      rm $BLOCKCHAIN/bitcoind.pid
    fi
  else
  check_storage
  fi
}


start_bitcoin_core() {
    check_pid
    if [ ! -f $BLOCKCHAIN/bitcoind.pid ]; then
        #print_info "\n\nStarting Bitcoin Core..."
        bitcoind -conf=$BLOCKCHAIN/bitcoin.conf -datadir=$BLOCKCHAIN -daemon

        timer=0
        until [ -f $BLOCKCHAIN/bitcoind.pid ] || [ $timer -eq 5 ]; do
            timer=$((timer + 1))
            sleep $timer
        done

        if [ -f $BLOCKCHAIN/bitcoind.pid ]; then
            print_warning "\n\nBlockchain files folder:"
            echo "  $BLOCKCHAIN"
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