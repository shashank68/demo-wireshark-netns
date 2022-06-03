#!/bin/bash

shopt -s expand_aliases
alias netex="ip netns exec"

function set_veth_netns {
    ip link set $1 netns $2
    ip -n $2 link set $1 up
    ip -n $2 address add $3 dev $1
}

# client --- router --- server

# Create 3 nodes
ip netns add client
ip -n client link set lo up

ip netns add server
ip -n server link set lo up

ip netns add router
ip -n router link set lo up
netex router sysctl -w net.ipv4.ip_forward=1

# Create 2 links (pair of interfaces)
ip link add cl_ro type veth peer name ro_cl
ip link add se_ro type veth peer name ro_se

# Assign addresses and nodes to the interfaces
set_veth_netns ro_cl router 11.0.0.1/24
set_veth_netns cl_ro client 11.0.0.2/24

set_veth_netns ro_se router 12.0.0.1/24
set_veth_netns se_ro server 12.0.0.2/24

# Add routes 
ip -n client route add default dev cl_ro via 11.0.0.1
ip -n server route add default dev se_ro via 12.0.0.1

netex client wireshark -i cl_ro -k & &> /dev/null
netex server wireshark -i se_ro -k & &> /dev/null