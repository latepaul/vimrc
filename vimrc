"    Welcome to Paul's Vimrc File Help
" 
"How to set up this vimrc:
" 
"1. Make sure you have ~/.vim/doc and ~/.vim/bundle directories
"2. Copy this file to ~/.vimrc
"3. Install Vundle, i.e.
"   cd ~/.vim/bundle
"   git clone https://github.com/VundleVim/Vundle.vim.git
"4. Put vimutil on your PATH (e.g. ~/bin)
"5. First time in vi run :PluginInstall to install plugins, later from time to time :PluginUpdate to update them
"
"That's it (I think)

"Actual vimrc stuff:

" don't try to be vi-like
set nocompatible
" needed to load Vundle
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')
"
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Bundle 'jordwalke/flatlandia'

Plugin 'Yggdroot/indentLine'

Plugin 'airblade/vim-gitgutter'

Plugin 'tpope/vim-fugitive'

" All of your Plugins must be added before the following line
call vundle#end()  

" syntax highlighting
syntax on
" recognise file types
filetype plugin indent on
set omnifunc=syntaxcomplete#Complete
"set completeopt-=preview
set fdm=syntax
let g:sh_fold_enabled=4
set foldlevelstart=99

" vertical windows for fugitive Gdiff
set diffopt+=vertical

set shiftwidth=4
set expandtab
set tabstop=8

set t_Sb=m
set t_Sf=m

" don't sync buffer scrolling in same file
set noscrollbind

" indentline settings
let g:indentLine_color_term = 59
let g:indentLine_char = '|'
let g:indentLine_enabled = 0
" [HELP] \i  ~ toggle indent lines
nnoremap <leader>i :IndentLinesToggle<cr>
" [HELP] \s  ~ search (forwad) using last visual range
nnoremap <leader>s /\%V
" [HELP] \r  ~ search (back) using last visual range
nnoremap <leader>? ?\%V

" tab settings specific to xterm
if &term=="xterm"
     set t_Co=16
     colorscheme desert
     highlight DiffAdd term=reverse cterm=bold ctermbg=blue  ctermfg=gray
     highlight DiffChange term=reverse cterm=bold ctermbg=gray ctermfg=black
     highlight DiffText term=reverse cterm=bold ctermbg=cyan ctermfg=black
     highlight DiffDelete term=reverse cterm=none ctermbg=blue  ctermfg=black
     highlight Pmenu ctermfg=Cyan ctermbg=blue cterm=none
     highlight PmenuSel ctermfg=White ctermbg=blue cterm=bold
     highlight PmenuSbar ctermbg=blue
     highlight PmenuThumb ctermbg=gray
     highlight CursorLineNr ctermfg=gray
     highlight LineNr ctermfg=darkgrey
     highlight ColorColumn ctermbg=darkgrey
 elseif &term=="xterm-256color"
     set t_Co=256
     colorscheme flatlandia
     hi DiffAdd term=bold cterm=bold ctermfg=15 ctermbg=22
"     highlight DiffAdd term=reverse cterm=bold ctermbg=59  ctermfg=gray
"     highlight DiffChange term=reverse cterm=bold ctermbg=59 ctermfg=gray
"     highlight DiffText term=reverse cterm=bold ctermbg=59  ctermfg=yellow
"     highlight DiffDelete cterm=none ctermbg=59  ctermfg=black
"     highlight NonText term=reverse cterm=bold ctermbg=black  ctermfg=gray
      highlight Pmenu        ctermfg=gray    ctermbg=241 cterm=None
      highlight PmenuSel     ctermfg=white   ctermbg=241 cterm=Bold
      highlight PmenuSbar    ctermfg=Gray    ctermbg=241 cterm=None
      highlight PmenuThumb   ctermfg=white   ctermbg=Gray     cterm=None
      highlight CursorLineNr ctermfg=white
      highlight LineNr ctermfg=darkgrey
      highlight ColorColumn ctermbg=darkgrey
endif

set t_ut=

"add highlight column at 81
set colorcolumn=81

" used for completion loading/listing buffers or doing find on files
set wildmode=longest,full
set wildmenu
" set the char for completion for use in macros i.e. key mapping (see mapping
" for m)
set wildcharm=<tab>
" [HELP] m ~ list buffers in 'wildmenu'
nnoremap m  :b <tab><tab>

" [HELP] \d ~ delete current buffer (close window)
nnoremap <leader>d  :bd<cr>
" [HELP] \x ~ delete current buffer, discarding outstanding changes 
nnoremap <leader>x  :bd!<cr>
" [HELP] \q ~ close window (keep buffer in background)
nnoremap <leader>q  :q<cr>
" [HELP] \\q ~ close window (do not save)
nnoremap <leader><leader>q  :q!<cr>

