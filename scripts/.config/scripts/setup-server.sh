#!/bin/bash

## run srp before running this

cd
# update and upgrade
sudo apt update && sudo apt upgrade

# basic software
sudo apt install tree stow less

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

git config --global user.email "2404385626@qq.com"
git config --global user.name "morethan987"

cd
# install pueue
curl -fsSL https://github.com/Nukesor/pueue/releases/latest/download/pueue-x86_64-unknown-linux-musl -o .local/bin/pueue
chmod +x .local/bin/pueue
curl -fsSL https://github.com/Nukesor/pueue/releases/latest/download/pueued-x86_64-unknown-linux-musl -o .local/bin/pueued
chmod +x .local/bin/pueued

# install omp
curl -fsSL https://omp.sh/install | sh
