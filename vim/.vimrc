" File:   .smallvimrc
" Author: liguangsheng
" Date:   2020-03-23
" 
" This is a small .vimrc configuration without plugin.

" Generic
set nocompatible

syntax on                       " Syntax highlighting
filetype on
filetype plugin on
filetype indent on
" set autochdir                    " 自动cd到当前目录
" set relativenumber               " 显示相对行号
" set cursorline                   " 高亮当前行
" set cursorcolumn                 " 高亮当前列
" set cc=80                        " 高亮第80列
set backspace=indent,eol,start     " 退格键可以跨越空白字符
set history=1024                   " 历史命令记录数量
set confirm                        " 在处理未保存或只读文件的时候要求确认
set nobackup                       " 不备份文件
set noswapfile                     " 不生成swap文件
set bufhidden=hide                 " 当buffer被丢弃时隐藏
set linespace=1                    " 插入的像素行数目
set wildmenu                       " 增强模式中的命令自动完成操作
set whichwrap+=<,>,h,l             " 允许退格键和方向键跨越行边界
set shortmess=atl                  " 不显示欢迎画面
set report=0                       " 报告哪一行被修改过
set noerrorbells                   " 关闭警告声
set scrolloff=3                    " 移动时顶部和底部保持距离
set laststatus=2                   " 总是显示状态行
set showcmd                        " 显示输入的命令
set autoread                       " 自动重新读入
set nu!                            " 显示行号
set clipboard^=unnamed,unnamedplus " 共享剪切板
set shellredir=>%s
set showmode
set ruler
set rulerformat=%15(%c%V\ %p%%%)


" Text Formatting
set formatoptions=tcrqn        " 自动格式化
set autoindent                 " 继承前一行的缩进方式
set smartindent                " 智能的缩进
set cindent                    " 使用C样式的缩进
set tabstop=4                  " 制表符为4个空格
set softtabstop=4              " 缩进为4
set shiftwidth=4               " 缩进为4
set wrap                       " 自动换行
set expandtab                  " 插入模式使用空格代替Tab
set magic                      " 搜索模式可使用特殊字符
" set smarttab                 " 行和段开始处使用制表符
" set nofoldenable             " 不允许折叠
" set foldmethod=marker        " 折叠方式
" set breakindent


" Search & Match
set hlsearch                   " 高亮搜索的片段
set ignorecase                 " 搜索时忽略大小写
set showmatch                  " 高亮显示匹配的括号
set matchtime=10               " 匹配括号高亮的时间（单位时十分之一秒）
set incsearch                  " 搜索时输入的字符逐个高亮
set smartcase


" Coding
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,usc-bom,euc-jp,gb18030,gbk,gb2312,cp936
set termencoding=utf-8


" Chinese
" set langmenu=zh_CN.UTF-8
" language message zh_CN.UTF-8
" source $VIMRUNTIME/delmenu.vim
" source $VIMRUNTIME/menu.vim


" Complete
set complete=.,w,b,k,t,i
set completeopt=longest,menu


" Mouse
set mouse=a
set selection=exclusive
set selectmode=mouse,key


" Tab Page
set tabpagemax=8
set showtabline=1


" Keys
let g:mapleader = "\<Space>"
let g:maplocalleader = ','

nnoremap U   :redo<CR>
inoremap jk  <Esc>
inoremap kj  <Esc>
nnoremap <silent> zj o<ESC>k
nnoremap <silent> zk O<ESC>j
nnoremap J 5j
nnoremap K 5k
nnoremap <C-tab> :tabnext<CR>
nnoremap <leader>fe :e $MYVIMRC<CR>

" Expand
iab vdate <c-r>=strftime("%Y-%m-%d %H:%M:%S")<CR>

" UI 
if has("gui_running")
    set guioptions-=T " remove toolbar
    set guioptions-=m " remove menubar
    set guioptions-=r " remove right-hand scroll bar
    set guioptions-=L " remove left-hand scroll bar
    set guifont=JetBrainsMonoMedium\ Nerd\ Font\ 9
else
    set t_Co=256
endif
