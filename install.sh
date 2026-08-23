#!/usr/bin/env bash

set -euo pipefail

DOTFILES="$HOME/dotfiles"

HOME_FOLDERS=(
  bash
  ghostty
  hypr
  mise
  nvim
)

SYSTEM_FOLDERS=(
  nixos
)

for folder in "${HOME_FOLDERS[@]}"; do
  stow \
    --dir="$DOTFILES" \
    --target="$HOME" \
    --restow \
    "$folder"
done

for folder in "${SYSTEM_FOLDERS[@]}"; do
  sudo stow \
    --dir="$DOTFILES" \
    --target=/ \
    --restow \
    "$folder"
done
