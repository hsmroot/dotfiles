#!/bin/bash

MAC="B0:38:E2:6B:D6:86"

connect_now() {
    # Give BlueZ hardware antenna 1 second to fully wake up
    sleep 1
    if bluetoothctl show | grep -q "Powered: yes"; then
        bluetoothctl connect "$MAC" >/dev/null 2>&1
    fi
}

# Listener 1: Catch GNOME desktop unlock events (Session Bus)
dbus-monitor --session "type='signal',interface='org.gnome.ScreenSaver',member='ActiveChanged'" | while read -r line; do
    if echo "$line" | grep -q "boolean false"; then
        connect_now &
    fi
done &

# Listener 2: Catch Bluetooth radio toggling ON (System Bus)
dbus-monitor --system "type='signal',interface='org.freedesktop.DBus.Properties'" | while read -r line; do
    if echo "$line" | grep -q "Powered"; then
        connect_now &
    fi
done &

wait
