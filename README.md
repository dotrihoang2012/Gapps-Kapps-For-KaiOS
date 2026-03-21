# Gapps & Kapps

> A guide to installing **Gapps** (Google Apps) and **Kapps** (KaiOS Apps) via Recovery Mode on KaiOS devices.

---

## Overview

### Gapps — Google Apps Package

**Gapps** is a collection of Google web apps (PWA) packaged for KaiOS, installed as hosted web applications under their respective domains:

- **search.google.com** -- Google Search
- **account.google.com** -- Google Account management
- **assistant.google.com** -- Google Assistant (web)
- **books.google.com** -- Google Books
- **calendar2.google.com** -- Google Calendar
- **contacts2.google.com** -- Google Contacts
- **drive.google.com** -- Google Drive
- **google.com_maps** -- Google Maps
- **mail.google.com** -- Gmail
- **news.google.com** -- Google News
- **photos.google.com** -- Google Photos
- **shorts.com** -- YouTube Shorts
- **translate.google.com** -- Google Translate
- **youtube.com** -- YouTube

---

### Kapps — KaiOS Apps Package

**Kapps** is an extended app bundle built specifically for the **KaiOS** platform -- the operating system powering modern feature phones such as Nokia, Alcatel, Doro, JioPhone, and others.

Kapps includes native KaiOS applications such as:

**Productivity & Utilities**
- **Store** -- KaiOS app marketplace
- **KaiWeather** -- weather forecasting app
- **QR_Reader** -- QR code scanner
- **Todo** -- task management app
- **Activity** -- activity tracker
- **Counter** -- simple counter utility
- **Magnify** -- screen magnifier
- **Run_Pace_Converter** -- running pace calculator
- **Network_Test** -- network diagnostics tool
- **Auth_Assistant** -- authentication helper
- **Top_up_Request** -- mobile top-up request app
- **KaiOS_Pay** -- KaiOS payment service
- **News** -- news reader
- **Books** -- e-book reader

**Games and Education**
- **2048** -- classic 2048 puzzle game
- **2048 Christmas Edition** -- holiday variant of 2048
- **Whack_a_Mole** -- whack-a-mole arcade game
- **Tic_Tac_Toe** -- classic tic-tac-toe
- **Stack_Building** -- block stacking game
- **Ice_Breaker** -- ice breaker puzzle game
- **Bubble_Shooter** -- bubble shooter arcade
- **Sokoban** -- box-pushing puzzle game
- **Gems** -- gem matching game
- **Crazy_Eggs** -- egg catching game
- **Guardians** -- action game
- **Life** -- an in-house educational app
- **Birdy** -- a similar Flappy Bird game
- **Drawsum** -- math challenge game
- **Plan_ET** -- action game
- **Word_of_The_Day** -- daily vocabulary app

> Kapps is designed for small screens, D-pad navigation, and low-RAM environments typical of feature phones.

---

## Requirements

| Requirement | Details |
|---|---|
| Device | A KaiOS phone must have a recovery mode with **test-keys** |
| Signature | Package must be signed with **test-keys** (not release-keys) |
| Battery | At least **50%** charge before flashing |
| ADB | ADB & Fastboot installed on your computer |
| Package | `gapps_signed.zip` or `kapps_signed.zip` |

---

## Flash Instructions

### Step 1 -- Prepare the file

Download the `.zip` package to your computer. **Do not extract it.**

```bash
# Verify ADB detects your device
adb devices
```

---

### Step 2 -- Boot into Recovery Mode

**Option A -- Via ADB:**
```bash
adb reboot recovery
```

**Option B -- Manually:**
- Power off the device completely
- Hold `Arrow Up + Power` (key combo may vary by device)
- Release Power key when the logo appears until in the recovery mode 

---

### Step 3 — Install the OTA package

**Method 1 — ADB Sideload**

1. Select **"Apply update"** → **"Apply from ADB"**
2. On your computer, run:

```bash
adb sideload gapps_signed_testkeys.zip
```

Or for Kapps:

```bash
adb sideload kapps_signed_testkeys.zip
```

3. Wait for the progress to reach **100%** — the device screen will display a live install log.

---

**Method 2 — Apply from SD Card**

1. Copy the `.zip` file to the root of your SD card.
2. Insert the SD card into the device.
3. In the recovery menu, select **"Apply update"** → **"Apply from SD card"**
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

## Understanding the Flash Log

During sideload, you will see output like this on the device screen:

```
|--------------------------|
| Gapps / Kapps |
|--------------------------|
Unpacking resources...
Running install script...
Wipe cache...
Done!
```

---

## Common Errors & Fixes

### `signature verification failed`
```
The package is unsigned or recovery has signature checking enabled.
 Fix: Sign zip file or Flash Recovery Mode with test-keys again.
```

### `adb: failed to read command`
```
ADB connection dropped during transfer.
 Fix: Try a different USB cable; avoid USB hubs.
```

### `Error: 7` or `Error: 70`
```
Package is incompatible with this device or Android version.
 Fix: Double-check the CPU architecture (arm/arm64) and Android version.
```

---

## OTA Package Structure

```
gapps_signed_testkeys.zip  (CERT.SF / CERT.RSA signed with test-keys)
 META-INF/
 com/google/android/
 update-binary ARM ELF binary that drives the install
 updater-script Edify script controlling install logic
 busybox Static shell utilities used by the script
 system/ Files to be copied into /system
 app/ Standard APKs
 priv-app/ Privileged APKs (system-level permissions)
 install.sh Main installation shell script
```

---

## Notes

- Packages must be signed with **test-keys** -- the same keys used in KaiOS engineering/debug builds
- The zip must contain `META-INF/CERT.SF` and `META-INF/CERT.RSA` signed with test-keys (not release-keys)
- Compatible only with KaiOS devices whose recovery that accepts test-key signed packages
- **Always back up your data** before flashing
- Do not power off the phone, remove the battery or unplug the USB cable during the flash process

---

## References

- [Android Debug Bridge (ADB) Docs](https://developer.android.com/tools/adb)
- [KaiOS Developer Portal](https://developer.kaiostech.com)
- [Bananahackers Website](https://sites.google.com/view/bananahackers)

---

*This README is provided for research and development purposes. Flashing your device may void its warranty. I am not responsible for any damage, data loss, or bricked devices that may occur during or after the flashing process — for any reason, under any circumstance, with no exceptions.*