" always show status line
set laststatus=2
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ }
set statusline=%{fugitive#statusline()}\ %F\ %=l/%L,%c%V\ %P
"set statusline+=%=l/%L,%c%V\ %P

" define a command Make which is make piped to cwindow i.e. do a make and
" open the results/error window automatically
" Using Make/make also populates the error list used below
:command! -nargs=* Make make <args> | cwindow 5

" define the make command - this is a script which does different things
" according to the first argument
set makeprg=vimutil

" set tags to be current $ING_SRC one - use let as this will change when we
" change ING_SRC i.e. switch build areas
let &tags=$ING_SRC.'/tags,'.$TREASURE_ROOT.'/tags,./tags'

" function to call when changing to/from insert mode
" type is 1 for enter insert mode, 2 for leave
function! FnInsertChange(type)
" if numbering not on then quit
    if g:number_style == 0
        return
    endif

" if entering then set to absolute
    if a:type == 1
        set nu
        set nornu
" otherwise (leaving) if numbering is on and was relative set back to
" that
    elseif g:number_style == 1
        set rnu
        if v:version < 704
            set nonu
        endif
    elseif g:number_style == 3
        set rnu
        set nonu
    endif
endfunction

" Switch to absolute line numbers in Insert mode
autocmd InsertEnter * call FnInsertChange(1)
autocmd InsertLeave * call FnInsertChange(2)

helptags $HOME/.vim/doc

" [HELP] F1  ~ Toggle this help
if !exists("user_vim")
    nnoremap <F1> :call PaulVimHelp("~/.vimrc")<CR>
else
    nnoremap <F1> :call PaulVimHelp(user_vim)<CR>
endif

" variable to track whether help window is open
let g:pvhelp_is_open = 0

"function to toggle help
function! PaulVimHelp(basefile)
    if g:pvhelp_is_open
        help
        close
        let g:pvhelp_is_open = 0
    else
        execute 'silent !vimutil help ' . a:basefile
        redraw!
        help PV_Help
        let g:pvhelp_is_open = 1
    endif
endfunction

" [HELP] spF1  ~ general Vim help
nnoremap <space><F1> :help<cr>

function! Darren_Comment()
   if g:autocomment_is_on
      let g:autocomment_is_on = 0
      set formatoptions-=cro
      echo "autocomment off"
   else
      set formatoptions+=cro
      let g:autocomment_is_on = 1
      echo "autocomment on"
   endif
endfunction


" variable to track whether AutoComment is on
 let g:autocomment_is_on = 1

" [HELP] Ctrl-Shift-] ~ save file and do ctrl-] (find tag)
nnoremap <c-}> :update<CR><c-]>

" netrw options
" disable banner
let g:netrw_banner = 0
" liststyle means?
let g:netrw_liststyle = 3
" 0 = take up whole window
let g:netrw_browse_split = 0

" toggle function for netrw
fun! NetrwToggle()
    if &filetype != "netrw"
        let g:last_bufnr = bufnr('%')
        exe "Explore "
    else
        if &filetype == "netrw"
            exe ":bd"
            exe ':b' . g:last_bufnr
        endif
    endif
endf

" [HELP] F2 ~ Open netrw (file browser)
nnoremap <F2> :call NetrwToggle()<CR>


" [HELP] spF2 ~ list buffers
nnoremap <space><F2> :ls<CR>
" [HELP] sF2  ~ list buffers and load one (hit N then enter) into new window
nnoremap s<F2> :ls<CR>:sb<Space> 
" [HELP] vF2 ~ list buffers and load one (hit N then enter) into new vert-window
nnoremap v<F2> :ls<CR>:vert sb<Space>
" [HELP] eF2 ~ list buffers and load one (hit N then enter) into current window
nnoremap e<F2> :ls<CR>:b<Space>


" [HELP] F3 ~ save/re-source .vimrc
nnoremap <f3> :w<CR>:source ~/.vimrc<CR>
" [HELP] spF3 ~ edit .vimrc
if !exists("user_vim")
    nnoremap <space><f3> :e ~/.vimrc<CR>
else
    execute 'nnoremap <space><f3> :e ' . user_vim . '<CR>'
endif
" [HELP] cF3 ~ display syntax colours
nnoremap c<F3> :so $VIMRUNTIME/syntax/hitest.vim<CR>


" [HELP] F4 ~ p rcompare of current file (against revision which was opened)
nnoremap <F4>  :!vimutil pcomp %<CR>

" [HELP] spF4 ~ p rcompare of current file (against head rev)
nnoremap <space><F4>  :!vimutil pcomphr %<CR>

" [HELP] vF4 ~ vimdiff of current file (against head rev)
nnoremap v<F4>  :call VPDiff2(1)<CR>

" [HELP] cF4 ~ vimdiff of current file (against revisions which was opened)
nnoremap c<F4>  :call VPDiff2(0)<CR>

