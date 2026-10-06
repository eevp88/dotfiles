#!/usr/bin/env bash
# System-level setup that Stow cannot manage (files outside $HOME).
# Idempotent: only runs sudo when something actually needs to change.

set -euo pipefail

LOCALE="es_CL.UTF-8"

# Tools this script relies on (Arch package name : binary).
declare -A DEPS=([ripgrep]=rg [sd]=sd)
missing=()
for pkg in "${!DEPS[@]}"; do
  command -v "${DEPS[$pkg]}" >/dev/null 2>&1 || missing+=("$pkg")
done
if [ "${#missing[@]}" -gt 0 ]; then
  echo "Installing: ${missing[*]}"
  sudo pacman -S --needed --noconfirm "${missing[@]}"
fi

if ! locale -a | rg -qi "^${LOCALE/UTF-8/utf8}$"; then
  echo "Generating locale $LOCALE"
  sudo sd "^#\s*(${LOCALE} UTF-8)" '$1' /etc/locale.gen
  sudo locale-gen
fi

if [ "$(localectl status | rg -o 'LANG=\S+')" != "LANG=$LOCALE" ]; then
  echo "Setting system locale to $LOCALE"
  sudo localectl set-locale "LANG=$LOCALE"
fi

echo "System setup done."
