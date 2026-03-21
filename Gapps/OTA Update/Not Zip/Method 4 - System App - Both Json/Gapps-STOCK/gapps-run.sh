#!/tmp/busybox sh

# GApps KaiOS - Method 4
# App vao /system/b2g/webapps
# basePath = /system/b2g/webapps
# Patch ca 2 webapps.json: /system va /data/local

SETTINGSFILE='/system/b2g/defaults/settings.json'
PREFFILE='/system/b2g/defaults/pref/user.js'
OMNIJA='/system/b2g/omni.ja'
WEBAPPS_SYSTEM='/system/b2g/webapps/webapps.json'
WEBAPPS_DATA='/data/local/webapps/webapps.json'
WEBAPPSDIR_SYSTEM='/system/b2g/webapps'
WEBAPPSDIR_DATA='/data/local/webapps'
APPSDIR='/tmp/gapps-distribution'

/tmp/busybox mount -t ext4 -o rw /dev/block/bootdevice/by-name/system /system
/tmp/busybox mount -t vfat -o rw /dev/block/mmcblk1p1 /sdcard

TIMESTAMP=`date +%s`
/tmp/busybox cp $SETTINGSFILE /sdcard/b2g-settings-backup.${TIMESTAMP}.json
/tmp/busybox cp $PREFFILE /sdcard/b2g-pref-backup.${TIMESTAMP}.js
/tmp/busybox cp $OMNIJA /sdcard/b2g-omni.${TIMESTAMP}.ja
/tmp/busybox cp $WEBAPPS_SYSTEM /sdcard/b2g-webapps-system-backup.${TIMESTAMP}.json
if /tmp/busybox [ -f $WEBAPPS_DATA ]; then
    /tmp/busybox cp $WEBAPPS_DATA /sdcard/b2g-webapps-data-backup.${TIMESTAMP}.json
fi
/tmp/busybox umount /sdcard

# Copy app vao /system/b2g/webapps
for appdir in $APPSDIR/*/; do
    appname=$(/tmp/busybox basename "$appdir")
    dest="$WEBAPPSDIR_SYSTEM/$appname"
    /tmp/busybox mkdir -p "$dest"
    /tmp/busybox cp -r "$appdir"* "$dest/"
done

# Patch /system/b2g/webapps/webapps.json
MANCONT=$(/tmp/busybox cat $WEBAPPS_SYSTEM)
echo -n ${MANCONT%?} > /tmp/webapps-system.json
/tmp/busybox cat /tmp/webapps-system.json /tmp/gapps-distribution/decl.patch > $WEBAPPS_SYSTEM

/tmp/busybox umount /system

# Patch /data/local/webapps/webapps.json (cung decl.patch, basePath la /system)
/tmp/busybox mkdir -p $WEBAPPSDIR_DATA

if /tmp/busybox [ -f $WEBAPPS_DATA ]; then
    MANCONT=$(/tmp/busybox cat $WEBAPPS_DATA)
    echo -n ${MANCONT%?} > /tmp/webapps-data.json
    /tmp/busybox cat /tmp/webapps-data.json /tmp/gapps-distribution/decl.patch > $WEBAPPS_DATA
else
    echo -n "{" > /tmp/webapps-data.json
    /tmp/busybox sed 's/^,//' /tmp/gapps-distribution/decl.patch > /tmp/decl-nocomma.patch
    /tmp/busybox cat /tmp/webapps-data.json /tmp/decl-nocomma.patch > $WEBAPPS_DATA
fi

/tmp/busybox chmod 600 $WEBAPPS_DATA
echo "GApps Method 4 installed successfully"
