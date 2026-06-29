#!/bin/bash

# This hash ensures the script only re-runs if these specific lines change:
# GARUDA_UPDATE_FLATPAK="1"
# GARUDA_UPDATE_SNAP="1"

echo "🔐 Configuring global system environment variables..."

# Safely inject the variables into /etc/environment if they aren't already there
if ! grep -q "GARUDA_UPDATE_FLATPAK" /etc/environment; then
    echo 'GARUDA_UPDATE_FLATPAK="1"' | sudo tee -a /etc/environment > /dev/null
fi

if ! grep -q "GARUDA_UPDATE_SNAP" /etc/environment; then
    echo 'GARUDA_UPDATE_SNAP="1"' | sudo tee -a /etc/environment > /dev/null
fi

echo "✅ System environment updated successfully!"
echo "⚡ Injecting Nvidia Wayland hardware sync flags..."
if ! grep -q "MUTTER_DEBUG_FORCE_EGL_STREAM" /etc/environment; then
    echo 'MUTTER_DEBUG_FORCE_EGL_STREAM=1' | sudo tee -a /etc/environment > /dev/null
fi
