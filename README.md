# dotfiles

Mi configuración para **Windows** (Windows Terminal + PowerShell 7) y **Linux** (CachyOS con Hyprland + DankMaterialShell, foot, zsh + Oh My Zsh), con Starship, zoxide, eza, bat, lazygit, Neovim, fastfetch y JetBrains Mono Nerd Font.

## Estructura

```
dotfiles/
├── shared/                  # Igual en ambos sistemas
│   ├── starship.toml
│   ├── nvim/
│   ├── lazygit/config.yml   # (opcional)
│   └── bat/config           # (opcional)
├── windows/
│   ├── install.ps1
│   ├── packages.txt         # IDs de winget
│   ├── Microsoft.PowerShell_profile.ps1
│   └── terminal/settings-snippet.jsonc
└── linux/
    ├── install.sh
    ├── packages.txt         # paquetes de pacman
    ├── .zshrc
    ├── terminal-colors.txt  # paleta de la terminal (se imprime al abrir foot)
    ├── foot/foot.ini
    ├── fastfetch/config.jsonc
    ├── DankMaterialShell/settings.json   # ajustes de DMS (dock, barra, tema)
    └── hypr/                # configuración de Hyprland (Lua)
        ├── hyprland.lua     # punto de entrada
        ├── hyprland/        # keybinds, reglas, animaciones, input, etc.
        ├── dms/             # archivos que genera/usa DMS
        ├── scheme/          # colores base de Hyprland
        ├── variables.lua
        ├── hypr-vars.lua    # overrides de variables (cursor, etc.)
        └── hypr-user.lua    # extras propios
```

Los archivos marcados como opcionales se omiten si no existen.

## Instalación

### Windows

```powershell
git clone https://github.com/diegoa-mg/dotfiles $HOME\dotfiles
cd $HOME\dotfiles
Unblock-File .\windows\install.ps1
pwsh -ExecutionPolicy Bypass -File .\windows\install.ps1
```

Opciones:

- `-Copy` copia los archivos en vez de crear enlaces simbólicos.
- `-SkipPackages` no instala nada con winget.

Para crear enlaces simbólicos sin permisos de administrador, activa **Configuración → Sistema → Para desarrolladores → Modo de desarrollador**. Si no está activo, el script copia los archivos automáticamente.

La configuración de Windows Terminal no se instala sola: abre `windows/terminal/settings-snippet.jsonc` y copia lo que quieras a tu `settings.json` (`Ctrl+Shift+,`).

### Linux (Arch / CachyOS)

```bash
git clone https://github.com/diegoa-mg/dotfiles ~/dotfiles
cd ~/dotfiles
chmod +x linux/install.sh
./linux/install.sh            # o --skip-packages
```

El script instala los paquetes y enlaza `.zshrc`, foot, fastfetch, Neovim, Hyprland y los ajustes de DMS. **DankMaterialShell no está en `packages.txt`**: instálalo aparte siguiendo su documentación (en CachyOS suele estar en el AUR) y después inicia sesión en Hyprland; la config lo arranca con `dms run`.

Los atajos de teclado viven en `linux/hypr/hyprland/keybinds.lua` y casi todos llaman a DMS con `dms ipc call ...`.

## Cómo funciona

Los scripts crean **enlaces simbólicos** desde las rutas del sistema hacia el repo. Así, si editas `~/.config/starship.toml`, en realidad estás editando el archivo del repo, y solo tienes que hacer commit:

```bash
cd ~/dotfiles
git add -A && git commit -m "ajuste en starship" && git push
```

Si ya había un archivo en esa ruta, se respalda como `<archivo>.bak-<fecha>` antes de reemplazarlo.

## Personalizar (para quien lo reciba)

Los alias `cdd` y `cdc` del perfil apuntan a carpetas de mi PC. Edítalos con `psconf` (Windows) o en `.zshrc` (Linux) para que apunten a las tuyas.
