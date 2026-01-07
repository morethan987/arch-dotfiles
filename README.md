# Dotfiles

A folder for my Arch dotfiles.

## Requirements

Ensure the following is installed.

### Git

```shell
sudo pacman -S git
```

### Stow

```shell
sudo pacman -S stow
```

## How to use

Check out the dotfiles in $HOME directory using git.

> Before run the following cmd, ensure you are in the root directory of dotfiles. 

```shell
# via ssh if you need to push modification back to remote repo
# note that you should config the .ssh before run the cmd
git clone git@github.com:morethan987/arch-dotfiles.git dotfiles

# or via http if you just use the dotfiles
git clone https://github.com/morethan987/arch-dotfiles.git dotfiles

cd dotfiles
```

Use GNU stow to create symlinks for specific software.

```shell
# create zsh dotfiles
stow zsh

# create several dotfiles
stow zsh helix opencode
```

If get something wrong, simply undo it.

```shell
stow -D zsh
```
