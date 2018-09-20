#!/usr/bin/env bash

DIR=$(pwd)

setup_symlink () {
    if [ -f $2 ]; then
	echo "${2} already exists!"
    else
	ln -s $1 $2
    fi
}

echo "source ${DIR}/bash/.profile" >> ${HOME}/.bash_profile
echo "source ${DIR}/bash/.bashrc" >> ${HOME}/.bash_profile

# Symlink dot files
setup_symlink ${DIR}/atom ${HOME}/.atom
setup_symlink ${DIR}/bash/.inputrc ${HOME}/.inputrc
setup_symlink ${DIR}/hammerspoon ${HOME}/.hammerspoon
mkdir -p ${HOME}/.config && setup_symlink ${DIR}/karabiner ${HOME}/.config/karabiner
setup_symlink ${DIR}/tmux/.tmux.conf ${HOME}/.tmux.conf

# Vim
if command -v nvim >/dev/null 2>&1; then
    setup_symlink ${DIR}/vim ${HOME}/.config/nvim
else
    setup_symlink ${DIR}/vim ${HOME}/.vim
fi

git submodule update --init --recursive
vim "+PromptlineSnapshot ${HOME}/.shell_prompt.sh airline" +qall
source ${HOME}/.shell_prompt.sh
source ${DIR}/vim/fonts/install.sh