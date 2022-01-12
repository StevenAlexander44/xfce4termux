# xfce4termux
XFCE4 gui running inside Termux

```
pkg up && curl -sL bit.ly/xfce4termux | bash
```

## Chromium problems

### You will get logged out of most sites every time you close chromium

Open chromium > go to chrome://settings > "You and Google" > "Sync and Google services" > disable "Allow Chromium sign-in"

### 32 bit (armv7) systems won't run chromium, so you'll have to try to use firefox
```
proot-distro reset alpine
proot-distro login alpine -- apk add firefox
```
