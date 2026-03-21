#!/tmp/busybox sh

# GApps KaiOS installer
# Based on OmniJB by Luxferre

SETTINGSFILE='/system/b2g/defaults/settings.json'
PREFFILE='/system/b2g/defaults/pref/user.js'
OMNIJA='/system/b2g/omni.ja'
WEBAPPS='/system/b2g/webapps/webapps.json'
WEBAPPSDIR='/system/b2g/webapps'

# Mount /system rw and /sdcard
/tmp/busybox mount -t ext4 -o rw /dev/block/bootdevice/by-name/system /system
/tmp/busybox mount -t vfat -o rw /dev/block/mmcblk1p1 /sdcard

# Backup files to sdcard
TIMESTAMP=`date +%s`
/tmp/busybox cp $SETTINGSFILE /sdcard/b2g-settings-backup.${TIMESTAMP}.json
/tmp/busybox cp $PREFFILE /sdcard/b2g-pref-backup.${TIMESTAMP}.js
/tmp/busybox cp $OMNIJA /sdcard/b2g-omni.${TIMESTAMP}.ja
/tmp/busybox cp $WEBAPPS /sdcard/b2g-webapps-backup.${TIMESTAMP}.json

# Unmount /sdcard after backup
/tmp/busybox umount /sdcard

# Install each Google App into /system/b2g/webapps/
APPSDIR='/tmp/gapps-distribution'

for appdir in $APPSDIR/*/; do
    appname=$(/tmp/busybox basename "$appdir")
    dest="$WEBAPPSDIR/$appname"
    /tmp/busybox mkdir -p "$dest"
    /tmp/busybox cp -r "$appdir"* "$dest/"
done

# Patch webapps.json - inject all app entries
MANCONT=$(/tmp/busybox cat $WEBAPPS)
echo -n ${MANCONT%?} > /tmp/webapps.json
/tmp/busybox cat /tmp/webapps.json /tmp/gapps-distribution/decl.patch > $WEBAPPS

# Unmount /system
/tmp/busybox umount /system
echo "GApps installed successfully"
