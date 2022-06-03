#!/bin/bash

killall wireshark &> /dev/null

ip netns del client
ip netns del router
ip netns del server