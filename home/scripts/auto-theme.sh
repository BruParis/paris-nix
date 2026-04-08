#!/usr/bin/env bash
# Set kitty/neovim/waybar theme based on current local hour.
# Light mode: DAY_START..DAY_END, dark otherwise.
# Tries worldtimeapi.org (IP geolocation) for correct timezone when traveling;
# falls back to system clock.

DAY_START=7
DAY_END=20

STATE_FILE="$HOME/.local/share/theme-mode"
KITTY_THEMES_DIR="$HOME/.config/kitty/themes"
CURRENT_THEME="$HOME/.config/kitty/current-theme.conf"

# Try to get current hour from internet (IP-based timezone detection).
# worldtimeapi.org returns JSON with e.g. "datetime":"2026-04-08T10:30:00.000000+02:00"
hour=$(curl -sf --max-time 5 "https://worldtimeapi.org/api/ip" \
  | grep -o '"datetime":"[^"]*"' \
  | grep -o 'T[0-9][0-9]' \
  | tr -d 'T' \
  | sed 's/^0*//' )

# Fallback to system clock
if [ -z "$hour" ]; then
  hour=$(date +%-H)
fi

# Determine target theme
if [ "$hour" -ge "$DAY_START" ] && [ "$hour" -lt "$DAY_END" ]; then
  target="light"
else
  target="dark"
fi

# Skip if already set correctly
current=$(cat "$STATE_FILE" 2>/dev/null || echo "")
[ "$current" = "$target" ] && exit 0

mkdir -p "$(dirname "$STATE_FILE")"
install -m 644 "$KITTY_THEMES_DIR/${target}.conf" "$CURRENT_THEME"
echo "$target" > "$STATE_FILE"

# Reload running kitty instances (may not exist at startup — that's fine)
pkill -USR1 kitty 2>/dev/null || true

# Tell waybar to refresh the theme module (SIGRTMIN+8)
pkill -SIGRTMIN+8 waybar 2>/dev/null || true

# Notify running Neovim instances via RPC sockets
for sock in /run/user/$(id -u)/nvim.*.0; do
  [ -S "$sock" ] && nvim --server "$sock" --remote-expr 'execute("ToggleTheme")' 2>/dev/null || true
done
