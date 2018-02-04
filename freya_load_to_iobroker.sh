#!/bin/bash

LOAD_1min=$(cat /proc/loadavg | cut -d " " -f1)
LOAD_5min=$(cat /proc/loadavg | cut -d " " -f2)
LOAD_15min=$(cat /proc/loadavg | cut -d " " -f3)

curl http://odin:8087/set/javascript.1.load_freya.1min?value=$LOAD_1min
curl http://odin:8087/set/javascript.1.load_freya.5min?value=$LOAD_5min
curl http://odin:8087/set/javascript.1.load_freya.15min?value=$LOAD_15min
