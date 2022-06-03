#!/bin/bash


echo "IPv4 Routing table:"
echo ""
ip -n client route
echo ""
echo "################"

echo ""
echo "ARP Table entry Before:"
echo ""
ip -n client neigh
echo ""
echo "################"

echo "Starting ping"
echo ""

ip netns e client ping 12.0.0.2 -c 1

echo ""
echo "ARP Table entry:After:"
echo ""
ip -n client neigh
echo ""
echo "################"