# vim initialize globally 

> - preferred OS release: ubuntu 20
>- for users: all
> 
>- support language[s]: C/C++



## prerequisites

```
sudo apt -y update 
sudo apt -y upgrade 
sudo apt -y install git
egrep '^[^#].*\/etc\/vim\/vimrc.local' /etc/vim/vimrc &>/dev/null && sudo touch /etc/vim/vimrc.local || echo "warning, 'vimrc.local' not found in /etc/vim/vimrc.local"
```



## global vimrc config

```
cat <<- EOF > /etc/vim/vimrc.local
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible
set autoread
set nobackup
syntax enable
syntax on
set history=200
set hlsearch
set incsearch
set ignorecase smartcase
set paste


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Encoding
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set fileformat=unix
set fileformats=unix,dos,mac
set termencoding=utf-8


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" UI
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" indent & tab & wrap
set autoindent
set cindent
set smartindent
set smarttab
set tabstop=4
set softtabstop=4
set shiftround
set shiftwidth=4
set expandtab
set wrap

" status
set ruler
set nocursorline
set nocursorcolumn
set number
set showmode
set showmatch
set laststatus=2

" theme
set background=dark
colorscheme desert


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Control
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" backspace
set backspace=indent,eol,start
set whichwrap+=<,>,h,l

" mouse & keyboard
set mouse-=a
set selection=exclusive
set selectmode=mouse,key

EOF
```



## install plugin `VundleVim/Vundle.vim`

```
mkdir -p /etc/vim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git /etc/vim/bundle/Vundle.vim

cat <<-EOF >> /etc/vim/vimrc.local
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" plugin setup for Vundle globally
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" required
filetype off
" set the runtime path to include Vundle and initialize
set rtp+=/etc/vim/bundle/Vundle.vim
" the path where Vundle should install plugins
call vundle#begin('/etc/vim/bundle')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" All of your Plugins must be added before the following line
" required
call vundle#end()
" required
filetype plugin indent on
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

EOF

echo | echo | vim +PluginInstall +qall
```



## install plugin `Valloric/YouCompleteMe`

### prerequistes

```
# prerequistes
sudo apt -y update
sudo apt -y upgrade
sudo apt -y install build-essential cmake vim python3-dev clang

# download YCM
git clone https://github.com/ycm-core/YouCompleteMe.git /etc/vim/bundle/YouCompleteMe

# download YCM's dependencies, if skipped here then it would be installed later
cd /etc/vim/bundle/YouCompleteMe/
git submodule update --init --recursive
```

### install

```
cd /etc/vim/bundle/YouCompleteMe/

# test, if no errors, go next
python3 run_tests.py

# Compiling YCM with semantic support for C-family languages through libclang:
python3 install.py --clang-completer

# Compiling YCM with semantic support for C-family languages through experimental clangd:
# python3 install.py --clangd-completer

# Compiling YCM with semantic support for all languages
# python3 /install.py --all

# install plugin
grep "\" Vundle plugins" /etc/vim/vimrc.local &>/dev/null
if [[ $? -eq 0 ]]; then
	msg='" Vundle plugins'
	conf="Plugin 'Valloric/YouCompleteMe'"
    sed -i "/$msg/a$conf" /etc/vim/vimrc.local
fi

echo | echo | vim +PluginInstall +qall
```

### configure file for language :  C/C++

```
# get the include search list using ..., to substitute this for the following '-isystem'
echo | gcc -v -x c -E - | sed '/#include <...> search starts here/'

cat <<-EOF > /etc/vim/ycm_extra_conf.py
flags = [
'-Wall',
'-Wextra',
'-Werror',
'-Wno-long-long',
'-Wno-variadic-macros',
'-fexceptions',
'-ferror-limit=10000',
'-DNDEBUG',
# '-std=c++11',
'std=c99',
# '-x', 'c++',
'-x', 'c',
'-I','/usr/include',
'-isystem', '/usr/lib/gcc/x86_64-linux-gnu/7/include',
'-isystem', '/usr/local/include',
'-isystem', '/usr/lib/gcc/x86_64-linux-gnu/7/include-fixed',
'-isystem', '/usr/lib/gcc/x86_64-linux-gnu',
]

SOURCE_EXTENSIONS = [ '.cpp', '.cxx', '.cc', '.c', ]

def FlagForFile(filename, **kwargs):
    return {
        'flag': flags,
        'do_cache': True,
    }

EOF

# vimrc config
msg="Plugin 'Valloric\/YouCompleteMe'"
conf="let g:ycm_global_ycm_extra_conf='/etc/vim/ycm_extra_conf.py'"
grep "$msg" /etc/vim/vimrc.local &>/dev/null
if [[ $? -eq 0 ]]; then
    grep "$conf" /etc/vim/vimrc.local &>/dev/null
    if [[ $? -ne 0 ]]; then
    	sed -i "/$msg/a$conf" /etc/vim/vimrc.local
    fi
fi
```







