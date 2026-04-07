#!/bin/bash
scheme=$(gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null)
if [[ "$scheme" == *"dark"* ]]; then
    exec delta --dark "$@"
else
    exec delta --light "$@"
fi