" [HELP] tF4 ~ vimdiff of current file (against revision entered by user)
nnoremap t<F4>  :call VPDiff2(2)<CR>

function! VPDiff(type)
    if a:type == 2
      let cver = system("vimutil pshowver " . bufname("%"))
      call inputsave()
      let inptxt = "Diff with rev (" . cver . ") "
      let urev = input(inptxt)
      call inputrestore()
      if urev == ""
          let urev = cver
      endif
      let dfile = system("vimutil pgetrev " . bufname("%") . " " . urev)
    elseif a:type == 1
      let dfile = system("vimutil pgethr " . bufname("%"))
    else
      let dfile = system("vimutil pgetcr " . bufname("%"))
    endif
    execute 'vert diffsplit' dfile
    let cmd = system("rm " . dfile)
endfunc

" [HELP] fF4 ~ filelog of current file in vert split
nnoremap f<F4>  :call Filelog(1)<CR>
function! Filelog(type)
    if a:type == 1
        execute 'vnew | 0read ! p filelog ' . expand('%')
    else
        execute 'new | 0read ! p filelog ' . expand('%')
    endif
    call cursor(1,1)
    execute ":set buftype=nofile"
"   execute 'vnew | 0read ! p get -r 82 -p ' expand('%')
endfunc

nnoremap y<F4>  :call VPDiff2(2)<CR>
function! VPDiff2(type)
    let ftype = &ft
    let fname = expand("%:p:t")
    let bname = bufname("%")
    let bpath = expand("%:p:h")
    let cver = systemlist("cd " . bpath . "; p have " . fname . " | awk '{print $3}'")[0]
    if a:type == 2
        call inputsave()
        let inptxt = "Diff with rev (" . cver . ") "
        let urev = input(inptxt)
        call inputrestore()
        if (urev == '')
            let urev = cver
        endif
    elseif a:type == 1
        "get headrevs rev no
        let urev = system("cd " . bpath . " ; p need " . fname .  " 2>&1  | awk 'BEGIN { n = 3 } /is up to/ { n = 9 } {printf( \"%s\", $n); exit}'")
    else
        let urev = cver
    endif
    let bname = bname.".rev-".urev
    let cmd = 'vnew | 0read ! cd ' . bpath . '; p get -r ' . urev . ' -p '.fname. ' | grep -v "^==="'
    execute cmd
    silent normal! $Gdd
    execute "set bh=delete"
    execute 'set filetype='.ftype
    execute 'silent file '. bname
    execute ":set buftype=nofile"
    windo diffthis
    call GotoBuf(bname)
    silent normal! 1G]c
   
endfunc

function! GotoBuf(bufname)
    let n = bufwinnr(a:bufname)
    let cmd=n."wincmd w"
    execute cmd
endfunc
" [HELP] ff ~ toggle fold of current syntax block
nmap ff  za
" [HELP] == ~ indent current code block
nmap == =iB
" [HELP] c<space> ~ toggle auto-comment
nnoremap c<space> :call Darren_Comment()<cr>

" [HELP] F5 ~ Next Window
nnoremap <F5>  <C-w>w

" [HELP] F6 ~ Make Window wider
nmap <F6>  <c-w>>
" [HELP] F7 ~ Make Window taller
nmap <F7>  <c-w>+
" [HELP] F8 ~ Make Windows equal(ish) size
nmap <F8>  <c-w>=

" [HELP] spF6 ~ jump to location of prev build error (in code window)
nnoremap <space><F6>  :cp<CR>
" [HELP] spF7 ~ jump to current build error (will be there by default, but if you've moved away, to another buffer, followed a tag)
nnoremap <space><F7>  :cc<CR>
" [HELP] spF8 ~ jump to next build error
nnoremap <space><F8>  :cn<CR>

" the following commands are not compilation so just call them with !
" not via Make
"
" [HELP] F9 ~ open the current file in psuite and reload in the editor
nnoremap <F9> :!vimutil pop %<CR>:edit!<CR>
" [HELP] F10 ~ release the current file in psuite and reload in the editor
nnoremap <F10> :!vimutil prelease %<CR>:edit!<CR>
" [HELP] F11 ~ save and build the file you're editing
nnoremap <F11> :w<CR>:Make jam %<CR>

" [HELP] F12 ~ close current window (buffer remains open)
nnoremap <F12> :close<cr>

" [HELP] spF12 ~ save, build and mkdbms
nnoremap <space><F12> :Make mkdbms %<CR>
" [HELP] F12F12 ~ save and build from ING_SRC (see vimutil)
nnoremap <F12><F12> :Make jamall<CR>
" [HELP] Shift-Tab ~ Cycle buffers in current window 
nnoremap <S-Tab> :bnext!<CR>

nnoremap ; :

function! FindFixme()
        vimgrep /TODO\|FIXME/j % 
        cw
