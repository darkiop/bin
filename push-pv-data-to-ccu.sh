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

# DC1
PV_STRING_1_SPANNUNG=$(grep Spannung $TEMP_PV | head -1 | cut -f2 -d" ")
PV_STRING_1_STROM=$(grep Strom $TEMP_PV | head -1 | cut -f2 -d" " | awk '{printf "%d\n",$1*1000}')
PV_STRING_1_LEISTUNG_in_W=$(( $PV_STRING_1_SPANNUNG * $PV_STRING_1_STROM / 1000 ))

# DC2
PV_STRING_2_SPANNUNG=$(grep Spannung $TEMP_PV | head -2 | tail -1 | cut -f2 -d" ")
PV_STRING_2_STROM=$(grep Strom $TEMP_PV | head -2 | tail -1 | cut -f2 -d" " | awk '{printf "%d\n",$1*1000}')
PV_STRING_2_LEISTUNG_in_W=$(( $PV_STRING_2_SPANNUNG * $PV_STRING_2_STROM / 1000 ))

PV_AKTUELL=$(grep aktuell $TEMP_PV | cut -f2 -d" ")
PV_GESAMT=$(grep Gesamtenergie $TEMP_PV | cut -f5 -d" ")
PV_TAG=$(grep Tagesenergie $TEMP_PV | cut -f2 -d" ")
PV_STATUS=$(grep Status $TEMP_PV | head -2 | tail -1 | cut -f2 -d " ")

# WIRKUNGSGRAD
#PV_WIRKG = ($PV_AKTUELL / ($PV_STRING_1_LEISTUNG_in_W + $PV_STRING_2_LEISTUNG_in_W)) * 100;

# DEBUG
#echo "String 1 V" $PV_STRING_1_SPANNUNG
#echo "String 1 A" $PV_STRING_1_STROM
#echo "String 1 Leistung in W" $PV_STRING_1_LEISTUNG_in_W
#echo "String 2 V" $PV_STRING_2_SPANNUNG
#echo "String 2 A" $PV_STRING_2_STROM
#echo "String 2 Leistung in W" $PV_STRING_2_LEISTUNG_in_W
#echo "AKTUELL" $PV_AKTUELL
#echo "GESAMT"  $PV_GESAMT
#echo "TAG:"    $PV_TAG
#echo "STATUS"  $PV_STATUS
#echo "WIRKG"   $PV_WIRKG

wget $PARAMETER_WGET "$URL=PV.DC1&value=$PV_STRING_1_LEISTUNG_in_W"
wget $PARAMETER_WGET "$URL=PV.DC2&value=$PV_STRING_2_LEISTUNG_in_W"
wget $PARAMETER_WGET "$URL=PV.AC&value=$PV_AKTUELL"
wget $PARAMETER_WGET "$URL=PV.DAILYP&value=$PV_TAG"
wget $PARAMETER_WGET "$URL=PV.TOTAL&value=$PV_GESAMT"
wget $PARAMETER_WGET "$URL=PV.STATE&value=$PV_STATUS"
#wget $PARAMETER_WGET "$URL=PV.Wirkg&value=$PV_WIRKG"

# EOF