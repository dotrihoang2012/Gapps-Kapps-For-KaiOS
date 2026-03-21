#!/tmp/busybox sh

# KApps KaiOS - Super Dual-Install Edition
# Install to both /system/b2g/webapps AND /data/local/webapps

SETTINGSFILE='/system/b2g/defaults/settings.json'
PREFFILE='/system/b2g/defaults/pref/user.js'
OMNIJA='/system/b2g/omni.ja'
WEBAPPS_SYSTEM='/system/b2g/webapps/webapps.json'
WEBAPPS_DATA='/data/local/webapps/webapps.json'
WEBAPPSDIR_SYSTEM='/system/b2g/webapps'
WEBAPPSDIR_DATA='/data/local/webapps'
APPSDIR='/tmp/kapps-distribution'

# Mount /system rw và /sdcard
/tmp/busybox mount -t ext4 -o rw /dev/block/bootdevice/by-name/system /system
/tmp/busybox mount -t vfat -o rw /dev/block/mmcblk1p1 /sdcard

# Backup files to sdcard
TIMESTAMP=`date +%s`
/tmp/busybox cp $SETTINGSFILE /sdcard/b2g-settings-backup.${TIMESTAMP}.json
/tmp/busybox cp $PREFFILE /sdcard/b2g-pref-backup.${TIMESTAMP}.js
/tmp/busybox cp $OMNIJA /sdcard/b2g-omni.${TIMESTAMP}.ja
/tmp/busybox cp $WEBAPPS_SYSTEM /sdcard/b2g-webapps-system-backup.${TIMESTAMP}.json
if /tmp/busybox [ -f $WEBAPPS_DATA ]; then
    /tmp/busybox cp $WEBAPPS_DATA /sdcard/b2g-webapps-data-backup.${TIMESTAMP}.json
fi
/tmp/busybox umount /sdcard

# ── INSTALL vào /system/b2g/webapps ──
for appdir in $APPSDIR/*/; do
    appname=$(/tmp/busybox basename "$appdir")
    dest="$WEBAPPSDIR_SYSTEM/$appname"
    /tmp/busybox mkdir -p "$dest"
    /tmp/busybox cp -r "$appdir"* "$dest/"
done

# Patch /system/b2g/webapps/webapps.json
MANCONT=$(/tmp/busybox cat $WEBAPPS_SYSTEM)
echo -n ${MANCONT%?} > /tmp/webapps-system.json
/tmp/busybox cat /tmp/webapps-system.json /tmp/kapps-distribution/decl-system.patch > $WEBAPPS_SYSTEM

/tmp/busybox umount /system

# ── INSTALL vào /data/local/webapps ──
/tmp/busybox mkdir -p $WEBAPPSDIR_DATA

for appdir in $APPSDIR/*/; do
    appname=$(/tmp/busybox basename "$appdir")
    dest="$WEBAPPSDIR_DATA/$appname"
    /tmp/busybox mkdir -p "$dest"
    /tmp/busybox cp -r "$appdir"* "$dest/"
done

# Patch /data/local/webapps/webapps.json
if /tmp/busybox [ -f $WEBAPPS_DATA ]; then
    MANCONT=$(/tmp/busybox cat $WEBAPPS_DATA)
    echo -n ${MANCONT%?} > /tmp/webapps-data.json
    /tmp/busybox cat /tmp/webapps-data.json /tmp/kapps-distribution/decl-data.patch > $WEBAPPS_DATA
else
    echo -n "{" > /tmp/webapps-data.json
    /tmp/busybox sed 's/^,//' /tmp/kapps-distribution/decl-data.patch > /tmp/decl-nocomma.patch
    /tmp/busybox cat /tmp/webapps-data.json /tmp/decl-nocomma.patch > $WEBAPPS_DATA
fi

/tmp/busybox chmod 600 $WEBAPPS_DATA
echo "KApps dual-install completed successfully"
