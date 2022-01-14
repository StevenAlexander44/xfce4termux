# xfce4termux
XFCE4 gui running inside Termux

## Installation command
Download [Termux](https://f-droid.org/packages/com.termux) and paste this script
```
pkg up && curl -sL bit.ly/xfce4termux | bash
```

Then run ```desktop``` to start the xfce environment

## Chromium problems

### You will get logged out of most sites every time you close chromium

Open chromium > go to chrome://settings > "You and Google" > "Sync and Google services" > disable "Allow Chromium sign-in"

### The time is wrong

This sets the time to EST, but only applies after you close and reopen chromium
```
proot-distro login alpine -- apk add tzdata
proot-distro login alpine -- cp /usr/share/zoneinfo/America/New_York /etc/localtime
```
Check [Alpine's wiki](https://wiki.alpinelinux.org/wiki/Setting_the_timezone) for more information

### 32 bit (armv7) systems won't run chromium, so you'll have to try to use firefox

```
proot-distro reset alpine
proot-distro login alpine -- apk del chromium
proot-distro login alpine -- apk add firefox
```
