# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Plugins
plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-autocomplete)
source $ZSH/oh-my-zsh.sh

if [[ -z "$CAELESTIA_COLORS_LOADED" ]]; then
    export CAELESTIA_COLORS_LOADED=1
    [[ -r ~/.local/state/caelestia/sequences.txt ]] && \
        cat ~/.local/state/caelestia/sequences.txt
fi

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# Aliases útiles

# Navegación rápida hacia atrás
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Navegación rápida entre carpetas
alias cdd='z ~/Downloads'
alias cdc='z ~/Documents/CODE'
alias cdhypr='z ~/.config/hypr/hyprland/'

# Editar configuraciones rápido
alias zshconf='nvim ~/.zshrc'
alias fishconf='nvim /usr/share/cachyos-fish-config/cachyos-config.fish'
alias footconf='nvim ~/.config/foot/foot.ini'

# Recargar Zsh al instante tras un cambio
alias reload='source ~/.zshrc && echo "¡Configuración de Zsh actualizada!"'

# Editar la configuración base de SDDM
alias sddmconf='sudo nvim /etc/sddm.conf'

# eza
alias ls='eza --color=always --group-directories-first --icons=always' # preffered listing
alias la='eza -a --color=always --group-directories-first --icons=always' # all files and dirs
alias ll='eza -l --color=always --group-directories-first --icons=always' # long format
alias lt='eza -aT --color=always --group-directories-first --icons=always' # tree listing
#alias lla='eza -lah --color=always --group-diretories-first --icons=always'
alias l.="eza -a --icons=always | grep -e '^\.'" # show only dotfiles

# cat / bat
alias cat='bat'
# github
alias lg='lazygit'

alias gd='git diff'
alias ga='git add .'
alias gc='git commit -am'
alias gl='git log'
alias gs='git status'
alias gst='git stash'
alias gsp='git stash pop'
alias gp='git push'
alias gpl='git pull'
alias gsw='git switch'
alias gsm='git switch main'
alias gb='git branch'
alias gbd='git branch -d'
alias gco='git checkout'
alias gsh='git show'

# Confirmaciones de seguridad para no borrar o mover cosas por error
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Copiar el output de cualquier comando al portapapeles directamente
alias clip='wl-copy'
# ej: cat ~/.zshrc | clip
#
# Vacía el portapapeles y reinicia el contador de capturas/textos a 1
alias clearclip='cliphist wipe && rm -f ~/.cache/cliphist/db && echo "¡Portapapeles vaciado y contador reiniciado!"'

# Actualizar el sistema completo y refrescar los mirrors más rápidos de un tirón
alias update='sudo cachyos-rate-mirrors && sudo pacman -Syu'

# Limpieza profunda de paquetes huérfanos (basura que se queda al desinstalar apps)
alias cleanup='sudo pacman -Rns $(pacman -Qtdq)'

# Ver los errores más recientes del sistema (journalctl) sin rodeos
alias jctl='journalctl -p 3 -xb'

# Muestra un resumen rápido del hardware de tu PC (procesador, gráfica, etc.)
alias hw='hwinfo --short'

# Lista los paquetes instalados ordenados por los que más espacio ocupan en MB (necesita 'expac')
alias big="expac -H M '%m\t%n' | sort -h | nl"

# Muestra los últimos 200 paquetes que has instalado o actualizado en orden cronológico
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"

# Probar los cambios del tema SDDM en una ventana flotante sin cerrar sesión
alias testsddm='./test.sh'

# Editar config de modulos de kernel y arranque
alias grubconf='sudo nvim /etc/default/grub'
alias initconf='sudo nvim /etc/mkinitcpio.conf'

export PATH="$HOME/.local/bin:$PATH"

# abrir phpmyadmin
# alias db='/usr/local/bin/firefox-dev -P dev-edition-default http://localhost/phpmyadmin'

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Bienvenida caelestia
caelestia_greeting() {
    print -P "%F{16}"
    command cat <<'EOF'
     ______           __          __  _       
    / ____/___ ____  / /__  _____/ /_(_)___ _ 
   / /   / __ `/ _ \/ / _ \/ ___/ __/ / __ `/ 
  / /___/ /_/ /  __/ /  __(__  ) /_/ / /_/ /  
  \____/\__,_/\___/_/\___/____/\__/_/\__,_/   
EOF

    print -P "%f"

    command -v fastfetch >/dev/null && fastfetch --key-padding-left 5
}

# Iniciar con fastfetch
if [[ -o interactive ]]; then
    caelestia_greeting
fi


# Added by Antigravity CLI installer
export PATH="/home/diego/.local/bin:$PATH"
