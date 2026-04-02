# Gapps & Kapps for KaiOS

A guide to installing **Gapps** (Google Apps) and **Kapps** (KaiOS Apps) via Recovery Mode on KaiOS devices.

---

## Requirements

>A KaiOS device must have a recovery mode with **test-keys** 
>Package must be signed with **test-keys** (not release-keys)
>At least **50%** charge before flashing
>ADB & Fastboot installed on your computer
>Package can be `gapps_signed.zip` or `kapps_signed.zip`

---

## Flash Instructions

### Step 1 -- Prepare the file

Download the `.zip` package to your computer or your KaiOS device. **Do not extract it.**

```bash
# Verify ADB detects your device
adb devices
```

---

### Step 2 -- Boot into Recovery Mode

**Via ADB:**
```bash
adb reboot recovery
```

---

### Step 3 -- Install the OTA package

**Method 1 -- ADB Sideload**

1. Select **"Apply update"** → **"Apply from ADB"**
2. On your computer, run:

```bash
adb sideload gapps_signed.zip
```

Or for Kapps:

```bash
adb sideload kapps_signed.zip
```

3. Wait untill the device screen will display a live install log.

---

**Method 2 — Apply from SD Card**

1. Copy the `.zip` file into your SD card.
2. Insert the SD card into the device.
3. In the recovery menu, select → **"Apply from SD card"**
4. Navigate to the `.zip` file and confirm.
5. Wait for the installation to complete.

---

### Step 4 -- Reboot

Once flashing is complete, select **"Reboot system now"** from the recovery menu.

```bash
# Or via ADB
adb reboot
```

---

## Common Errors & Fixes

### `signature verification failed`
```
The package is unsigned or recovery has signature checking enabled.
 Fix: Sign zip file or Flash Recovery Mode with test-keys again.
```

---

## Notes

- Packages must be signed with **test-keys** -- the same keys used in KaiOS engineering/debug builds
- The zip must contain `META-INF/CERT.SF` and `META-INF/CERT.RSA` signed with test-keys (not release-keys)
- Compatible only with KaiOS devices
- **Always back up your data** before flashing
- Do not power off the phone, remove the battery or unplug the USB cable during the flash process

---

## References

- [Android Debug Bridge (ADB) Docs](https://developer.android.com/tools/adb)
- [KaiOS Developer Portal](https://developer.kaiostech.com)
- [Bananahackers Website](https://sites.google.com/view/bananahackers)

---

*THIS README IS PROVIDED FOR RESEARCH AND DEVELOPMENT PURPOSES. I AM NOT RESPONSIBLE FOR ANY DAMAGE, DATA LOSS, OR BRICKED DEVICES THAT MAY OCCUR DURING OR AFTER THE FLASHING PROCESS — FOR ANY REASON.*

---
 
If you have any errors or bugs, please email me at: dotrihoang2012@gmail.com
