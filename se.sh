#!/bin/bash
#
# liest Werte aus Stiebel Eltron ISG Web und pusht diese an eine CCU

IP_CCU2="192.168.1.74"
IP_ISG="192.168.1.73"

PARAMETER_WGET="-q -O - --timeout=10"

# ==============================================================================================================================
# Internet Service Gateway abfragen
# ==============================================================================================================================
wget $PARAMETER_WGET "http://$IP_ISG/?s=0" | html2text | tr -s " \t\r\n" > /tmp/isg_start
wget $PARAMETER_WGET "http://$IP_ISG/?s=1,0" | html2text | tr -s " \t\r\n" > /tmp/isg_ist

# ==============================================================================================================================
# Datum der Abfrage uebertragen
# ==============================================================================================================================
ISG_DATUM=$(date +%Y%m%d%H%M)
wget $PARAMETER_WGET "http://$IP_CCU2/addons/db/state.cgi?item=ISG_DATUM&value=$ISG_DATUM"

# ==============================================================================================================================
# ISTWERTE
# ==============================================================================================================================
ISG_LUEFTERSTUFE=$(php /home/darkiop/bin/isg_get_luefterstufe.php)
ISG_AUSSENTEMP=$(cat /tmp/isg_ist | grep "AUSSENTEMPERATUR" | cut -f2 -d" " | sed 's/','/'.'/g')
ISG_RAUMIST_HK1=$(cat /tmp/isg_ist | grep "RAUMISTTEMP. HK1" | cut -f3 -d" " | sed 's/','/'.'/g')
ISG_IST_HK1=$(cat /tmp/isg_ist | grep "ISTWERT HK1" | cut -f3 -d" " | sed 's/','/'.'/g')
ISG_SOLL_HK1=$(cat /tmp/isg_ist | grep "SOLLWERT HK1" | cut -f3 -d" " | sed 's/','/'.'/g')
ISG_WW_SOLL=$(cat /tmp/isg_ist | grep "WW-SOLLTEMP." | cut -f2 -d" " | sed 's/','/'.'/g')
ISG_WW_IST=$(cat /tmp/isg_ist | grep "WW-ISTTEMP." | cut -f2 -d" " | sed 's/','/'.'/g')
ISG_VORLAUF=$(cat /tmp/isg_ist | grep "VORLAUFTEMP." | cut -f2 -d" " | sed 's/','/'.'/g')
ISG_RUECKLAUF=$(cat /tmp/isg_ist | grep "RÜCKLAUFTEMPERATUR" | sed 's/'RÜCKLAUFTEMPERATUR'/''/g' | cut -f1 -d " " | sed 's/','/'.'/g')
ISG_HEIZSTUFE=$(cat /tmp/isg_ist | grep "HEIZSTUFE" | cut -f2 -d" ")
ISG_WM_HEIZEN_TAG=$(cat /tmp/isg_ist | grep "WM HEIZEN TAG" | cut -f4 -d" " | sed 's/','/'.'/g')
ISG_WM_HEIZEN_SUMME=$(cat /tmp/isg_ist | grep "WM HEIZEN SUMME" | cut -f4 -d" " | sed 's/','/'.'/g')
ISG_WM_WW_TAG=$(cat /tmp/isg_ist | grep "WM WW TAG" | cut -f4 -d" " | sed 's/','/'.'/g')
ISG_WM_WW_SUMME=$(cat /tmp/isg_ist | grep "WM WW SUMME" | cut -f4 -d" " | sed 's/','/'.'/g')
ISG_LZ_VERDICHTER_HEIZEN=$(cat /tmp/isg_ist | grep "VERDICHTER HEIZEN" | cut -f3 -d" ")
ISG_LZ_VERDICHTER_WW=$(cat /tmp/isg_ist | grep "VERDICHTER WW" | cut -f3 -d" ")
ISG_LZ_ELEKTR_NE_HEIZEN=$(cat /tmp/isg_ist | grep "ELEKTR. NE HEIZEN" | cut -f4 -d" ")
ISG_LZ_ELEKTR_NE_WW=$(cat /tmp/isg_ist | grep "ELEKTR. NE WW" | cut -f4 -d" ")

