<#
.SYNOPSIS
    Instala la configuración de terminal en Windows.
.DESCRIPTION
    Instala los paquetes de windows/packages.txt con winget y enlaza (o copia)
    los archivos de configuración del repo a su ubicación en el sistema.
    Si ya existe un archivo, se respalda como <archivo>.bak-<fecha> antes de reemplazarlo.
.PARAMETER Copy
    Copia los archivos en lugar de crear enlaces simbólicos.
.PARAMETER SkipPackages
    No instala paquetes con winget.
.EXAMPLE
    pwsh -ExecutionPolicy Bypass -File .\windows\install.ps1
.EXAMPLE
    pwsh -ExecutionPolicy Bypass -File .\windows\install.ps1 -Copy -SkipPackages
#>
param(
    [switch]$Copy,
    [switch]$SkipPackages
)

$ErrorActionPreference = 'Stop'
$Root = Split-Path $PSScriptRoot -Parent

function Write-Step($msg) { Write-Host "`n==> $msg" -ForegroundColor Cyan }

# --- 0. Verificar PowerShell 7 ----------------------------------------------
if ($PSVersionTable.PSVersion.Major -lt 7) {
    Write-Warning "Estás en Windows PowerShell $($PSVersionTable.PSVersion). Este script necesita PowerShell 7 (pwsh)."
    if (-not $SkipPackages) {
        winget install --id Microsoft.PowerShell -e --accept-source-agreements --accept-package-agreements
    }
    Write-Host "Abre una terminal nueva con 'pwsh' y vuelve a ejecutar el script." -ForegroundColor Yellow
    exit 1
}

# --- 1. Paquetes --------------------------------------------------------------
if (-not $SkipPackages) {
    Write-Step "Instalando paquetes con winget"
    $packages = Get-Content "$PSScriptRoot\packages.txt" |
        ForEach-Object { ($_ -split '#')[0].Trim() } |
        Where-Object { $_ }

    foreach ($id in $packages) {
        Write-Host "  - $id"
        winget install --id $id -e --silent --accept-source-agreements --accept-package-agreements | Out-Null
    }
}

# --- 2. Execution policy ------------------------------------------------------
$policy = Get-ExecutionPolicy -Scope CurrentUser
if ($policy -in 'Undefined', 'Restricted', 'AllSigned') {
    Write-Step "Ajustando execution policy (CurrentUser -> RemoteSigned)"
    Set-ExecutionPolicy -Scope CurrentUser RemoteSigned -Force
}

# --- 3. Enlaces ---------------------------------------------------------------
$canSymlink = -not $Copy

function Install-Config {
    param([string]$Source, [string]$Target)

    if (-not (Test-Path $Source)) { return }   # opcional: si no está en el repo, se omite

    Get-ChildItem $Source -Recurse -File -ErrorAction SilentlyContinue | Unblock-File

    New-Item -ItemType Directory -Force (Split-Path $Target -Parent) | Out-Null

    $existing = Get-Item $Target -Force -ErrorAction SilentlyContinue
    if ($existing) {
        if ($existing.LinkType -eq 'SymbolicLink' -and
            (Resolve-Path $existing.Target -ErrorAction SilentlyContinue).Path -eq (Resolve-Path $Source).Path) {
            Write-Host "  ok   $Target (ya enlazado)" -ForegroundColor DarkGray
            return
        }
        $backup = "$Target.bak-$(Get-Date -Format yyyyMMddHHmmss)"
        Move-Item $Target $backup -Force
        Write-Host "  bak  $backup" -ForegroundColor Yellow
    }

    if ($script:canSymlink) {
        try {
            New-Item -ItemType SymbolicLink -Path $Target -Target $Source | Out-Null
            Write-Host "  ->   $Target" -ForegroundColor Green
            return
        } catch {
            Write-Warning "No se pudo crear el enlace simbólico (activa el Modo de desarrollador o ejecuta como admin). Se copiarán los archivos."
            $script:canSymlink = $false
        }
    }

    Copy-Item $Source $Target -Recurse -Force
    Write-Host "  cp   $Target" -ForegroundColor Green
}

Write-Step "Instalando configuración"
Install-Config "$Root\windows\Microsoft.PowerShell_profile.ps1" $PROFILE.CurrentUserCurrentHost
Install-Config "$Root\shared\starship.toml"                   "$HOME\.config\starship.toml"
Install-Config "$Root\shared\nvim"                            "$env:LOCALAPPDATA\nvim"
Install-Config "$Root\shared\lazygit\config.yml"              "$env:LOCALAPPDATA\lazygit\config.yml"
Install-Config "$Root\shared\bat\config"                      "$env:APPDATA\bat\config"

# --- 4. Windows Terminal (manual) ---------------------------------------------
Write-Step "Windows Terminal"
Write-Host "  Copia a mano lo que quieras de windows\terminal\settings-snippet.jsonc"
Write-Host "  a tu settings.json (Ctrl+Shift+, dentro de Windows Terminal)."

Write-Host "`nListo. Reinicia la terminal para cargar el perfil." -ForegroundColor Green
