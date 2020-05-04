"    Welcome to Paul's Vimrc File Help
" 
"How to set up this vimrc:
" 
"1. Make sure you have ~/.vim/doc and ~/.vim/bundle directories
"2. Copy this file to ~/.vimrc
"3. Install Vundle, i.e.
"   cd ~/.vim/bundle
"   git clone https://github.com/VundleVim/Vundle.vim.git
"4. First time in vi run :PluginInstall to install plugins, later from time to time :PluginUpdate to update them
"
"That's it (I think)

"TODO - 1) split this into a) settings b) keymappings c) functions
"TODO - put coding stuff (diff/jam/etc) into functions in a separate file and
"source it

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
" set omni-complete to use syntax 
set omnifunc=syntaxcomplete#Complete
" remove preview when showing complete menu. This is a buffer at the top of
" the screen with extra info. Perhaps useful but left behind after you've
" selected an item
set completeopt-=preview
" fold based on syntax
set fdm=syntax
" set fold options for shell 
"  1 = functions
"  2 = heredoc
"  4 = if/do/for
"  7 = 1 + 2 + 4 = all of the above
let g:sh_fold_enabled=7
" start with all folds open
set foldlevelstart=99

" vertical windows for fugitive Gdiff
set diffopt+=vertical

" got these from some Ingres wiki page - supposed to be standard probably not
" number of spaces when auto-indenting
set shiftwidth=4
" typing a tab expands to spaces
set expandtab
" number of spaces equiv to tabs
set tabstop=8
" so auto-indent uses 4 spaces but typing a tab is 8 (tbf vim help says keep
" tabstop at 8 so...)

set t_Sb=m
set t_Sf=m

" don't sync buffer scrolling in same file
set noscrollbind

" netrw windows have a habit of hanging around, make them so they get removed
" when not on screen
autocmd FileType netrw setl bufhidden=wipe

let g:cmdno = 0

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

" RunJam() - Do a build (jam)
"
" Parameters:
"    type, logtype, warnings
"
" type can be:
"      1 - jam from ING_SRC 
"      2 - jam <current file target> (default)
"      3 - jam curr file and mkdbms
"
" logtype
"      1 - output gets turned into quickfix window
"      2 - output goes to log which is opened as a buffer
" warnings
"      1 - do not include warnings
"      2 - include warnings

