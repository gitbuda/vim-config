#!/bin/bash -e

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

run_time=$(date -u +'%Y-%m-%d_%H-%M-%S')

# Link vim folder.
if [ ! -L ~/.vim ]; then
    echo "There is no a sym link to the vim folder. Backup and create one."
    if [ -d ~/.vim ]; then
        mv ~/.vim ~/.vim-backup__${run_time}
    fi
    ln -s ${script_dir}/vim ~/.vim
fi

# Link vimrc file.
if [ ! -L ~/.vimrc ]; then
    echo "There is no a sym link to the vimrc. Backup and create one."
    if [ -f ~/.vimrc ]; then
        mv ~/.vimrc ~/.vimrc-backup__${run_time}
    fi
    ln -s ${script_dir}/vimrc ~/.vimrc
fi

# Install plugins.
mkdir -p ~/.vim/autoload ~/.vim/bundle
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

if [ ! -d ~/.vim/bundle/vim-colors-solarized ]; then
    git clone git://github.com/altercation/vim-colors-solarized.git ~/.vim/bundle/vim-colors-solarized
fi

if [ ! -d ~/.vim/bundle/syntastic ]; then
    git clone https://github.com/scrooloose/syntastic.git ~/.vim/bundle/syntastic
fi

if [ ! -d ~/.vim/bundle/coc.nvim ]; then
    git clone https://github.com/neoclide/coc.nvim ~/.vim/bundle/coc.nvim
    cd ~/.vim/bundle/coc.nvim
    ./install.sh
    cd ${script_dir}
fi

if [ ! -d ~/.vim/bundle/vim-airline ]; then
    git clone https://github.com/bling/vim-airline ~/.vim/bundle/vim-airline
    # Airline fonts
    mkdir -p ~/Workspace/programs/fonts
    git clone https://github.com/powerline/fonts ~/Workspace/programs/fonts
    cd ~/Workspace/programs/fonts
    ./install.sh
    # Pick -> Ubuntu Mono derivative Powerline Regular as a terminal font!
fi

if [ ! -d ~/.vim/bundle/vim-airline-themes ]; then
    git clone https://github.com/vim-airline/vim-airline-themes ~/.vim/bundle/vim-airline-themes
fi

if [ ! -d ~/.vim/bundle/nerdtree ]; then
    git clone https://github.com/scrooloose/nerdtree.git ~/.vim/bundle/nerdtree
fi

if [ ! -d ~/.vim/bundle/vim-nerdtree-tabs ]; then
    # NOTE: No longer actively maintained.
    git clone https://github.com/jistr/vim-nerdtree-tabs.git ~/.vim/bundle/vim-nerdtree-tabs
fi

if [ ! -d ~/.vim/bundle/ctrlp.vim ]; then
    git clone https://github.com/ctrlpvim/ctrlp.vim.git ~/.vim/bundle/ctrlp.vim
fi

if [ ! -d ~/.vim/bundle/vim-ctrlp-tjump ]; then
    git clone https://github.com/ivalkeen/vim-ctrlp-tjump.git ~/.vim/bundle/vim-ctrlp-tjump
fi

if [ ! -d ~/.vim/bundle/vim-fugitive ]; then
    git clone git://github.com/tpope/vim-fugitive.git ~/.vim/bundle/vim-fugitive
fi

if [ ! -d ~/.vim/bundle/vim-gitgutter ]; then
    git clone git://github.com/airblade/vim-gitgutter.git ~/.vim/bundle/vim-gitgutter
fi

if [ ! -d ~/.vim/bundle/jedi-vim ]; then
    git clone --recursive https://github.com/davidhalter/jedi-vim.git ~/.vim/bundle/jedi-vim
fi

if [ ! -d ~/.vim/bundle/vim-flake8 ]; then
    git clone https://github.com/nvie/vim-flake8.git ~/.vim/bundle/vim-flake8
fi

if [ ! -d ~/.vim/bundle/vim-bufsurf ]; then
    git clone https://github.com/ton/vim-bufsurf ~/.vim/bundle/vim-bufsurf
fi

if [ ! -d ~/.vim/bundle/vim-clang-format ]; then
    git clone https://github.com/rhysd/vim-clang-format.git ~/.vim/bundle/vim-clang-format
fi

if [ ! -d ~/.vim/bundle/vim-autopep8 ]; then
    git clone https://github.com/tell-k/vim-autopep8.git ~/.vim/bundle/vim-autopep8
fi

if [ ! -d ~/.vim/bundle/tagbar ]; then
    git clone https://github.com/majutsushi/tagbar.git ~/.vim/bundle/tagbar
fi

if [ ! -d ~/.vim/bundle/vim-windowswap ]; then
    git clone https://github.com/wesQ3/vim-windowswap.git ~/.vim/bundle/vim-windowswap
fi

if [ ! -d ~/.vim/bundle/ack.vim ]; then
    git clone https://github.com/mileszs/ack.vim.git ~/.vim/bundle/ack.vim
fi

if [ ! -d ~/.vim/bundle/vim-closetag ]; then
    git clone https://github.com/alvan/vim-closetag.git ~/.vim/bundle/vim-closetag
fi

if [ ! -d ~/.vim/bundle/vim-codefmt ]; then # Depends on vim-maktaba.
    git clone https://github.com/google/vim-codefmt.git ~/.vim/bundle/vim-codefmt
fi

if [ ! -d ~/.vim/bundle/vim-maktaba ]; then
    git clone https://github.com/google/vim-maktaba.git ~/.vim/bundle/vim-maktaba
fi

if [ ! -d ~/.vim/bundle/vim-autoformat ]; then
    git clone https://github.com/Chiel92/vim-autoformat ~/.vim/bundle/vim-autoformat
fi

if [ ! -d ~/.vim/bundle/vim-javascript ]; then
    git clone https://github.com/pangloss/vim-javascript.git ~/.vim/bundle/vim-javascript
fi

if [ ! -d ~/.vim/bundle/typescript-vim ]; then
    git clone https://github.com/leafgarland/typescript-vim.git ~/.vim/bundle/typescript-vim
fi

if [ ! -d ~/.vim/bundle/vim-js-indent ]; then
    git clone https://github.com/jason0x43/vim-js-indent.git ~/.vim/bundle/vim-js-indent
fi

if [ ! -d ~/.vim/bundle/vimproc.vim ]; then
    git clone https://github.com/Shougo/vimproc.vim.git ~/.vim/bundle/vimproc.vim
    cd ~/.vim/bundle/vimproc.vim
    make
    cd ${script_dir}
fi

if [ ! -d ~/.vim/bundle/tsuquyomi ]; then
    git clone https://github.com/Quramy/tsuquyomi.git ~/.vim/bundle/tsuquyomi
fi

if [ ! -d ~/.vim/bundle/vim-better-whitespace ]; then
    git clone https://github.com/ntpeters/vim-better-whitespace ~/.vim/bundle/vim-better-whitespace
fi

