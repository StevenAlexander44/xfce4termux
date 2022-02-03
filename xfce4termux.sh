cd
pkg i x11-repo -y
pkg i xfce4 tigervnc xfce4-goodies xorg-xhost git proot-distro -y

# vnc
mkdir .vnc
echo -e '#!/data/data/com.termux/files/usr/bin/sh\nxfce4-session &\nxhost + &' > .vnc/xstartup
chmod u+x .vnc/xstartup

# noVNC
git clone https://github.com/novnc/noVNC $PREFIX/opt/novnc

# alpine and chromium
proot-distro install alpine
proot-distro login alpine -- apk update
proot-distro login alpine -- apk upgrade
proot-distro login alpine -- apk add chromium gtk+3.0 tzdata
proot-distro login alpine -- cp /usr/share/zoneinfo/America/New_York /etc/localtime

# config
mkdir ~/.config
git clone https://github.com/StevenAlexander44/xfce4termux
(cd ~/xfce4termux/config && tar c .) | (cd ~/.config && tar xf -)
cd; rm -rf xfce4termux

# aliases
echo -e 'replacePanel() { sed -i "s/$1/g" `grep -lr "$2" .config/xfce4/panel`; }' >> .bashrc
echo -e 'desktop() { rm -rf $TMPDIR/.X*; vncserver :0 -listen tcp -geometry 1280x720; }' >> .bashrc
echo -e 'desktopstop() { vncserver -kill :0; }' >> .bashrc
echo -e 'desktoptoggle() { if [ $(Xvnc -c) = 0 ]; then desktop; else desktopstop; fi; }' >> .bashrc
echo -e 'novnc() { replacePanel busy/available novnctoggle; $PREFIX/opt/novnc/utils/novnc_proxy; }' >> .bashrc
echo -e 'novncstop() { pkill -f novnc_proxy; replacePanel available/busy novnctoggle; }' >> .bashrc
echo -e 'novnctoggle() { if [ $(pgrep novnc_proxy -fc) = 0 ]; then novnc; else novncstop; fi; }' >> .bashrc
echo -e 'chromium() { proot-distro login alpine -- sh -c "export DISPLAY=:0 && export PULSE_SERVER=127.0.0.1 && chromium-browser --no-sandbox"; }' >> .bashrc
echo -e 'audio() { pulseaudio --start --exit-idle-time=-1; pacmd load-module module-native-protocol-tcp auth-ip-acl="127.0.0.1;10.0.0.0/8;192.168.0.0/16" auth-anonymous=1; replacePanel muted/high audiotoggle; echo export PULSE_SERVER=`ipaddr`; }' >> .bashrc
echo -e 'audiostop() { pulseaudio -k; replacePanel high/muted audiotoggle; }' >> .bashrc
echo -e 'audiotoggle() { if [ $(pgrep pulseaudio -c) = 0 ]; then audio; else audiostop; fi; }' >> .bashrc
echo -e 'ipaddr() { ip a show dev wlan0 | grep -oP "(?<=inet )\S+"; }' >> .bashrc 

# motd
echo -e 'Desktop Shortcuts:\n * desktop - xfce4 vnc session\n * novnc - access vnc in a browser\n * audio - local audio for linux\n * chromium - chromium in alpine\n' >> $PREFIX/etc/motd

echo Download is complete. Exit and restart termux to complete installation.
echo Recommended packages: pkg i tree htop openssh rsync mpv-x neofetch cpufetch iproute2 man aria2
