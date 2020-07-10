#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# see if zsh is installed
zsh_installed=`which zsh`

if [[ $zsh_installed != *"zsh"* ]]; then
    brew install zsh
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

ln -s "$DIR/zshrc" "$HOME/.zshrc.proposed"
