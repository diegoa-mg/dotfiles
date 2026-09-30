# ============================================================
#  Perfil de PowerShell 7 — réplica del .zshrc de CachyOS
#  Ubicación: nvim $PROFILE
# ============================================================

# ---------- Prompt: Starship (lee ~/.config/starship.toml, igual que en Linux) ----------
Invoke-Expression (&starship init powershell)

# ---------- zoxide ----------
Invoke-Expression (& { (zoxide init powershell | Out-String) })

# ---------- Autosugerencias + autocompletado + syntax highlighting ----------
# (equivalente a zsh-autosuggestions, zsh-autocomplete y zsh-syntax-highlighting)
Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle InlineView      # texto gris como en zsh; cambia a ListView si prefieres lista
Set-PSReadLineOption -EditMode Emacs                      # atajos tipo shell de Linux (Ctrl+A, Ctrl+E, Ctrl+W...)
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete  # menú de autocompletado con Tab
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key RightArrow -Function ForwardChar  # → acepta la sugerencia

# ---------- Quitar alias nativos de PowerShell que chocan con los tuyos ----------
# En PowerShell los alias tienen prioridad sobre las funciones, así que hay que borrarlos.
foreach ($a in 'ls','cat','gc','gl','gp','gcb','gbp') {
    if (Test-Path "Alias:$a") { Remove-Item "Alias:$a" -Force -ErrorAction SilentlyContinue }
}

# ---------- Navegación rápida hacia atrás ----------
function ..   { Set-Location .. }
function ...  { Set-Location ..\.. }
function .... { Set-Location ..\..\.. }

# ---------- Navegación rápida entre carpetas ----------


# ---------- Editar configuraciones rápido ----------
function psconf { nvim $PROFILE }   # equivalente a zshconf
function wtconf { nvim "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" }  # equivalente a footconf

# ---------- Recargar el perfil ----------
function reload { . $PROFILE; Write-Host "¡Configuración de PowerShell actualizada!" -ForegroundColor Green }

# ---------- eza ----------
$ezaBase = @('--color=always', '--group-directories-first', '--icons=always')
function ls { eza @ezaBase @args }
function la { eza -a @ezaBase @args }
function ll { eza -l @ezaBase @args }
function lt { eza -aT @ezaBase @args }
function l. {
    $dot = Get-ChildItem -Force -Name | Where-Object { $_ -like '.*' }
    if ($dot) { eza -d --icons=always @dot }
}

# ---------- cat / bat ----------
function cat { bat @args }

# ---------- Neovim ----------
Set-Alias vim nvim

# ---------- git ----------
function lg  { lazygit @args }
function gd  { git diff @args }
function ga  { git add . }
function gc  { git commit -am @args }
function gl  { git log @args }
function gs  { git status @args }
function gst { git stash @args }
function gsp { git stash pop @args }
function gp  { git push @args }
function gpl { git pull @args }
function gsw { git switch @args }
function gsm { git switch main }
function gb  { git branch @args }
function gbd { git branch -d @args }
function gco { git checkout @args }
function gsh { git show @args }
