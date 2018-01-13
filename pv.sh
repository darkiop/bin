#!/bin/bash
#
# liest Werte aus Kostal Wechselrichter und pusht diese an eine CCU
#
# Quelle: http://homematic-forum.de/forum/viewtopic.php?p=131956#p131956

PARAMETER_WGET="-q -O - --timeout=10"
TEMP_PV="/tmp/pv"
IP_PV="192.168.1.70"
IP_CCU2="192.168.1.74"
PV_USER="pvserver"
PV_PASS="pvwr"
URL="http://$IP_CCU2/addons/db/state.cgi?item"

wget $PARAMETER_WGET --http-user=$PV_USER --http-password=$PV_PASS "http://$IP_PV/index.fhtml" | sed -e "s/nbsp/nbsp;/g" | sed -e "s/nbsp;;/nbsp;/g" | sed -e "s/\&nbsp;//g" | html2text | tr -s " \t\r\n" | sed -e "s/^ //" | sed -e "s/x x x/0/g" > $TEMP_PV

PHOTOVOLTAICS_DC1U=$(grep Spannung $TEMP_PV | head -1 | cut -f2 -d" ")
PHOTOVOLTAICS_DC2U=$(grep Spannung $TEMP_PV | head -2 | tail -1 | cut -f2 -d" ")
PHOTOVOLTAICS_DC1I=$(grep Strom $TEMP_PV | head -1 | cut -f2 -d" " | awk '{printf "%d\n",$1*1000}')
PHOTOVOLTAICS_DC2I=$(grep Strom $TEMP_PV | head -2 | tail -1 | cut -f2 -d" " | awk '{printf "%d\n",$1*1000}')
PHOTOVOLTAICS_DC1P=$(( $PHOTOVOLTAICS_DC1U * $PHOTOVOLTAICS_DC1I / 1000 ))
PHOTOVOLTAICS_DC2P=$(( $PHOTOVOLTAICS_DC2U * $PHOTOVOLTAICS_DC2I / 1000 ))
PHOTOVOLTAICS_ACCURP=$(grep aktuell $TEMP_PV | cut -f2 -d" ")
PHOTOVOLTAICS_ACTOTP=$(grep Gesamtenergie $TEMP_PV | cut -f5 -d" ")
PHOTOVOLTAICS_DAILYP=$(grep Tagesenergie $TEMP_PV | cut -f2 -d" ")
PHOTOVOLTAICS_STATUS=$(grep Status $TEMP_PV | head -2 | tail -1 | cut -f2 -d " ")

wget $PARAMETER_WGET "$URL=PV.DC1&value=$PHOTOVOLTAICS_DC1P"
wget $PARAMETER_WGET "$URL=PV.DC2&value=$PHOTOVOLTAICS_DC2P"
wget $PARAMETER_WGET "$URL=PV.AC&value=$PHOTOVOLTAICS_ACCURP"
wget $PARAMETER_WGET "$URL=PV.DAILYP&value=$PHOTOVOLTAICS_DAILYP"
wget $PARAMETER_WGET "$URL=PV.TOTAL&value=$PHOTOVOLTAICS_ACTOTP"
wget $PARAMETER_WGET "$URL=PV.STATE&value=$PHOTOVOLTAICS_STATUS"

# EOF