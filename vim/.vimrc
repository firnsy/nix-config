"
" SECTIONS:
"   - General
"   - VIM user interface
"   - Colors and Fonts
"   - Files and backups
"   - Text, tab and indent related
"   - Visual mode related
"   - Command mode related
"   - Moving around, tabs and buffers
"   - Statusline
"   - General Abbreviations
"   - Editing mappings
"
"   - Cope
"   - Python section
"   - JavaScript section
"
"


"
" GENERAL
"

" sets how many lines of history VIM has to remember
set history=700

" Enable filetype plugin
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

" with a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" fast saving
nmap <leader>w :w!<cr>

" give the pinky a break on SHIFT
nmap ; :

" give the left pinky a break on ESC
imap jj <Esc>

"
" VIM USER INTERFACE
"

" don't show line numbers
set nonu

" set 4 lines to the cursors - when moving vertical..
set so=4

" only complete to the longest possible match
set wildmode=longest:full

" turn on WiLd menu
set wildmenu

" always show current position
set ruler

" the commandbar height
set cmdheight=1

" change buffer - without saving
set hid

" set backspace config
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" ignore case when searching
set ignorecase
set smartcase

" highlight search things
set hlsearch

" make search act like search in modern browsers
set incsearch

" don't redraw while executing macrosg
set nolazyredraw

" set magic on, for regular expressions
set magic

" show matching brackets when text indicator is over them
set showmatch

" how many tenths of a second to blink
set mat=2

" no sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500


"
" COLOURS AND FONTS
"

" enable syntax highlighting
syntax enable

" set font
set gfn=Monospace\ 10

" set default shell to BASH
set shell=/bin/bash

" set default encoding to UTF-8
set encoding=utf8

" default file types
set ffs=unix,dos,mac


"
" FILES, BACKUPS and UNDO
"

" turn backup off, since most stuff is in SVN, git anyway...
set nobackup
set nowb
set noswapfile

" persistent undo
try
  set undodir=~/.vim_runtime/undodir
  set undofile
catch
endtry


"
" TEXT, TAB and INDENT
"
set expandtab
set shiftwidth=2
set tabstop=2
set smarttab

set lbr
set tw=500

" enable auto indent
set ai

" enable smart indent
set si

" enable wrap lines
set wrap

highlight RedundantSpaces term=standout ctermbg=red guibg=red
match RedundantSpaces /\s\+$\| \+\ze\t\|\t/

"flag problematic whitespace (trailing and spaces before tabs)
"" Let's see those ugly tabs and trailing spaces
set list   listchars=tab:»·,trail:·
"Note you get the same by doing let c_space_errors=1 but
""this rule really applys to everything.
"use :set list! to toggle visible whitespace on/off
set listchars=tab:»·,trail:·,extends:»


"
" COMMENTING/UNCOMMENTING CODE
"

autocmd FileType c,cpp,javascript let b:comment_leader = '// '
autocmd FileType sh,perl,python   let b:comment_leader = '# '
autocmd FileType conf,fstab       let b:comment_leader = '# '
autocmd FileType vim              let b:comment_leader = '" '
noremap <silent> <leader>c :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:noh<CR>
noremap <silent> <leader>u :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:noh<CR>


"
" VISUAL MODE
"

" in visual mode when you press * or # to search for the current selection
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>

" when you press gv you vimgrep after the selected text
vnoremap <silent> gv :call VisualSearch('gv')<CR>
map <leader>g :vimgrep // **/*.<left><left><left><left><left><left><left>

function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction


function! VisualSearch(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction


"
" COMMAND MODE
"

" Smart mappings on the command line
cno $h e ~/
cno $d e ~/Desktop/
cno $j e ./
cno $c e <C-\>eCurrentFileDir("e")<cr>

" $q is super useful when browsing on the command line
cno $q <C-\>eDeleteTillSlash()<cr>

" bash like keys for the command line
cnoremap <C-A> <Home>
cnoremap <C-E> <End>
cnoremap <C-K> <C-U>

cnoremap <C-P> <Up>
cnoremap <C-N> <Down>

func! Cwd()
  let cwd = getcwd()
  return "e " . cwdg
endfunc

func! DeleteTillSlash()
  let g:cmd = getcmdline()
  let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*", "\\1", "")
  if g:cmd == g:cmd_edited
    let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*/", "\\1", "")
  endif
  if g:cmd == g:cmd_edited
      let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*/", "\\1", "")
    endif
  endif
  return g:cmd_edited
endfunc

func! CurrentFileDir(cmd)
  return a:cmd . " " . expand("%:p:h") . "/"
endfunc


"
" MOVING AROUND, TABS and BUFFERS
"

map <silent> <leader><cr> :noh<cr>

" smart way to move btw. windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" close the current buffer
map <leader>bd :Bclose<cr>

" close all the buffers
map <leader>ba :1,300 bd!<cr>

" tab configuration
map <leader>tn :tabnew<cr>
map <leader>te :tabeditg
map <leader>tc :tabclose<cr>
map <leader>tm :tabmoveg

" when pressing <leader>cd switch to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>


command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete! ".l:currentBufNum)
   endif
endfunction

" specify the behavior when switching between buffersg
try
  set switchbuf=usetab
  set stal=2
catch
endtry


"
" STATUSLINE
"

" always hide the statusline
set laststatus=2

" format the statusline
set statusline=%{HasPaste()}%<%F%h%m%r%h%w%y\ %{&ff}\ line:%l/%L\ col:%c%V\ pos:%o\ ascii:%b\ %P


function! HasPaste()
    if &paste
        return ' PASTE MODE  '
    else
        return ' '
    endif
endfunction



"
" GENERAL ABBREVIATIONS
"
iab xdate <c-r>=strftime("%d/%m/%y %H:%M:%S")<cr>


"
" EDITING MAPPINGS
"

" remap VIM 0
map 0 ^

" move a line of text using ALT+[jk] or Command+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

" delete trailing white space, useful for Python ;)
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()

set guitablabel=%t


"
" COPE
"

" do :help cope if you are unsure what cope is. It's super useful!
map <leader>cc :botright cope<cr>
map <leader>n :cn<cr>
map <leader>p :cp<cr>


"
" SPELL CHECKING
"

" pressing ,ss will toggle spell checking on and off
map <leader>ss :setlocal spell!<cr>

" shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=


"
" PYTHON SECTION
"

let python_highlight_all = 1
au FileType python syn keyword pythonDecorator True None False self

au BufNewFile,BufRead *.jinja set syntax=htmljinja
au BufNewFile,BufRead *.mako set ft=mako

au FileType python inoremap <buffer> $r returng
au FileType python inoremap <buffer> $i importg
au FileType python inoremap <buffer> $p printg
au FileType python inoremap <buffer> $f #--- PH ----------------------------------------------<esc>FP2xi
au FileType python map <buffer> <leader>1 /classg
au FileType python map <buffer> <leader>2 /defg
au FileType python map <buffer> <leader>C ?classg
au FileType python map <buffer> <leader>D ?defg


"
" JAVASCRIPT SECTION
"
au FileType javascript setl fen
au FileType javascript setl nocindent

au FileType javascript imap <c-t> AJS.log();<esc>hi
au FileType javascript imap <c-a> alert();<esc>hi

au FileType javascript inoremap <buffer> $r returng
au FileType javascript inoremap <buffer> $f //--- PH ----------------------------------------------<esc>FP2xi

function! JavaScriptFold()
    setl foldmethod=syntax
    setl foldlevelstart=1
    syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend

    function! FoldText()
        return substitute(getline(v:foldstart), '{.*', '{...}', '')
    endfunction
    setl foldtext=FoldText()
endfunction


"
" VIM GREP
"

let Grep_Skip_Dirs = 'RCS CVS SCCS .svn generated .git'
set grepprg=/bin/grep\ -nH


"
" MISCELLANEOUS
"

" remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" quickly open a buffer for scribble
map <leader>q :e ~/buffer<cr>
au BufRead,BufNewFile ~/buffer iab <buffer> xh1 ===========================================

map <leader>pp :setlocal paste!<cr>

map <leader>bb :cd ..<cr>