wget $PARAMETER_WGET "http://$IP_CCU2/addons/db/state.cgi?item=ISG_LUEFTERSTUFE&value=$ISG_LUEFTERSTUFE"
wget $PARAMETER_WGET "http://$IP_CCU2/addons/db/state.cgi?item=ISG_AUSSENTEMP&value=$ISG_AUSSENTEMP"
wget $PARAMETER_WGET "http://$IP_CCU2/addons/db/state.cgi?item=ISG_RAUMIST_HK1&value=$ISG_RAUMIST_HK1"
wget $PARAMETER_WGET "http://$IP_CCU2/addons/db/state.cgi?item=ISG_IST_HK1&value=$ISG_IST_HK1"
wget $PARAMETER_WGET "http://$IP_CCU2/addons/db/state.cgi?item=ISG_SOLL_HK1&value=$ISG_SOLL_HK1"
wget $PARAMETER_WGET "http://$IP_CCU2/addons/db/state.cgi?item=ISG_WW_SOLL&value=$ISG_WW_SOLL"
wget $PARAMETER_WGET "http://$IP_CCU2/addons/db/state.cgi?item=ISG_WW_IST&value=$ISG_WW_IST"
wget $PARAMETER_WGET "http://$IP_CCU2/addons/db/state.cgi?item=ISG_VORLAUF&value=$ISG_VORLAUF"
wget $PARAMETER_WGET "http://$IP_CCU2/addons/db/state.cgi?item=ISG_RUECKLAUF&value=$ISG_RUECKLAUF"
wget $PARAMETER_WGET "http://$IP_CCU2/addons/db/state.cgi?item=ISG_HEIZSTUFE&value=$ISG_HEIZSTUFE"
wget $PARAMETER_WGET "http://$IP_CCU2/addons/db/state.cgi?item=ISG_WM_HEIZEN_TAG&value=$ISG_WM_HEIZEN_TAG"
wget $PARAMETER_WGET "http://$IP_CCU2/addons/db/state.cgi?item=ISG_WM_HEIZEN_SUMME&value=$ISG_WM_HEIZEN_SUMME"
wget $PARAMETER_WGET "http://$IP_CCU2/addons/db/state.cgi?item=ISG_WM_WW_TAG&value=$ISG_WM_WW_TAG"
wget $PARAMETER_WGET "http://$IP_CCU2/addons/db/state.cgi?item=ISG_WM_WW_SUMME&value=$ISG_WM_WW_SUMME"
wget $PARAMETER_WGET "http://$IP_CCU2/addons/db/state.cgi?item=ISG_LZ_VERDICHTER_HEIZEN&value=$ISG_LZ_VERDICHTER_HEIZEN"
wget $PARAMETER_WGET "http://$IP_CCU2/addons/db/state.cgi?item=ISG_LZ_VERDICHTER_WW&value=$ISG_LZ_VERDICHTER_WW"
wget $PARAMETER_WGET "http://$IP_CCU2/addons/db/state.cgi?item=ISG_LZ_ELEKTR_NE_HEIZEN&value=$ISG_LZ_ELEKTR_NE_HEIZEN"
wget $PARAMETER_WGET "http://$IP_CCU2/addons/db/state.cgi?item=ISG_LZ_ELEKTR_NE_WW&value=$ISG_LZ_ELEKTR_NE_WW"

# ==============================================================================================================================
# BETRIEBSART
# ==============================================================================================================================
if test `grep '#AUTOMATIK' /tmp/isg_start | sed 's/'#'/''/g'`; then
  ISG_BETRIEBSART=Automatik
elif test `grep '#WARMWASSER' /tmp/isg_start | sed 's/'#'/''/g'`; then
  ISG_BETRIEBSART=Warmwasser
fi
wget $PARAMETER_WGET "http://$IP_CCU2/addons/db/state.cgi?item=ISG_BETRIEBSART&value=$ISG_BETRIEBSART"

# ==============================================================================================================================
# STATUS
# ==============================================================================================================================
if [ $(cat /tmp/isg_ist | grep "SCHALTPROGRAMM AKTIV" | wc -l) -gt 0 ]; then
  ISG_ST_SCHALTPROGRAMM=aktiv
  wget $PARAMETER_WGET "http://$IP_CCU2/addons/db/state.cgi?item=ISG_ST_SCHALTPROGRAMM&value=$ISG_ST_SCHALTPROGRAMM"
else
  ISG_ST_SCHALTPROGRAMM=inaktiv
  wget $PARAMETER_WGET "http://$IP_CCU2/addons/db/state.cgi?item=ISG_ST_SCHALTPROGRAMM&value=$ISG_ST_SCHALTPROGRAMM"
fi

if [ $(cat /tmp/isg_ist | grep "HEIZKREISPUMPE" | wc -l) -gt 0 ]; then
  ISG_ST_HEIZKREISPUMPE=aktiv
  wget $PARAMETER_WGET "http://$IP_CCU2/addons/db/state.cgi?item=ISG_ST_HEIZKREISPUMPE&value=$ISG_ST_HEIZKREISPUMPE"
else
  ISG_ST_HEIZKREISPUMPE=inaktiv
  wget $PARAMETER_WGET "http://$IP_CCU2/addons/db/state.cgi?item=ISG_ST_HEIZKREISPUMPE&value=$ISG_ST_HEIZKREISPUMPE"
fi

if [ $(cat /tmp/isg_ist | grep "VERDICHTER" | wc -l) -gt 0 ]; then
  ISG_ST_VERDICHTER=aktiv
  wget $PARAMETER_WGET "http://$IP_CCU2/addons/db/state.cgi?item=ISG_ST_VERDICHTER&value=$ISG_ST_VERDICHTER"
else
  ISG_ST_VERDICHTER=inaktiv
  wget $PARAMETER_WGET "http://$IP_CCU2/addons/db/state.cgi?item=ISG_ST_VERDICHTER&value=$ISG_ST_VERDICHTER"
fi

if [ $(cat /tmp/isg_ist | grep "WARMWASSERBEREITUNG" | wc -l) -gt 0 ]; then
  ISG_ST_WARMWASSERBEREITUNG=aktiv
  wget $PARAMETER_WGET "http://$IP_CCU2/addons/db/state.cgi?item=ISG_ST_WARMWASSERBEREITUNG&value=$ISG_ST_WARMWASSERBEREITUNG"
else 
  ISG_ST_WARMWASSERBEREITUNG=inaktiv
  wget $PARAMETER_WGET "http://$IP_CCU2/addons/db/state.cgi?item=ISG_ST_WARMWASSERBEREITUNG&value=$ISG_ST_WARMWASSERBEREITUNG"
fi

# EOF