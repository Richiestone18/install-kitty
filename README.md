# install-kitty

Instalador de [kitty](https://sw.kovidgoyal.net/kitty/) (emulador de terminal de
Kovid Goyal) con configuración personalizada para Linux.

## Uso rápido

Como usuario normal (recomendado):

```bash
curl -fsSL https://raw.githubusercontent.com/Richiestone18/install-kitty/main/install-kitty.sh | bash
```

O con sudo (el script respeta el home del usuario original mediante `SUDO_USER`):

```bash
curl -fsSL https://raw.githubusercontent.com/Richiestone18/install-kitty/main/install-kitty.sh | sudo bash
```

## Qué hace el script

1. Descarga y ejecuta el instalador oficial de kitty en `~/.local/kitty.app`.
2. Crea los enlaces `kitty` y `kitten` en `~/.local/bin`.
3. Instala los archivos `.desktop` en `~/.local/share/applications/` con rutas
   absolutas (`Exec` e `Icon`) para que aparezcan en el menú de aplicaciones.
4. Escribe en `~/.config/kitty/kitty.conf`:
   - `background_opacity 0.75`
   - `dynamic_background_opacity yes`

## Atajos de opacidad (dentro de kitty)

| Secuencia | Acción |
|-----------|--------|
| `Ctrl + Shift + A`, luego `M` | Aumentar opacidad |
| `Ctrl + Shift + A`, luego `L` | Disminuir opacidad |
| `Ctrl + Shift + A`, luego `1` | Volver a opaco (1.0) |
| `Ctrl + Shift + F5` | Recargar configuración sin cerrar la ventana |

## Requisitos

- `curl`, `sed`, `grep`, `bash`
- No se requiere root: todo se instala en el `$HOME` del usuario.
- Si se ejecuta con `sudo`, el script usa el home del usuario original
  (`$SUDO_USER`) y no el de root.

## Origen

Basado en el archivo `kitty install.txt` con los pasos de instalación y
configuración de kitty.

## Licencia

Uso libre. Modifícalo a tu gusto.
