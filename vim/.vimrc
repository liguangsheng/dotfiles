set nocompatible
syntax on
filetype on
filetype plugin on
filetype indent on

" 基本设置
" set relativenumber                   " 显示相对行号
set cursorline                         " 高亮当前行
set backspace=indent,eol,start         " 支持退格操作
set history=1000                       " 历史命令记录数
set confirm                            " 确认操作
set nobackup                           " 不创建备份文件
set noswapfile                         " 不创建交换文件
set nowritebackup
set bufhidden=hide                     " 隐藏未使用的缓冲区
set linespace=1                        " 行间距
set wildmenu                           " 增强命令补全
set whichwrap+=<,>,[,]                 " 在行尾时允许左右移动
set shortmess=atl                      " 短消息选项
set report=0                           " 关闭报告
set noerrorbells                       " 关闭错误铃声
set scrolloff=3                        " 保留3行上下的可见空间
set laststatus=2                       " 始终显示状态栏
set showcmd                            " 显示命令输入
set autoread                           " 自动读取文件变化
set nu!                                " 取消行号（不太常用）

" 剪贴板设置
if has('unnamedplus')
    set clipboard=unnamedplus
else
    set clipboard=unnamed
endif

" Shell 设置
set shellredir=>%s                     " Shell 重定向
set showmode                           " 显示模式

" 状态栏设置
set ruler                              " 显示光标位置
set rulerformat=%l:%c\ %p%%


" 格式化选项
set formatoptions=tcrqn                " 自动换行选项
set autoindent                         " 自动缩进
set smartindent                        " 智能缩进
set cindent                            " C 语言缩进
set tabstop=4                          " Tab 宽度
set softtabstop=4                      " 软 Tab 宽度
set shiftwidth=4                       " 缩进宽度
set wrap                               " 自动换行
set expandtab                          " 将 Tab 转换为空格

" 搜索设置
set magic                              " 启用魔术匹配
set smarttab                           " 智能 Tab
set hlsearch                           " 高亮搜索结果
set ignorecase                         " 忽略大小写
set showmatch                          " 显示匹配的括号
set matchtime=10                       " 括号匹配高亮时间
set incsearch                          " 增量搜索
set smartcase                          " 智能大小写搜索

" 编码设置
set encoding=utf-8                     " 设置编码为 UTF-8
set fileencoding=utf-8                 " 文件编码为 UTF-8
set termencoding=utf-8                 " 终端编码为 UTF-8

" 完成设置
set complete=.,w,b,k,t,i               " 补全选项
set completeopt=menu,preview,noselect  " 补全菜单选项

" 鼠标和选择设置
set mouse=a                            " 启用鼠标支持
set selection=exclusive                " 排他性选择
set selectmode=mouse,key               " 选择模式

" 标签和窗口设置
set tabpagemax=8                       " 最大标签页数
set showtabline=1                      " 显示标签行

" View
set viewoptions=folds,options,cursor
augroup AutoSaveView
    autocmd!
    autocmd BufWinLeave * silent! mkview
    autocmd BufWinEnter * silent! loadview
augroup END

" Keys
let g:mapleader = "\<Space>"
let g:maplocalleader = ','
nnoremap <silent> U :redo<CR>
nnoremap <silent> J 5j
nnoremap <silent> K 5k
nnoremap <silent> <C-tab> :tabnext<CR>
nnoremap <silent> <leader>fe :e $MYVIMRC<CR>
nnoremap <silent> <leader>ww <C-w>w
nnoremap <silent> <C-h> <C-w>h
nnoremap <silent> <C-j> <C-w>j
nnoremap <silent> <C-k> <C-w>k
nnoremap <silent> <C-l> <C-w>l
nnoremap <silent> <C-x><space> :noh<CR>

" Expand
iab vdatetime <c-r>=strftime("%Y-%m-%d %H:%M:%S")<CR>

" UI
if has("gui_running")
    set guioptions-=T " remove toolbar
    set guioptions-=m " remove menubar
    set guioptions-=r " remove right-hand scroll bar
    set guioptions-=L " remove left-hand scroll bar
    set guifont=JetBrainsMonoMedium\ Nerd\ Font\ 9
else
    set t_Co=256
    if has('termguicolors')
        set termguicolors
    endif
    colorscheme desert
endif


