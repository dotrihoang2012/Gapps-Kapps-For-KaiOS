#!/tmp/busybox sh

SETTINGSFILE='/system/b2g/defaults/settings.json'
PREFFILE='/system/b2g/defaults/pref/user.js'
OMNIJA='/system/b2g/omni.ja'
WEBAPPS='/system/b2g/webapps/webapps.json'
WEBAPPSDIR='/system/b2g/webapps'

/tmp/busybox mount -t ext4 -o rw /dev/block/bootdevice/by-name/system /system
/tmp/busybox mount -t vfat -o rw /dev/block/mmcblk1p1 /sdcard

TIMESTAMP=`date +%s`
/tmp/busybox cp $SETTINGSFILE /sdcard/b2g-settings-backup.${TIMESTAMP}.json
/tmp/busybox cp $PREFFILE /sdcard/b2g-pref-backup.${TIMESTAMP}.js
/tmp/busybox cp $OMNIJA /sdcard/b2g-omni.${TIMESTAMP}.ja
/tmp/busybox cp $WEBAPPS /sdcard/b2g-webapps-backup.${TIMESTAMP}.json

/tmp/busybox umount /sdcard

APPSDIR='/tmp/kapps-distribution'
for appdir in $APPSDIR/*/; do
    appname=$(/tmp/busybox basename "$appdir")
    dest="$WEBAPPSDIR/$appname"
    /tmp/busybox mkdir -p "$dest"
    /tmp/busybox cp -r "$appdir"* "$dest/"
done

MANCONT=$(/tmp/busybox cat $WEBAPPS)
echo -n ${MANCONT%?} > /tmp/webapps.json
/tmp/busybox cat /tmp/webapps.json /tmp/kapps-distribution/decl.patch > $WEBAPPS

/tmp/busybox umount /system
echo "KApps installed successfully"
