# Gapps & Kapps for KaiOS

A guide to installing **Gapps** (Google Apps) and **Kapps** (KaiOS Apps) via Recovery Mode on KaiOS devices.

---

Before installing:

****THIS README.md IS PROVIDED FOR TESTING ONLY. THE FIRST RELEASE WILL BE MANY BUGS, SO PROCEED AT YOUR OWN RISK. I AM NOT RESPONSIBLE FOR ANY DAMAGE, DATA LOSS, OR BRICKED DEVICES THAT MAY OCCUR DURING OR AFTER THE INSTALLING PROCESS FOR ANY REASON, UNDER ANY CIRCUMSTANCE, WITH NO EXCEPTIONS.****


If you're worried about installing, install manually in the store or third-party webapps in WebIDE. 


<details>
  <summary>I acknowledge what's going on and ready to proceed</summary>

## Requirements

- A KaiOS device must have a recovery mode with **test-keys**
- Package must be signed with **test-keys** (not release-keys)
- At least **50%** charge before flashing
- ADB & Fastboot installed on your computer
- Package can be `gapps_signed.zip` or `kapps_signed.zip`


**If your device in the normal mode, please go to [Bananahackers Website](https://sites.google.com/view/bananahackers) for more information about rooting device and change the stock recovery mode.**

---

## Flash Instructions

### Step 1: Prepare the file

Download the `.zip` package to your computer or your KaiOS device. **Do not extract it.**

**If the logo bug already show in the status bar, skip this step and enable ADB. If not, follow this:**

#### Enable ADB (required for ADB)


**Method 1 — Dial code**
- In the home screen, dial:
```
*#*#33284#*#*
```
- If it does not work, try:
```
*#*#0574#*#*
```

**Method 2 — Using browser (W2D)**
1. Open the browser on your KaiOS device
2. Go to: http://w2d.js.org/
3. Navigate to **W2D KaiOS Jailbreak**
4. Press **"Open Developer menu"**
5. In Developer settings:
   - Set **Debugger → ADB and DevTools**

**The logo bug will show in the status bar.** 


After finish, plug into your computer and type:

```bash
# Verify ADB detects your device
adb devices
```

**If the adb can't detect your device, please use the new cable.**

---

### Step 2: Boot into Recovery Mode
Type:

```bash
adb reboot recovery
```

---

### Step 3: Install the OTA package

**Method 1 - ADB Sideload**

1. Select **"Apply update"** → **"Apply from ADB"**
2. On your computer, run:

```bash
adb sideload Kapps_signed.zip
```

Or for Kapps:

```bash
adb sideload Kapps_signed.zip
```

3. Wait untill the device screen will display a live install log.

---

**Method 2 - Apply from SD Card**

1. Copy the `.zip` file into your SD card.
2. Insert the SD card into the device.
3. In the recovery menu, select → **"Apply from SD card"**
4. Navigate to the `.zip` file and confirm.
5. Wait untill the device screen will display a live install log.

---

https://github.com/user-attachments/assets/b369b46d-9dc3-4d3e-8b62-375b0df5e71c

**This is an example of installing Successfully Kapps-Slideloded-Super version on Nokia 8110 4G on SD card.**

### Step 4: Reboot

Once installing is complete, select **"Reboot system now"** from the recovery menu.

```bash
# Or via ADB
adb reboot
```

---

## Common Errors & Fixes

### `signature verification failed.`
```
The package is unsigned or recovery has signature checking enabled.
 Fix: Sign zip file or Flash Recovery Mode with test-keys again.
```

---

### `Installation Aborted.`
```
Your Battery is low.
 Fix: charge your phone untill reach to 50% or above.
```

## Notes

- Packages must be signed with **test-keys**
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

If you have any errors or bugs while flashing or after flashing, please email me at: dotrihoang2012@gmail.com
