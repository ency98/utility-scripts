#!/usr/bin/env bash

# Generates 24 random 64-character hexadecimal strings and lets user select one to copy

# Colors
GREEN="\033[0;32m"
BOLD="\033[1m"
NC="\033[0m"

# Generate and display
echo -e "${BOLD}Generated Keys:${NC}"
for i in {1..24}; do
  hex=$(openssl rand -hex 32)  # 32 bytes = 64 hex digits
  printf "%2d) %s\n" "$i" "$hex"
  keys[i]="$hex"
done

# Prompt
echo
read -p "Select a key to copy [1-24]: " choice

# Validate and copy
if [[ "$choice" =~ ^[1-9]$|^1[0-9]$|^2[0-4]$ ]]; then
  selected="${keys[$choice]}"
  echo -e "\n${GREEN}You selected:${NC}\n$selected"

  # Copy to clipboard
  if command -v pbcopy &>/dev/null; then
    echo -n "$selected" | pbcopy
    echo -e "${GREEN}Copied to clipboard (macOS)!${NC}"
  elif command -v xclip &>/dev/null; then
    echo -n "$selected" | xclip -selection clipboard
    echo -e "${GREEN}Copied to clipboard (xclip/Linux)!${NC}"
  elif command -v wl-copy &>/dev/null; then
    echo -n "$selected" | wl-copy
    echo -e "${GREEN}Copied to clipboard (wl-copy/Wayland)!${NC}"
  else
    echo -e "${BOLD}Clipboard tool not found.${NC} Please copy manually."
  fi
else
  echo -e "${BOLD}Invalid selection.${NC} Exiting."
  exit 1
fi
