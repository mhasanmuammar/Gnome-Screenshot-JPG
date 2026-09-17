#!/usr/bin/env bash
set -e

echo "Installing Gnome-Screenshot-JPG..."

# Ensure target directories exist
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.config/systemd/user"

# Copy files to destinations
cp gnome-screenshot-jpg.sh "$HOME/.local/bin/"
chmod +x "$HOME/.local/bin/gnome-screenshot-jpg.sh"

# Create systemd service file
cat << EOF > "$HOME/.config/systemd/user/gnome-screenshot-jpg.service"
[Unit]
Description=Host Native PNG to JPG Converter and Compressor
After=local-fs.target

[Service]
Type=oneshot
ExecStart=%h/.local/bin/gnome-screenshot-jpg.sh
ExecCondition=/usr/bin/find %h/Pictures/Screenshots -maxdepth 1 -name "*.png" -print -quit
EOF

# Create systemd path file
cat << EOF > "$HOME/.config/systemd/user/gnome-screenshot-jpg.path"
[Unit]
Description=Watch Screenshots Folder for New Images

[Path]
PathChanged=%h/Pictures/Screenshots
Unit=gnome-screenshot-jpg.service

[Install]
WantedBy=default.target
EOF

# Reload and enable systemd user tools
systemctl --user daemon-reload
systemctl --user enable --now gnome-screenshot-jpg.path

echo "Successfully installed! Systemd is now watching ~/Pictures/Screenshots."
