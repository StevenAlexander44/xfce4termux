cd
pkg i x11-repo -y
pkg i xfce4 tigervnc xfce4-goodies xorg-xhost git proot-distro -y

# vnc
mkdir .vnc
echo -e '#!/data/data/com.termux/files/usr/bin/sh\nxfce4-session &\nxhost + &' > .vnc/xstartup
chmod u+x .vnc/xstartup

echo -e 'vncserver :0 -listen tcp' > $PATH/desktop
chmod u+x $PATH/desktop
echo -e 'vncserver -kill :0' > $PATH/desktopstop
chmod u+x $PATH/desktopstop
echo -e 'desktop=$(pgrep xfce4-session | wc -l)\nif [ $desktop = 0 ]\nthen\n desktop\nelse\n desktopstop\nfi' > $PATH/desktoptoggle
chmod u+x $PATH/desktoptoggle

# noVNC
git clone https://github.com/novnc/noVNC .novnc

echo -e 'sed -i "s/busy/available/g" `grep -lr "novnctoggle" .config/xfce4/panel`\n~/.novnc/utils/novnc_proxy' > $PATH/novnc
chmod u+x $PATH/novnc
echo -e 'pkill python3\nsed -i "s/available/busy/g" `grep -lr "novnctoggle" .config/xfce4/panel`' > $PATH/novncstop
chmod u+x $PATH/novncstop
echo -e 'novnc=$(pgrep python3 | wc -l)\nif [ $novnc = 0 ]\nthen\n novnc\nelse\n novncstop\nfi' > $PATH/novnctoggle
chmod u+x $PATH/novnctoggle

# alpine chromium
proot-distro install alpine
proot-distro login alpine -- apk update
proot-distro login alpine -- apk upgrade
proot-distro login alpine -- apk add chromium gtk+3.0
echo -e 'proot-distro login alpine -- sh -c "export DISPLAY=:0 && export PULSE_SERVER=127.0.0.1 && chromium-browser --no-sandbox"' > $PATH/chromium
chmod u+x $PATH/chromium

# audio
echo -e 'pulseaudio --start --exit-idle-time=-1\npacmd load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1\nsed -i "s/muted/high/g" `grep -lr "audiotoggle" .config/xfce4/panel`' > $PATH/audio
chmod u+x $PATH/audio
echo -e 'pulseaudio -k\nsed -i "s/high/muted/g" `grep -lr "audiotoggle" .config/xfce4/panel`' > $PATH/audiostop
chmod u+x $PATH/audiostop
echo -e 'audio=$(pgrep pulseaudio | wc -l)\nif [ $audio = 0 ]\nthen\n audio\nelse\n audiostop\nfi' > $PATH/audiotoggle
chmod u+x $PATH/audiotoggle

# motd
echo -e 'Desktop Commands:\n * desktop - xfce4 vnc session\n * novnc - access vnc in a browser\n * audio - pulseaudio for alpine\n * chromium - chromium in alpine\n' >> ~/../usr/etc/motd
