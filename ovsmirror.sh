#!/bin/bash

# Copyright 2016 Vyacheslav Struk,
# sla237 at gmail.com
#
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0

IF_SNOOP=$2
PORT_MIRROR=$3
BR_MIRROR=$4

function print_help {
  echo "
This script intended help those who wants to dump traffic from an Open vSwitch port.
You can't dump traffic directly from the OVS port, so the script just mirrors all the traffic from an OVS port to the dummy linux interface.

Usage: ./ovsmirror (create|delete) <ifsnoop> <port> <bridge>

    <ifsnoop> - Dummy interface to create. Most likely thing you're going to do next is 'tcpdump -i <ifsnoop>'
    <port>    - OVS port to mirror from
    <bridge>  - OVS bridge with the <port>
"
  exit 1
}

if [ $# -ne 4 ]; then
  print_help
fi

case "$1" in
  create)

    ip link add name $IF_SNOOP type dummy
    ip link set dev $IF_SNOOP up
    ovs-vsctl add-port $BR_MIRROR $IF_SNOOP

    ovs-vsctl -- set Bridge $BR_MIRROR mirrors=@m \
     -- --id=@$PORT_MIRROR get port $PORT_MIRROR \
     -- --id=@$IF_SNOOP get port $IF_SNOOP \
     -- --id=@m create Mirror name=mirror_$PORT_MIRROR select-dst-port=@$PORT_MIRROR select-src-port=@$PORT_MIRROR output-port=@$IF_SNOOP

  ;;

  delete)

    ovs-vsctl clear bridge $BR_MIRROR mirrors
    ovs-vsctl del-port $BR_MIRROR $IF_SNOOP
    ip link delete dev $IF_SNOOP

  ;;

  *)
    print_help

  ;;

esac