endfunction
" [HELP] \f ~ list FIXME's in currrent file
nnoremap <leader>f :vimgrep /TODO<Bslash><Bar>FIXME/j % <Bar> cw<CR>
" [HELP] \c ~ close quickfix window
nnoremap <leader>c :ccl<CR>
" [HELP] \l  ~ Toggle special chars view
nnoremap <leader>l :if &list<cr>set nolist<cr>else<cr>set list<cr>endif<cr><cr>
" [HELP] \C  ~ restore cursorline highlight of line itself
nnoremap <leader>C :hi CursorLine ctermbg=238<CR>
" [HELP] \n  ~ next in taglist
nnoremap <leader>n :tnext<cr>
" [HELP] \p  ~ prev in taglist
nnoremap <leader>p :tprev<cr>
" [HELP] \1  ~ first in taglist
nnoremap <leader>1 :tfirst<cr>

" [HELP] \g ~ toggle GitGutter (git diff highlighting)
nnoremap <leader>g :GitGutterToggle<CR>

let g:gitgutter_highlight_lines = 1
let g:gitgutter_realtime = 0
"let g:gitgutter_eager = 0

"function to toggle tabstop
function! ToggleTab()
    if &tabstop == 4
        set tabstop=8
    else
        set tabstop=4
    endif
endfunction

" [HELP] \t ~ toggle tabstop size
nnoremap <leader>t  :call ToggleTab()<cr>


if has('multi_byte')
set listchars=tab:»»,trail:·,eol:$
else
set listchars=tab:->trail:.,eol:$
endif

" variable to track number style (1=relative, 2=absolute, 0=off)
let g:number_style = 1

" default to relative line numbering on
set rnu
" rnu in 7.4 sets current line to 0, to get line number (as with 7.3)
" need to set nu as well
if v:version > 703
    set nu
endif

" [HELP] Ctrl-n ~ Toggle relative -> absolute -> no line numbers
nnoremap <C-n> :call NumberToggle()<CR>
function! NumberToggle()
    if(g:number_style == 0)
        set rnu
        if v:version > 703
            set nu
        endif
        let g:number_style=1
    elseif(g:number_style == 1)
        set nu
        set nornu
        set cursorline
        hi clear CursorLine
        if v:version > 703
            let g:number_style=2
        else
            let g:number_style=3
        endif
    elseif (g:number_style == 2)
        set nocursorline
        hi CursorLine ctermbg=238
        set nonu
        set rnu
        let g:number_style=3
    else
        set nocursorline
        hi CursorLine ctermbg=238
        set nonu
        set nornu
        let g:number_style=0
    endif
endfunc

function! Colortest()
let num = 255
while num >= 0
    exec 'hi col_'.num.' ctermbg='.num.' ctermfg=white'
    exec 'syn match col_'.num.' "ctermbg='.num.':...." containedIn=ALL'
    call append(0, 'ctermbg='.num.':....')
    let num = num - 1
endwhile
endfunc
nnoremap <leader>k :call Colortest()<CR>
" the following are default mappings that are here so they get displayed with
" help:
" [HELP] Ctrl-] ~ jump to tag reference under cursor (if wrong try :ts)
" [HELP] Ctrl-T ~ jump back (after Ctrl-])
" [HELP] Ctrl-O/Ctrl-I ~ jump forward/back in locations (like Ctrl-6 but includes positions in same file)
" [HELP] Ctrl-W w ~ next window
" [HELP] Ctrl-W v ~ new window (vertical)
" [HELP] Ctrl-W = ~ make windows same size
" [HELP] Ctrl-W +/- ~ increase/decrease current window height
" [HELP] Ctrl-W </> ~ increase/decrease current window width
" [HELP] Ctrl-W = ~ make windows same size
" [HELP] Ctrl-6 ~ cycle through buffers
" [HELP] Ctrl-W s ~ split and create new window (SAME file)
" [HELP] Ctrl-W n ~ split and create new window (NEW file)
" [HELP] ]c ~ next diff in vimdiff mode
" [HELP] [c ~ next diff in vimdiff mode
" [HELP] :e file ~ edit new file (opens buffer)
" [HELP] :split file ~ edit new file (in split window)
" [HELP] :sb #|file ~ split and load buffer
" [HELP] :b #|file ~ load buffer
" [HELP] >> indent to the right
" [HELP] Ctrl-X Ctrl-P ~ in insert mode try to complete current symbol based on contents of current file (previous match)
" [HELP] Ctrl-X Ctrl-N ~ in insert mode try to complete current symbol based on contents of current file (next match)
" [HELP] Ctrl-X Ctrl-O ~ in insert mode try to complete current symbol based on known tags, includes fields within structures
" [HELP] v {choose range} ESC /\%Vsearchterm ~ search for 'searchterm' in chosen range, e.g. function

