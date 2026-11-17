#!/bin/bash
# =============================================================================
# install-kitty.sh — Instalador de kitty con configuración personalizada
#
# Descarga e instala kitty (emulador de terminal de Kovid Goyal) desde el
# instalador oficial, crea los enlaces en ~/.local/bin, instala los archivos
# .desktop y aplica una configuración personalizada (opacidad de fondo).
#
# Uso:
#   curl -fsSL https://raw.githubusercontent.com/Richiestone18/install-kitty/main/install-kitty.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/Richiestone18/install-kitty/main/install-kitty.sh | sudo bash
#
# Requisitos: curl, sed, grep. No requiere privilegios de root (se instala en
# $HOME del usuario). Si se ejecuta con sudo, se usa el home del usuario
# original (SUDO_USER) y no el de root.
# =============================================================================
set -euo pipefail

# Detectar el usuario real y su home (funciona con o sin sudo)
REAL_USER="${SUDO_USER:-$(whoami)}"
REAL_HOME="$(getent passwd "$REAL_USER" | cut -d: -f6)"
if [ -z "$REAL_HOME" ] || [ ! -d "$REAL_HOME" ]; then
    echo "ERROR: no se pudo determinar el home de '$REAL_USER'" >&2
    exit 1
fi

export HOME="$REAL_HOME"

echo "[install-kitty] Usuario: $REAL_USER"
echo "[install-kitty] Home:    $REAL_HOME"

echo "[1/5] Instalando kitty (instalador oficial)..."
curl -L https://sw.kovidgoyal.net/kitty/installer.sh -o "$REAL_HOME/.cache/kitty-installer.sh"
sh "$REAL_HOME/.cache/kitty-installer.sh"

echo "[2/5] Creando enlaces en ~/.local/bin..."
mkdir -p "$REAL_HOME/.local/bin"
ln -sf "$REAL_HOME/.local/kitty.app/bin/kitty" "$REAL_HOME/.local/bin/kitty"
ln -sf "$REAL_HOME/.local/kitty.app/bin/kitten" "$REAL_HOME/.local/bin/kitten"

echo "[3/5] Instalando entradas de escritorio..."
mkdir -p "$REAL_HOME/.local/share/applications"
cp "$REAL_HOME/.local/kitty.app/share/applications/kitty.desktop" "$REAL_HOME/.local/share/applications/"
cp "$REAL_HOME/.local/kitty.app/share/applications/kitty-open.desktop" "$REAL_HOME/.local/share/applications/"
HOME_ABS=$(readlink -f "$REAL_HOME")
sed -i "s|Icon=kitty|Icon=${HOME_ABS}/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" "$REAL_HOME/.local/share/applications/kitty*.desktop"
sed -i "s|Exec=kitty|Exec=${HOME_ABS}/.local/kitty.app/bin/kitty|g" "$REAL_HOME/.local/share/applications/kitty*.desktop"

echo "[4/5] Aplicando configuración personalizada en ~/.config/kitty/kitty.conf..."
mkdir -p "$REAL_HOME/.config/kitty"
CONF="$REAL_HOME/.config/kitty/kitty.conf"

# background_opacity 0.75
if grep -q '^#* *background_opacity ' "$CONF"; then
    sed -i 's|^#* *background_opacity .*|background_opacity 0.75|' "$CONF"
else
    echo 'background_opacity 0.75' >> "$CONF"
fi

# dynamic_background_opacity yes
if grep -q '^#* *dynamic_background_opacity ' "$CONF"; then
    sed -i 's|^#* *dynamic_background_opacity .*|dynamic_background_opacity yes|' "$CONF"
else
    echo 'dynamic_background_opacity yes' >> "$CONF"
fi

echo "[5/5] Listo."
echo "Kitty instalado en: $(command -v kitty || echo "$REAL_HOME/.local/bin/kitty")"
echo "Configuración aplicada:"
grep -E '^(background_opacity|dynamic_background_opacity) ' "$CONF"
echo ""
echo "Atajos de opacidad (dentro de Kitty):"
echo "  Ctrl + Shift + A, luego M  -> aumentar opacidad"
echo "  Ctrl + Shift + A, luego L  -> disminuir opacidad"
echo "  Ctrl + Shift + A, luego 1  -> volver a opaco"
echo "  Ctrl + Shift + F5          -> recargar configuración sin cerrar la ventana"
echo ""
echo "Fuente: https://github.com/Richiestone18/install-kitty"
