# ====== zmv ======
# autoload -Uz zmv

# ====== Zsh Color Setup ======
autoload -U colors && colors

# Dracula 调色板
purple="%{$fg[magenta]%}"
green="%{$fg[green]%}"
cyan="%{$fg[cyan]%}"
yellow="%{$fg[yellow]%}"
pink="%{$fg_bold[magenta]%}"
white="%{$fg[white]%}"
reset_color="%{$reset_color%}"

# ====== Prompt ======
export VIRTUAL_ENV_DISABLE_PROMPT=1
setopt prompt_subst

top_corner="╭─"
bottom_corner="╰─"

VENV_PART='${VIRTUAL_ENV_PROMPT:+${green}(${VIRTUAL_ENV_PROMPT}) }'

PROMPT="${purple}${top_corner} ${VENV_PART}${white}%n@%m ${yellow} ${white}%~${reset_color}"$'\n'
PROMPT+="${purple}${bottom_corner}${pink}❯ ${reset_color}"

# ====== Basics ======
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000
setopt HIST_IGNORE_DUPS HIST_REDUCE_BLANKS HIST_SAVE_NO_DUPS SHARE_HISTORY
unsetopt autocd beep

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
    --bind=alt-j:half-page-down,alt-k:half-page-up
  '
fi

# ====== navi ======
if command -v navi >/dev/null 2>&1; then
  eval "$(navi widget zsh)"
fi

# ====== mise ======
# 判断 mise 是否已安装 且 当前用户不是 root
if command -v mise &> /dev/null && [[ $EUID -ne 0 ]]; then
  eval "$(mise activate zsh --shims)"
fi

# ====== posener/complete ======
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /home/morethan/.local/bin/srp srp

# ====== envs ======
export PATH="/home/morethan/.local/bin:$PATH"
export GPG_TTY=$(tty)
