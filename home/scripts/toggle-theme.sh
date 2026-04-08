#!/usr/bin/env bash
# Toggle kitty between Catppuccin Macchiato (dark) and Catppuccin Latte (light).
# Called by waybar on-click; also used by waybar exec to get current icon.

KITTY_THEMES_DIR="$HOME/.config/kitty/themes"
CURRENT_THEME="$HOME/.config/kitty/current-theme.conf"
STATE_FILE="$HOME/.local/share/theme-mode"

if [ "$1" = "status" ]; then
  current=$(cat "$STATE_FILE" 2>/dev/null || echo "dark")
  if [ "$current" = "dark" ]; then
    echo "󰖔"
  else
    echo "󰖨"
  fi
  exit 0
fi

mkdir -p "$(dirname "$STATE_FILE")"

current=$(cat "$STATE_FILE" 2>/dev/null || echo "dark")
if [ "$current" = "dark" ]; then
  next="light"
else
  next="dark"
fi

install -m 644 "$KITTY_THEMES_DIR/${next}.conf" "$CURRENT_THEME"
echo "$next" > "$STATE_FILE"

# Reload all running kitty instances
pkill -USR1 kitty 2>/dev/null || true

# Tell waybar to refresh the custom/theme module (signal 8 = SIGRTMIN+8)
pkill -SIGRTMIN+8 waybar 2>/dev/null || true

# Notify running Neovim instances via their RPC sockets
for sock in /run/user/$(id -u)/nvim.*.0; do
  [ -S "$sock" ] && nvim --server "$sock" --remote-expr 'execute("ToggleTheme")' 2>/dev/null || true
done
