"let $LANG="zh_CN.UTF-8"
"set fileencodings=utf-8,chinese,latin-1
"set termencoding=utf-8
"set encoding=utf-8

let $LANG="zh_CN.GBK"
set fileencodings=gbk,chinese,latin-1
set termencoding=gbk
set encoding=gbk



set nocp
set is
syntax on
set ts=4
set sw=4
"set expandtab
set cinoptions=:0,g0
set si
set fdm=manual
set nu
"colorscheme desert
set t_Co=256
colorscheme darkburn
set background=dark
"colorscheme solarized

filetype plugin indent on
set nocompatible
		   
let Tlist_Ctags_Cmd='/usr/bin/ctags'    
let Tlist_Show_One_File=1
let Tlist_OnlyWindow=1
let Tlist_Use_Right_Window=0
let Tlist_Sort_Type='name'
let Tlist_Exit_OnlyWindow=1
let Tlist_Show_Menu=1
let Tlist_Max_Submenu_Items=20
let Tlist_Max_Tag_length=20
let Tlist_Use_SingleClick=0
let Tlist_Auto_Open=0
let Tlist_Close_On_Select=0
let Tlist_File_Fold_Auto_Close=1
let Tlist_GainFocus_On_ToggleOpen=0
let Tlist_Process_File_Always=1
let Tlist_WinHeight=10
let Tlist_WinWidth=23
let Tlist_Use_Horiz_Window=0

map <silent> <leader>taw :VimwikiAll2HTML<cr>
map <silent> <leader>tw :Vimwiki2HTML<cr>
" calendar
map <silent> <leader>ca :Calendar<cr>

map <silent> <leader>tl :TlistToggle<cr>
"set tags+=~/.vim/systags
set tags+=tags
set tags+=/search/wangzhen/picsearch/tags


map <C-F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
set completeopt=menu
set cindent
set ignorecase 
set smartcase

let MRU_Max_Entries=1000 
let MRU_Max_Menu_Entries=20
let MRU_Max_Submenu_Entries=15
let MRU_Window_Height = 25 
nmap mm :MRU<cr>



let NERDTreeShowBookmarks=1
nmap nt :NERDTree<cr>
nmap mark :Bookmark<cr>
nmap unmark :ClearBookmark<cr>

set autoread


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => winManager setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:winManagerWindowLayout = "NERDTree|TagList"
let g:winManagerWidth = 30
let g:defaultExplorer = 0
let g:persistentBehaviour = 0
let g:AutoOpenWinManager = 0
nmap wf :FirstExplorerWindow<cr>
nmap wb :BottomExplorerWindow<cr>
nmap wm :WMToggle<cr>


execute pathogen#infect() 
