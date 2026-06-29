#!/bin/bash

echo "🚀 Starting automated Garuda GNOME system restoration..."

# 1. Update base system
sudo pacman -Syu --noconfirm

# 2. Restore native packages (Pacman + Chaotic-AUR + AUR)
# The '--needed' flag tells Paru to safely skip packages the fresh ISO already has
echo "📦 Restoring native application packages..."
if [ -f "$HOME/.config/pkglist.txt" ]; then
    paru -S --needed --noconfirm - < "$HOME/.config/pkglist.txt"
fi

# 3. Restore Flatpaks
echo "📦 Restoring Flatpaks..."
if [ -f "$HOME/.config/flatpaklist.txt" ]; then
    while read -r app; do
        [ -z "$app" ] && continue
        flatpak install -y flathub "$app"
    done < "$HOME/.config/flatpaklist.txt"
fi

# 4. Hardware Driver Restoration
echo "🛠️ Auto-configuring hardware drivers via MHWD..."
sudo mhwd -a pci free xorg

# 5. GNOME Extension Reinstallation
echo "🧩 Restoring GNOME Extensions..."
if [ -f "$HOME/.config/gnome-extensions.txt" ]; then
    while read -r ext; do
        [ -z "$ext" ] && continue
        gnome-extensions install "$ext" --quiet
    done < "$HOME/.config/gnome-extensions.txt"
fi

# 6. Apply Desktop Settings, Shortcuts, and Themes
echo "🎨 Applying dconf desktop settings..."
if [ -f "$HOME/.config/gnome/settings.dconf" ]; then
    dconf load /org/gnome/ < "$HOME/.config/gnome/settings.dconf"
fi

echo "✅ 100% System Restoration Complete!"
