#!/bin/sh
ANDRONODE=$HOME/andronode
DATADIR=$(cat $ANDRONODE/config.json | grep datadir | grep -oP '"\K[^"\047]+(?=["\047])' | tail -n1)
CONF=$(cat $ANDRONODE/config.json | grep conf | grep -oP '"\K[^"\047]+(?=["\047])' | tail -n1)

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

stop_bitcoin_core() {
    if [ -f $DATADIR/bitcoind.pid ]; then
        print_info "\nStopping Bitcoin Core.."
        kill $(cat $DATADIR/bitcoind.pid)

        timer=0
        until [ ! -f $DATADIR/bitcoind.pid ] || [ $timer -eq 120 ]; do
            timer=$((timer + 1))
            echo $timer
            sleep $timer
        done

        if [ ! -f $DATADIR/bitcoind.pid ]; then
            print_success "Bitcoin Core stopped."
        else
            print_error "Failed to stop Bitcoin Core."
            print_warning "\nUse the command below to check the debug.log file.\n"
                echo "     ~/andronode/debugbtc.sh\n"
            exit 1
        fi
    else
        print_warning "Failed to stop Bitcoin Core."
        print_warning "\nUse the command below to check the debug.log file.\n"
        echo "     ~/andronode/debugbtc.sh\n"
    fi
}

stop_bitcoin_core