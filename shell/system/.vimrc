" 插入模式
set pastetoggle=<F9>
" set completeopt=preview,menu
" 映射全选+复制 ctrl+a
map  <C-A> ggVGY
map! <C-A> <Esc>ggVGY
map  <F12> gg=G
" 选中状态下 Ctrl+c 复制
vmap <C-c> "+y
"允许插件  
filetype plugin on
"自动保存
set autowrite
set ruler                   " 打开状态栏标尺
set cursorline              " 突出显示当前行
set magic                   " 设置魔术
set guioptions-=T           " 隐藏工具栏
set guioptions-=m           " 隐藏菜单栏
" 语法高亮
set syntax=on
" 去掉输入错误的提示声音
set noeb
" 在处理未保存或只读文件的时候，弹出确认
set confirm
" 自动缩进
set autoindent
set cindent
" Tab键的宽度
set tabstop=4
" 统一缩进为4
set softtabstop=4
set shiftwidth=4
" 不要用空格代替制表符
set noexpandtab
" 在行和段开始处使用制表符
set smarttab
" 显示行号
set number
