#!/bin/bash

IP='192.168.1.1'

fping -c1 -t300 $IP 2>/dev/null 1>/dev/null

if [ "$?" = 0 ]
then
  echo "Host found"
else
  echo "Host not found"
fi