#!/bin/sh

ANDRONODE=$HOME/andronode
DATADIR=$(cat $ANDRONODE/config.json | grep datadir | grep -oP '"\K[^"\047]+(?=["\047])' | tail -n1)

tail -f $DATADIR/debug.log