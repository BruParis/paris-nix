#!/usr/bin/env bash

WALLPAPER_DIRS="$HOME/.config/hypr/images $HOME/Documents/Wallpapers"

# Find a random wallpaper
WALLPAPER=$(find $WALLPAPER_DIRS -type f -name "*.jpg" -o -name "*.png" | shuf --random-source=/dev/urandom -n 1)

swww img $WALLPAPER --transition-type none --resize fit
echo $WALLPAPER