function! RunJam(...)
    let logtype = 1
    let type = 2
    let warnings = 1
    if a:0 > 0
        let type = a:1
        if a:0 > 1 
            let logtype = a:2
            if a:0 > 2 
                let warnings = a:3
            endif
        endif
    endif

    " construct temp file name for output log
    let rndno = system('printf ''%d'' $$')
    let tmpfile = '/tmp/vimjam.log.' . rndno

    " simplest version, jam from ING_SRC
    if type == 1
        let cmd = '(cd $ING_SRC ; jam -q '
    else
        " jam current file
        " to do this we cd to the file's directory and do "jam -q target"
        " where target is e.g. <back>!<scf>!<scs>scsqncr.o
        let srcdir = expand("%:p:h")
        let objfile = expand("%:r") . '.o'

        " this command attempts to get the directory name from the jam file
        let acmd = 'cd '. srcdir.'; awk ''$1=="SubDir" {printf("<%s",$3); for (i = 4; i < NF; i++) { printf("\\!%s",$i)}printf(">");done=1;} END { if (done != 1) {print "NONE"}}'' Jamfile'
        let res = system(acmd)
        " two failure modes - no Jamfile (shell_error = 1) or jamfile had no 
        " SubDir in it
        " in which case just do a plain "jam -q" in the source directory of
        " the file
        if v:shell_error == 0  && res != 'NONE'
            let gfile = res.objfile
        else
            let gfile = ""
        endif
        let cmd = '( cd ' . srcdir . ' ; jam -q ''' . gfile.''''
    endif
    let cmd = cmd . ' 2>&1 '
    if type == 3 
        let cmd = cmd . '; mkdbms 2>&1 '
    endif

    "output to our temp file but tee to screen (could take a while, user needs
    "to see something's happening)
    let cmd = cmd . ') | tee ' . tmpfile
    silent execute '! '.cmd
    " the silent above tends to screw up the screen so redraw to fix it
    redraw!
    if logtype == 1
        " create quickfix from errors and warnings
        let qcmd = 'egrep -e error: '
        if warnings == 2 
            let qcmd = qcmd . '-e warning: '
        endif
        let qcmd = qcmd . tmpfile . ' | sort -u'
        let res=system(qcmd) 
        silent cexpr res
        cwindow 5
    else
        " read temp file into a buffer
        " name, set it to nofile (which stops vim prompting to save it before
        " exit) and set to delete on hide
        let save_split=&splitright
        execute ':set splitright'
        execute 'vnew | silent read ' .tmpfile
        execute 'set buftype=nofile'
        execute 'set bh=delete'
        execute 'silent file jam.log'
        if !save_split
            execute ':set nosplitright'
        endif
    endif

    let res = system ('rm -f '. tmpfile)
    
endfunction

" define commands for versions of RunJam
command! -nargs=? Jamall call RunJam(1,<args>)
command! -nargs=? Jam call RunJam(2,<args>)
command! -nargs=? Jamdbms call RunJam(3,<args>)


" set tags to be current $ING_SRC one - use let as this will change when we
" change ING_SRC i.e. switch build areas
let &tags=$ING_SRC.'/tags,'.$TREASURE_ROOT.'/tags'
if exists("$SRCS")
    let &tags=&tags.','.$SRCS.'/x100/src/tags'
endif
let &tags=&tags.',./tags'

" note about path - this allows me to do "find file" or "find pattern<tab>"
" to load a file. However it's really intended for include files.
" Turns out vim has its own ctags type stuff using include files, see help 
" checkpath or help [i, [d
" According to this guy:
" https://begriffs.com/posts/2019-07-19-history-use-vim.html#include-and-path
" using path this way is a "poor man's fuzzy finder"
" he suggests setting up a mapping such as:
"
"nnoremap <leader>e :e $ING_SRC/**/
"
" after some experimentation I have decided:
"  - yes it's misusing the feature but it works
"  - ctags+cscope does the include stuff way better
"  - the key mapping doesn't allow for tab-completion
"  - I avoid having to install another plugin for a real fuzzy finder
" so for now it stays
set path +=$ING_SRC/**,$SRCS/x100/**

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
    let g:phelp_vim="~/.vimrc"
else
    let g:phelp_vim=user_vim
endif
nnoremap <F1> :call PaulVimHelp(g:phelp_vim)<CR>
command! PHelp :call PaulVimHelp(g:phelp_vim)

" variable to track whether help window is open
let g:pvhelp_is_open = 0

"function to generate help from this file (see [HELP] comments)
function! PaulVimHelp(vimrc_file)
    " construct help file name
    if !exists("$USER")
        let user='maspa05'
    else
        let user=$USER
    endif
    let help_file = '~/.vim/doc/vimhelp.'.user.'.txt'

    " regenerate help file only if this file is newer
    let res = system('test '. a:vimrc_file . ' -nt ' . help_file)
    if v:shell_error == 0
        let res = system('echo \" vim: filetype=help >' . help_file)
        let res = system('echo *PV_Help* >' . help_file)
        let cmd='grep "^\"[[:space:]]\+\[HELP\]" ' .a:vimrc_file . '| cut -d] -f2- | '
        let cmd = cmd . 'awk ''{split($0,a,"~");printf("%-40s : %s\n",a[1],a[2])}'' >> ' . help_file
        let res = system(cmd)
        redraw!
    endif

    "toggle help
    if g:pvhelp_is_open
        help
        close
        let g:pvhelp_is_open = 0
    else
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

" [HELP] Alt-] ~ save file and do ctrl-] (find tag)
nnoremap <c-[>] :update<CR><c-]>

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
fun! ShowSyntaxColours()
    set wildcharm=0
    source $VIMRUNTIME/syntax/hitest.vim
    set wildcharm=<tab>
endf
nnoremap c<F3> :call ShowSyntaxColours()<CR>


" [HELP] F4 ~ vimdiff of current file (against revisions which was opened)
nnoremap <F4>  :PDiff 0<CR>

" [HELP] spF4 ~ p rcompare of current file (against head rev)
nnoremap <space><F4>  :call Psuite(4)<CR>
command! -nargs=? Pcomphr call Psuite(4)

" [HELP] vF4 ~ vimdiff of current file (against head rev)
nnoremap v<F4>  :PDiff 1<CR>

" [HELP] tF4 ~ vimdiff of current file (against revision entered by user)
nnoremap t<F4>  :PDiff 2<CR>

" [HELP] rF4 ~ vimdiff of current file two revisions entered by user
nnoremap r<F4>  :PDiff 3<CR>

" [HELP] cF4 ~ p rcompare of current file (against revision which was opened)
nnoremap c<F4>  :call Psuite(3)<CR>
command! -nargs=? Pcomp call Psuite(3)

" [HELP] fF4 ~ filelog of current file in vert split
nnoremap f<F4>  :call Filelog(1)<CR>
command! -nargs=? Filelog call Filelog(<args>)
function! Filelog(...)
    if a:0 == 0
        let type=1
    else
        let type=a:1
    endif
    let fname  = expand("%:p:t")
    let fpath  = expand("%:p:h")
    if type == 1
        execute 'vnew | 0read ! cd '. fpath . '; p filelog ' . fname
    else
        execute 'new | 0read ! cd '. fpath . '; p filelog ' . fname
    endif
    call cursor(1,1)
    execute ":set buftype=nofile"
endfunc

command! -nargs=? PDiff call VPDiff(<q-args>)
" VPDiff - compare current file with svn/pic version
"          3 'types' 
"                    0 - compare with same revision in repo
"                    1 - compare with headrevs
"                    2 - compare with a version we prompt for
"                    3 - compare two prompted for versions with each other
function! VPDiff(...)
    if a:0 == 0
        let type=0
    else
        if a:1 == 'help' || a:1 > 3
            echo "PDiff [N]  do vimdiff against another version of the file"
            echo " N = 0 compare with same version in repo (i.e. changes in working copy only)"
            echo " N = 1 compare with headrevs version"
            echo " N = 2 prompt for version to compare with"
            echo " N = 3 prompt for two versions to compare (current file will be hidden)"
            echo "        if no argument is given default is 0"
            echo " "
            return
        endif
        let type=a:1
    endif

"save the filetype so we can set it later - preserves syntax highlighting
"for new buffer
    let ftype = &ft

    " various paths 
    "     fullnm - full filename including path
    "     filenm - just the filename
    "     bname  - buffer name (usually same as filenm)
    "     bpath  - just the path i.e. dir
    let fullnm = expand("%:p")
    let filenm = expand("%:p:t")
    let bname  = bufname("%")
    let bpath  = expand("%:p:h")

    " keep a copy of original buffer name
    let obname = bname 

" set srccntrl type 1=svn, 2=piccolo
" also set srcname - name for messages, and srcrevext for 'rev extension'
" part of buffer name
    let dummy=system("svn info ".fullnm." > /dev/null 2>&1")
    if v:shell_error == 0
        let srccntrl=1
        let srcname = "svn"
        let srcrevext = ".r"
    else
        let cver = system("cd " . bpath . "; p have " . filenm . " > /dev/null 2>&1")
        if v:shell_error == 0
            let srccntrl=2
            let srcname = "piccolo"
            let srcrevext = ".ver"
        else
            echoe "Failed to determine file source type (svn/piccolo)"
            return
        endif
    endif

    if type == 3
        call inputsave()
        let cver = input("Base version for diff ")
        call inputrestore()
        if (cver == '')
            echoe "You must specify a base version"
            return
        endif
        echon "\r"
        echo ''
        if srccntrl == 1
            let cmd = 'new | silent 0read ! svn cat -r ' . cver . ' ' . fullnm 
        else
            let cmd = 'new | silent 0read ! cd ' . bpath . '; p get -r ' . cver . ' -p '.filenm. ' | grep -v "^==="'
        endif
        execute cmd
        silent normal! $Gdd

        let b1name = bname. srcrevext. cver
        execute "set bh=delete"
        execute 'set filetype='.ftype
        execute 'silent file '. b1name
        execute ":set buftype=nofile"

        call GotoBuf(bname)
        close
        call GotoBuf(b1name)
        let revdef=cver+1
    else
        " get current revision number 
        if srccntrl == 1
            let cmd = 'svn info ' . fullnm . ' | grep "^Last Changed Rev:" | cut -c19- '
        else
            let cmd = "cd " . bpath . "; p have " . filenm . " | awk '{print $3}'"
        endif
        let getrevres = system(cmd)
        if v:shell_error != 0
                echoe "Failed to run command to get current " . srcname ." rev"
                echo "Result:"
                echo getrevres
                return
        endif
        let cver=split(getrevres)[0]
        let revdef=cver
    endif

    " do diff depending on type
    if type >= 2
        " 2 - prompt for ver/rev, default to current
        call inputsave()
        let inptxt = "Diff with ver (" . revdef . ") "
        let urev = input(inptxt)
        call inputrestore()
        if (urev == '')
            let urev = revdef
        endif
        echon "\r"
        echo ''


    elseif type == 1
        " 1 - diff with headrevs
        if srccntrl == 1
            let cmd = 'svn info -r HEAD ' . fullnm . ' | grep "^Last Changed Rev:" | cut -c19- '
        else
            let cmd = "cd " . bpath . " ; p need " . filenm .  " 2>&1  | awk 'BEGIN { n = 3 } /is up to/ { n = 9 } {printf( \"%s\", $n); exit}'"
        endif
        let getrevres = system(cmd)
        if v:shell_error != 0
            echoe "Failed to run " . srcname ." command to get HEAD rev"
            echo "Result:"
            echo getrevres
            return
        endif
        let urev=split(getrevres)[0]

        " add HEAD to buffername
        let bname = bname.".HEAD"
    else
        " 0 - diff with current version
        let urev = cver
    endif

    " full buffer name for new buffer
    let bname = bname. srcrevext. urev

    " read the output of 'get this rev'  into new virtical split
    if srccntrl == 1
        let cmd = 'rightbelow vnew | silent 0read ! svn cat -r ' . urev . ' ' . fullnm 
    else
        let cmd = 'rightbelow vnew | silent 0read ! cd ' . bpath . '; p get -r ' . urev . ' -p '.filenm. ' | grep -v "^==="'
    endif
    execute cmd

    " delete the blank line at the bottom that execute added
    silent normal! $Gdd
 
"    set some attributes to the new buffer
"    bh=delete means it will get deleted once we 'hide' it 
    execute "set bh=delete"
    " setting the filetype allows syntax highlighting matching original file
    " regardless of name
    execute 'set filetype='.ftype
    " set the buffer name we've created
    execute 'silent file '. bname
    " set the buffer type to nofile - means vim won't try to get us to save it
    execute "set buftype=nofile"

    " perform vimdiff - the windo means run on each window
    windo diffthis
    " last command left us on the original file, return to new buffer
    call GotoBuf(bname)

    " go to first diff chunk
    silent normal! 1G]c

    " set some autocmd for bufdelete
    " remove all autocmds first 
    au! * <buffer>
    " vimdiff sets cursorbind (crb) and scrollbind (scb) which is great for
    " the diff. But if we close the new buffer and later open a new virt split
    " if they are left set we'll get scrolling behaviour we don't want
    " especially if we open a new vert window to scroll to another part of the
    " same file
    " so this effectively says, when we close this buffer (the new one)
    " go to the original and unset crb and scb 
    let cmd="au BufDelete <buffer> call GotoBuf('" . obname . "')"
    execute cmd
    au BufDelete <buffer> set crb!
    au BufDelete <buffer> set scb!
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

" [HELP] F6o ~ run command and open in new buffer
nnoremap <F6>o  :call Cmdtobuf()<CR>
function! Cmdtobuf()
    call inputsave()
    let inpcmd = input("Command:")
    call inputrestore()
    let bname = 'cmd_out-'.g:cmdno
    let g:cmdno += 1
    if (inpcmd != '')
        let save_split=&splitright
        execute ":set splitright"
        execute 'vnew | 0read ! '.inpcmd
        execute ":silent file ".bname
        execute ":set buftype=nofile"
        if !save_split
            execute ":set nosplitright"
        endif
    endif
endfunc

" [HELP] F6 ~ Make Window wider
nmap <F6>  <c-w>>
" [HELP] F7 ~ Make Window taller
nmap <F7>  <c-w>+
" [HELP] F7d ~ p describe of change number under cursor
nnoremap <F7>d  :call DescribeCurword(2)<CR>
command! -nargs=? DescribeCurword call DescribeCurword(<args>)
function! DescribeCurword(...)
    if a:0 == 0
        let type=1
    else
        let type=a:1
    endif
    let fpath  = expand("%:p:h")
    let cno = expand("<cword>")
    if type == 1
        execute 'vnew | silent 0read ! cd '. fpath . '; p describe ' . cno
    else
        execute 'new | silent 0read ! cd '. fpath . '; p describe ' . cno
    endif
    call cursor(1,1)
    execute ":set buftype=nofile"
endfunc

" [HELP] F7o ~ Make current Window the only one
nnoremap <F7>o :only<cr>

" [HELP] F8 ~ Make Windows equal(ish) size
nmap <F8>  <c-w>=

" [HELP] \< ~ jump to location of prev build error (in code window)
nnoremap <leader>, :cp<CR>
" [HELP] \/ ~ jump to current build error (will be there by default, but if you've moved away, to another buffer, followed a tag)
nnoremap <leader>/  :cc<CR>
" [HELP] \. ~ jump to next build error
nnoremap <leader>. :cn<CR>

" the following commands are not compilation so just call them with !
" not via Make
"
" [HELP] F9 ~ open the current file in psuite and reload in the editor
nnoremap <F9> :call Psuite(1)<CR>
command! -nargs=? Pop call Psuite(1)
function! Psuite(type)
   
    let fname = expand("%:p:t")
    let fpath = expand("%:p:h")

    if a:type == 1
        let pcmd = 'pop'
    elseif a:type == 2
        let pcmd = 'prelease'
    elseif a:type == 3
        let getrevres = system("cd " . fpath . "; p have " . fname . " | awk '{print $3}'")
        let cver = split(getrevres)[0]
        if v:shell_error == 0
            let pcmd = 'p rcompare -r' . cver 
        else
            echoe "Failed to determine current version for ".fname
            return
        endif
    elseif a:type == 4
        let pcmd = 'p rcompare'
    else
        let pcmd = 'echo'
    endif

    execute '!cd ' . fpath .'; ' . pcmd . ' ' . fname
endfunc

" [HELP] F10 ~ release the current file in psuite and reload in the editor
command! -nargs=? Prelease call Psuite(2)
nnoremap <F10> :call Psuite(2)<CR>

" [HELP] Build Commands
" [HELP] ~default is to create a quickfix window
" [HELP] ~\ versions create a buffer with logfile instead
" [HELP] F11 ~ save and build the file you're editing
" [HELP]  ~ (command :Jam)
nnoremap <F11> :w<CR>:call RunJam(2)<cr>
" [HELP] wF11 ~ save and build the file you're editing, show warnings as well
" [HELP]  ~ as errors (command :Jam (1,2))
nnoremap w<F11> :w<CR>:call RunJam(2,1,2)<cr>
" [HELP] \F11 ~ save and build the file you're editing with logfile
" [HELP]  ~ (command :Jam 2)
nnoremap <leader><F11> :w<CR>:call RunJam(2,2)<cr>
" [HELP] F12 ~ save, build and mkdbms 
" [HELP]  ~ (command :Jamdbms)
nnoremap <F12> :w<CR>:call RunJam(3)<cr>
" [HELP] wF12 ~ save, build and mkdbms with warnings
" [HELP]  ~ (command :Jamdbms)
nnoremap e<F12> :w<CR>:call RunJam(3,1,2)<cr>
" [HELP] \F12 ~ save, build and mkdbms with logfile
" [HELP]  ~ (command :Jamdbms 2)
nnoremap <leader><F12> :w<CR>:call RunJam(3,2)<cr>

" [HELP] F12F12 ~ save and build from ING_SRC 
" [HELP]  ~ (command :Jamall)
nnoremap <F12><F12> :w<CR>:call RunJam(1)<cr>
" [HELP] wF12F12 ~ save and build from ING_SRC with warnings
" [HELP]  ~ (command :Jamall)
nnoremap w<F12><F12> :w<CR>:call RunJam(1,1,2)<cr>
" [HELP] \F12F12 ~ save and build from ING_SRC with logfile
" [HELP]  ~ (command :Jamall 2)
" [HELP]
nnoremap <leader><F12><F12> :w<CR>:call RunJam(1,2)<cr>
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

" set cscope to come out in quickfix window
" - means clear window before adding results
set cscopequickfix=s-,c-,d-,i-,t-,e-,g-

function! Toggle_cscope()
    if (&cscopetag)
        echo "CSCOPE disabled"
        set nocscopetag
    else
        echo "CSCOPE enabled"
        set cscopetag
    endif
endfunction

if has("cscope")
    let cscope_file=$ING_ROOT.'/cscope/cscope.out'
    if filereadable( cscope_file )
        set cscopetag
        cs add $ING_ROOT/cscope/cscope.out
        if exists("$SRCS")
            let x100_cscope_file=$SRCS.'/cscope/cscope.out'
            if filereadable( x100_cscope_file )
                cs add $SRCS/cscope/cscope.out
            endif
        endif
        set nocscopetag

" [HELP] F6sp ~ Enable/Disable CSCOPE
        nnoremap <F6><space> :call Toggle_cscope()<CR>
" [HELP] F6c ~ find all calls to the function name under cursor
        nnoremap <F6>c :cs find c <C-R>=expand("<cword>")<CR><CR>:cw<CR>
" [HELP] F6d ~ find all functions that function name under cursor calls
        nnoremap <F6>d :cs find d <C-R>=expand("<cword>")<CR><CR>:cw<CR>
" [HELP] F6e ~ prompt for file and open it
        nnoremap <F6>e :cs find f 
" [HELP] F6f ~ open file under cursor
        nnoremap <F6>f :cs find f <C-R>=expand("<cword>")<CR><CR>:cw<CR>
" [HELP] F6g ~ find global definitions of word under cursor
        nnoremap <F6>g :cs find g <C-R>=expand("<cword>")<CR><CR>:cw<CR>
" [HELP] F6i ~ find files that include file under cursor
        nnoremap <F6>i :cs find i <C-R>=expand("<cword>")<CR><CR>:cw<CR>
" [HELP] F6s ~ find all references to the token under the cursor
        nnoremap <F6>s :cs find s <C-R>=expand("<cword>")<CR><CR>:cw<CR>
" [HELP] F6t ~ find all instances of text under cursor
        nnoremap <F6>t :cs find t <C-R>=expand("<cword>")<CR><CR>:cw<CR>
" [HELP] F6= ~ find all instances of variable under cursor being assigned
        nnoremap <F6>= :cs find e <C-R>=expand("<cword>")<CR>[ ]*=[^=]<CR>:cw<CR>
    else
        nnoremap <F6>c :echo cscope_file."exists but is not readable. Please re-run ctagger."<CR>
        nnoremap <F6>d :echo cscope_file."exists but is not readable. Please re-run ctagger."<CR>
        nnoremap <F6>e :echo cscope_file."exists but is not readable. Please re-run ctagger."<CR>
        nnoremap <F6>f :echo cscope_file."exists but is not readable. Please re-run ctagger."<CR>
        nnoremap <F6>g :echo cscope_file."exists but is not readable. Please re-run ctagger."<CR>
        nnoremap <F6>i :echo cscope_file."exists but is not readable. Please re-run ctagger."<CR>
        nnoremap <F6>s :echo cscope_file."exists but is not readable. Please re-run ctagger."<CR>
        nnoremap <F6>t :echo cscope_file."exists but is not readable. Please re-run ctagger."<CR>
    endif
else
    nnoremap <F6>c :echo "cscope not setup. Please run ctagger."<CR>
    nnoremap <F6>d :echo "cscope not setup. Please run ctagger."<CR>
    nnoremap <F6>f :echo "cscope not setup. Please run ctagger."<CR>
    nnoremap <F6>g :echo "cscope not setup. Please run ctagger."<CR>
    nnoremap <F6>i :echo "cscope not setup. Please run ctagger."<CR>
    nnoremap <F6>s :echo "cscope not setup. Please run ctagger."<CR>
    nnoremap <F6>t :echo "cscope not setup. Please run ctagger."<CR>
endif

" the following are default mappings that are here so they get displayed with
" help:
" [HELP] regular vim commands (default mappings)
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
" [HELP] << ~ indent to the left
" [HELP] >> ~ indent to the right
" [HELP] Ctrl-X Ctrl-P ~ in insert mode try to complete current symbol based on contents of current file (previous match)
" [HELP] Ctrl-X Ctrl-N ~ in insert mode try to complete current symbol based on contents of current file (next match)
" [HELP] Ctrl-X Ctrl-O ~ in insert mode try to complete current symbol based on known tags, includes fields within structures
" [HELP] v {choose range} ESC /\%Vsearchterm ~ search for 'searchterm' in chosen range, e.g. function

