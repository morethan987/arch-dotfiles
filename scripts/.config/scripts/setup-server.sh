#!/bin/bash

## run srp before running this

cd
# update and upgrade
apt update && apt upgrade

# basic software
apt -y --no-upgrade install tree stow less rsync netcat-openbsd

# proxy
export http_proxy=http://127.0.0.1:51847
export https_proxy=http://127.0.0.1:51847

# install uv and LSPs
curl -LsSf https://astral.sh/uv/install.sh | sh
uv tool install ty@latest
uv tool install ruff@latest

# config files
git clone --branch headless https://github.com/morethan987/arch-dotfiles.git dotfiles
mkdir backup
mv .bashrc .profile backup/ 2>/dev/null || true
mkdir -p ~/.config ~/.local/bin ~/.local/share
cd dotfiles
stow bash vim helix
cd && source .bashrc

# install helix
mkdir -p ~/.local/bin ~/.local/share/helix ~/.config/helix
DOWNLOAD_URL=$(curl -s https://api.github.com/repos/helix-editor/helix/releases/latest \
  | grep -o 'https://[^"]*x86_64-linux\.tar\.xz' \
  | head -n 1)
curl -fL "$DOWNLOAD_URL" | tar -xJ --strip-components=1 -C ~/.local/share/helix
ln -sf ~/.local/share/helix/hx ~/.local/bin/hx
ln -sfn ~/.local/share/helix/runtime ~/.config/helix/runtime
hx --version

git config --global user.email "2404385626@qq.com"
git config --global user.name "morethan987"

# github cli
(type -p wget >/dev/null || (apt update && apt install wget -y)) \
	&& mkdir -p -m 755 /etc/apt/keyrings \
	&& out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
	&& cat $out | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& mkdir -p -m 755 /etc/apt/sources.list.d \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& apt update \
	&& apt install gh -y
gh --version
gh auth login

# or generate ssh key by yourself
# name your file as github
ssh-keygen -t rsa -b 4096 -C "2404385626@qq.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/github
cat >> ~/.ssh/config <<'EOF'
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/github
EOF

cd
# install pueue
curl -fsSL https://github.com/Nukesor/pueue/releases/latest/download/pueue-x86_64-unknown-linux-musl -o .local/bin/pueue
chmod +x .local/bin/pueue
curl -fsSL https://github.com/Nukesor/pueue/releases/latest/download/pueued-x86_64-unknown-linux-musl -o .local/bin/pueued
chmod +x .local/bin/pueued

# install zoxide
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# install mise
curl -fsSL https://mise.run | sh

# fix /etc/environment not loaded
# usually caused by docker container
sudo sh -c 'echo "set -a; [ -f /etc/environment ] && . /etc/environment; set +a" > /etc/profile.d/load_env.sh'

# install omp
curl -fsSL https://omp.sh/install | sh
