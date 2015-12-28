#!/bin/bash

mkdir -p /config/transmission

if [ ! -f /config/transmission/settings.json ]; then
    cp /var/lib/transmission-daemon/info/settings.json /config/transmission
    rm /etc/transmission-daemon/settings.json
else
    rm /var/lib/transmission-daemon/info/settings.json
    rm /etc/transmission-daemon/settings.json
fi

ln -sf /config/transmission/settings.json /var/lib/transmission-daemon/info/settings.json
ln -sf /config/transmission/settings.json /etc/transmission-daemon/settings.json

/usr/bin/transmission-daemon --foreground --config-dir /config/transmission --log-info --auth --watch-dir /watch --download-dir /downloads --incomplete-dir /incomplete
