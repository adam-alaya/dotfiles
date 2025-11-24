#!/usr/bin/env bash
# Rofi clipboard manager - last 10 entries, numbered selection, multiline-safe
# 0 = Clear clipboard

HISTORY_FILE="$HOME/.local/share/rofi_clipboard_history"
MAX_ENTRIES=10
MENU_LINE_LENGTH=50
NEWLINE_PLACEHOLDER="↵"

# Ensure history file exists
mkdir -p "$(dirname "$HISTORY_FILE")"
touch "$HISTORY_FILE"

# Helper: detect and use appropriate clipboard commands
read_clipboard() {
  if command -v wl-paste >/dev/null 2>&1; then
    wl-paste -n 2>/dev/null
  elif command -v xclip >/dev/null 2>&1; then
    xclip -o -selection clipboard 2>/dev/null
  else
    return 1
  fi
}

write_clipboard() {
  # pass data on stdin
  if command -v wl-copy >/dev/null 2>&1; then
    wl-copy
  elif command -v xclip >/dev/null 2>&1; then
    xclip -selection clipboard -i
  else
    return 1
  fi
}

# Get current clipboard
CURRENT=$(read_clipboard)

# Encode newlines for storage (store as literal \n)
if [ -n "$CURRENT" ]; then
  ENCODED=$(printf '%s' "$CURRENT" | sed ':a;N;$!ba;s/\n/\\n/g')
  # Remove duplicate if exists, then append
  grep -Fxv -- "$ENCODED" "$HISTORY_FILE" >"$HISTORY_FILE.tmp" 2>/dev/null || cat /dev/null >"$HISTORY_FILE.tmp"
  echo "$ENCODED" >>"$HISTORY_FILE.tmp"
  mv "$HISTORY_FILE.tmp" "$HISTORY_FILE"
fi

# Keep only last MAX_ENTRIES
tail -n "$MAX_ENTRIES" "$HISTORY_FILE" >"$HISTORY_FILE.tmp"
mv "$HISTORY_FILE.tmp" "$HISTORY_FILE"

# Build menu: start with 0 = clear
MENU="0. Clear Clipboard\n"
i=1
while read -r line; do
  # Replace stored newline markers with placeholder for display and trim
  DISPLAY_LINE=$(printf '%s' "$line" | sed 's/\\n/'"$NEWLINE_PLACEHOLDER"'/g' | cut -c1-$MENU_LINE_LENGTH)
  MENU+="$i. $DISPLAY_LINE\n"
  i=$((i + 1))
done < <(tac "$HISTORY_FILE") # most recent first

# Show Rofi menu
CHOICE=$(echo -e "$MENU" | rofi -dmenu -p "Clipboard (0-$MAX_ENTRIES):" -lines $((MAX_ENTRIES + 1)))
[ -z "$CHOICE" ] && exit 0

# Extract number
NUM=$(echo "$CHOICE" | awk -F. '{print $1}')

if [ "$NUM" = "0" ]; then
  # Clear clipboard by writing an empty string
  printf '' | write_clipboard
  >"$HISTORY_FILE"
  notify-send "📋 Clipboard Cleared"
  exit 0
fi

# Get selected snippet (raw stored with \n sequences)
RAW=$(tac "$HISTORY_FILE" | sed -n "${NUM}p")

# Convert literal "\n" into real newlines
SELECTED=$(printf '%b' "$RAW")

# Copy full text back to clipboard
printf '%s' "$SELECTED" | write_clipboard

# Notify user (single-line preview)
notify-send "📋 Clipboard Selected" "$(printf '%s' "$SELECTED" | head -c 100 | tr '\n' ' ')"
