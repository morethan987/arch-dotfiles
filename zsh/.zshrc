# ====== Editor set  ======
export EDITOR=helix

# ====== zmv ======
# autoload -Uz zmv

# ====== Zsh Color Setup ======
autoload -U colors && colors

# Dracula 调色板
dracula_purple="%{$fg[magenta]%}"
dracula_green="%{$fg[green]%}"
dracula_cyan="%{$fg[cyan]%}"
dracula_yellow="%{$fg[yellow]%}"
dracula_pink="%{$fg_bold[magenta]%}"
dracula_white="%{$fg[white]%}"
reset_color="%{$reset_color%}"

# ====== Prompt ======
BG_PURPLE="%K{magenta}"
FG_BLACK="%F{black}"
RESET_ALL="%f%k"

PROMPT="${BG_PURPLE}${FG_BLACK} %n@%M ${RESET_ALL} ${dracula_white} %~ ${dracula_pink}❯ ${reset_color}"

# ====== History ======
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000
setopt HIST_IGNORE_DUPS HIST_REDUCE_BLANKS HIST_SAVE_NO_DUPS SHARE_HISTORY
unsetopt autocd

# ====== Completion ======
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

autoload -Uz compinit
fpath=(~/.zsh/completions $fpath)
compinit

# bun completions
[ -s "/home/morethan/.bun/_bun" ] && source "/home/morethan/.bun/_bun"

# ====== Keybindings ======
bindkey -v
bindkey -M viins 'jj' vi-cmd-mode
bindkey -M vicmd 'H' beginning-of-line
bindkey -M vicmd 'L' end-of-line

# ====== Aliases & Functions ======
if [[ -o interactive ]]; then
    [[ -f ~/.aliases ]] && source ~/.aliases

    FUNCTIONS_DIR="$HOME/.functions"

    if [[ -d "$FUNCTIONS_DIR" ]]; then
        for f in "$FUNCTIONS_DIR"/*.sh(N); do
            source "$f"
        done
    fi
fi

# ====== zoxide ======
eval "$(zoxide init --cmd cd zsh)"

# ====== Shell Applications ======
# custom
export PATH="/home/morethan/.local/bin:$PATH"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# sdkman
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
