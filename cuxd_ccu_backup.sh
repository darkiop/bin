#!/bin/sh

mkdir /tmp/ccu_backup

echo "Erstelle Backup"
/usr/local/addons/cuxd/extra/ccu_backup /tmp/ccu_backup

echo "Loesche alte Backups"
find /tmp/ccu_backup -name "*.sbk" -mtime +7 -exec rm -f {} \;

echo "Uebertrage Backups an ccuio"
scp /tmp/ccu_backup/*.sbk darkiop@ccuio:/home/darkiop/occu-pi2-backup

echo "Fertig."
# EOF
