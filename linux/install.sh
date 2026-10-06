#!/usr/bin/env bash
# Instala la configuración de terminal en Linux (probado pensando en Arch/CachyOS).
# Uso: ./linux/install.sh [--skip-packages]
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKIP_PACKAGES=false
[[ "${1:-}" == "--skip-packages" ]] && SKIP_PACKAGES=true

step() { printf '\n\033[36m==> %s\033[0m\n' "$1"; }

# --- 1. Paquetes --------------------------------------------------------------
if ! $SKIP_PACKAGES; then
  if command -v pacman >/dev/null; then
    step "Instalando paquetes con pacman"
    mapfile -t pkgs < <(sed 's/#.*//; /^\s*$/d' "$ROOT/linux/packages.txt")
    sudo pacman -S --needed --noconfirm "${pkgs[@]}"
  else
    echo "No se encontró pacman. Instala a mano los paquetes de linux/packages.txt."
  fi

  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    step "Instalando Oh My Zsh"
    RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi
fi

# --- 2. Enlaces ---------------------------------------------------------------
link() {
  local src="$1" dst="$2"
  [[ -e "$src" ]] || return 0                       # opcional: se omite si no existe
  mkdir -p "$(dirname "$dst")"

  if [[ -L "$dst" && "$(readlink -f "$dst")" == "$(readlink -f "$src")" ]]; then
    printf '  ok   %s (ya enlazado)\n' "$dst"; return 0
  fi
  if [[ -e "$dst" || -L "$dst" ]]; then
    local bak="$dst.bak-$(date +%Y%m%d%H%M%S)"
    mv "$dst" "$bak"; printf '  bak  %s\n' "$bak"
  fi
  ln -s "$src" "$dst"; printf '  ->   %s\n' "$dst"
}

step "Instalando configuración"
link "$ROOT/linux/.zshrc"              "$HOME/.zshrc"
link "$ROOT/linux/foot/foot.ini"       "$HOME/.config/foot/foot.ini"
# link "$ROOT/shared/starship.toml"      "$HOME/.config/starship.toml"
link "$ROOT/shared/nvim"               "$HOME/.config/nvim"
link "$ROOT/shared/lazygit/config.yml" "$HOME/.config/lazygit/config.yml"
link "$ROOT/shared/bat/config"         "$HOME/.config/bat/config"

# --- 3. Shell por defecto -----------------------------------------------------
if [[ "$(basename "${SHELL:-}")" != "zsh" ]] && command -v zsh >/dev/null; then
  step "Cambiando shell por defecto a zsh"
  chsh -s "$(command -v zsh)"
fi

printf '\n\033[32mListo. Abre una terminal nueva.\033[0m\n'
