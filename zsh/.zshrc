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
top_corner="╭─"
bottom_corner="╰─"

PROMPT="${dracula_purple}${top_corner} ${dracula_white}%n@%m ${dracula_yellow} ${dracula_white}%~${reset_color}"$'\n'
PROMPT+="${dracula_purple}${bottom_corner}${dracula_pink}❯ ${reset_color}"

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
        # 1. 把目录加入 Zsh 的函数搜索路径 (fpath)
        fpath=("$FUNCTIONS_DIR" $fpath)

        # 2. 遍历目录下的所有文件，并登记为 autoload
        # (N-.) 表示：N(如果目录为空不报错), -(如果是符号链接则指向原文件), .(只匹配普通文件)
        # :t 表示只取文件名（tail），不取路径
        for f in "$FUNCTIONS_DIR"/*(N-.); do
            autoload -Uz "${f:t}"
        done
    fi
fi

# ====== zoxide ======
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init --cmd cd zsh)"
fi

# ====== fzf ======
if command -v fzf &> /dev/null; then
  source <(fzf --zsh)
  export FZF_DEFAULT_OPTS='
    --bind=alt-j:down,alt-k:up
  '
fi

# ====== mise ======
# 判断 mise 是否已安装 且 当前用户不是 root
if command -v mise &> /dev/null && [[ $EUID -ne 0 ]]; then
  eval "$(mise activate zsh)"
fi

# ====== Shell Applications ======
# custom
export PATH="/home/morethan/.local/bin:$PATH"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

