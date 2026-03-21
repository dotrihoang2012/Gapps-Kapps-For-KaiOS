#!/tmp/busybox sh

# KApps KaiOS - Small Sideload Edition
# Install to /data/local/webapps (no system mount needed)

SETTINGSFILE='/system/b2g/defaults/settings.json'
PREFFILE='/system/b2g/defaults/pref/user.js'
OMNIJA='/system/b2g/omni.ja'
WEBAPPS_SYSTEM='/system/b2g/webapps/webapps.json'
WEBAPPS_DATA='/data/local/webapps/webapps.json'
WEBAPPSDIR='/data/local/webapps'

# Mount /system ro (chỉ cần đọc backup) và /sdcard
/tmp/busybox mount -t ext4 -o rw /dev/block/bootdevice/by-name/system /system
/tmp/busybox mount -t vfat -o rw /dev/block/mmcblk1p1 /sdcard

# Backup files to sdcard
TIMESTAMP=`date +%s`
/tmp/busybox cp $SETTINGSFILE /sdcard/b2g-settings-backup.${TIMESTAMP}.json
/tmp/busybox cp $PREFFILE /sdcard/b2g-pref-backup.${TIMESTAMP}.js
/tmp/busybox cp $OMNIJA /sdcard/b2g-omni.${TIMESTAMP}.ja
/tmp/busybox cp $WEBAPPS_SYSTEM /sdcard/b2g-webapps-system-backup.${TIMESTAMP}.json

# Backup /data/local/webapps/webapps.json nếu có
if /tmp/busybox [ -f $WEBAPPS_DATA ]; then
    /tmp/busybox cp $WEBAPPS_DATA /sdcard/b2g-webapps-data-backup.${TIMESTAMP}.json
fi

/tmp/busybox umount /sdcard
/tmp/busybox umount /system

# Tạo thư mục /data/local/webapps nếu chưa có
/tmp/busybox mkdir -p $WEBAPPSDIR

# Copy app files vào /data/local/webapps
APPSDIR='/tmp/kapps-distribution'
for appdir in $APPSDIR/*/; do
    appname=$(/tmp/busybox basename "$appdir")
    dest="$WEBAPPSDIR/$appname"
    /tmp/busybox mkdir -p "$dest"
    /tmp/busybox cp -r "$appdir"* "$dest/"
done

# Tạo hoặc patch /data/local/webapps/webapps.json
if /tmp/busybox [ -f $WEBAPPS_DATA ]; then
    # Đã có webapps.json trong /data/local → append vào
    MANCONT=$(/tmp/busybox cat $WEBAPPS_DATA)
    echo -n ${MANCONT%?} > /tmp/webapps-data.json
    /tmp/busybox cat /tmp/webapps-data.json /tmp/kapps-distribution/decl.patch > $WEBAPPS_DATA
else
    # Chưa có → tạo mới từ template
    echo -n "{" > /tmp/webapps-data.json
    # Bỏ dấu phẩy đầu trong decl.patch khi tạo file mới
    /tmp/busybox sed 's/^,//' /tmp/kapps-distribution/decl.patch > /tmp/decl-nocomma.patch
    /tmp/busybox cat /tmp/webapps-data.json /tmp/decl-nocomma.patch > $WEBAPPS_DATA
fi

/tmp/busybox chmod 600 $WEBAPPS_DATA
echo "KApps sideload installed successfully"
