scriptencoding utf-8

"http://inlehmansterms.net/2014/10/31/debugging-vim/
"set verbose=15
"set verbosefile=~/.vim.log

set nocompatible              " be iMproved, required
filetype off                  " required

if !has("nvim")

  set rtp+=~/.vim/bundle/Vundle.vim
  call vundle#begin()
  Plugin 'Valloric/YouCompleteMe'
  call vundle#end()            " required
  "filetype plugin indent on    " required

  "let g:ycm_global_ycm_extra_conf="~/.vim/.ycm_extra_conf.py"
  "let g:ycm_confirm_extra_conf=1
  "let g:ycm_auto_trigger=1
  let g:ycm_add_preview_to_completeopt=0
endif

" I get a weird window at the top of my file when I use the semantic engine
" 
" This is Vim's preview window. Vim uses it to show you extra information about
" something if such information is available. YCM provides Vim with such extra
" information. For instance, when you select a function in the completion list,
" the preview window will hold that function's prototype and the prototypes of
" any overloads of the function. It will stay there after you select the
" completion so that you can use the information about the parameters and their
" types to write the function call.
" 
" If you would like this window to auto-close after you select a completion
" string, set the g:ycm_autoclose_preview_window_after_completion option to 1 in
" your vimrc file. Similarly, the g:ycm_autoclose_preview_window_after_insertion
" option can be set to close the preview window after leaving insert mode.
" 
" If you don't want this window to ever show up, add set completeopt-=preview to
" your vimrc. Also make sure that the g:ycm_add_preview_to_completeopt option is
" set to 0.
set completeopt-=preview
" FUCK OFF AND DIE

set csprg=gtags-cscope
if filereadable("GTAGS")
  cs add GTAGS
endif

" Highlight search terms.
set hlsearch

" Indentation is 2 spaces.
set shiftwidth=2
set tabstop=2
set sts=2

" Highlight trailing whitespace with dots, highlight tabs with double arrows.
set list lcs=trail:·,tab:»»

" When pressing the tab key, insert spaces instead.
set expandtab

" vim: set fenc=utf-8 tw=80 sw=2 sts=2 et foldmethod=marker :
"au BufNewFile,BufRead *.cpp set syntax=cpp11
au BufNewFile,BufRead *.rs set syntax=rust
au BufNewFile,BufRead * set scrolloff=10
au BufRead,BufNewFile *.md set filetype=markdown
au BufNewFile,BufRead *.ml set tabstop=2 shiftwidth=2 expandtab

" Map WINDOWS+T to Latin Cross, WINDOWS+Y for Lambda.
imap @st †
imap @sy λ

if filereadable("cscope.out")
  cs add cscope.out
endif

"So, open a file in vi as usual, hit escape and type:
"`:%!xxd` to switch into hex mode
"And when your done hit escape again and type:
"`:%!xxd -r` to exit from hex mode.

let g:slime_target = "tmux"
:autocmd Syntax * syn match ExtraWhitespace /\s\+$/
set wildmode=longest,list

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""" Custom spash screen """""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
fun! Start()

  "Create a new unnamed buffer to display our splash screen inside of.
  enew

  " Set some options for this buffer to make sure that does not act like a
  " normal winodw.
  setlocal
    \ bufhidden=wipe
    \ buftype=nofile
    \ nobuflisted
    \ nocursorcolumn
    \ nocursorline
    \ nolist
    \ nonumber
    \ noswapfile
    \ norelativenumber

  " Our message goes here. Mine is simple.
  "call append('$', "hello")
  exec ":r !fortune || true"
  exec ":r !echo"

  if filereadable(glob("~/.vim/splash/splash.txt"))
    exec ":r ~/.vim/splash/splash.txt"
  endif


  " When we are done writing out message set the buffer to readonly.
  setlocal
    \ nomodifiable
    \ nomodified

  " Just like with the default start page, when we switch to insert mode
  " a new buffer should be opened which we can then later save.
  nnoremap <buffer><silent> e :enew<CR>
  nnoremap <buffer><silent> i :enew <bar> startinsert<CR>
  nnoremap <buffer><silent> o :enew <bar> startinsert<CR>

endfun

" http://learnvimscriptthehardway.stevelosh.com/chapters/12.html
" Autocommands are a way of setting handlers for certain events.
" `VimEnter` is the event we want to handle. http://vimdoc.sourceforge.net/htmldoc/autocmd.html#VimEnter
" The cleene star (`*`) is a pattern to indicate which filenames this Autocommand will apply too. In this case, star means all files.
" We will call the `Start` function to handle this event.

" http://vimdoc.sourceforge.net/htmldoc/eval.html#argc%28%29
" The number of files in the argument list of the current window.
" If there are 0 then that means this is a new session and we want to display
" our custom splash screen.
if argc() == 0
  autocmd VimEnter * call Start()
endif

function! Banner()

ruby <<EOF

  def banner
    line = $curbuf.line

    if /-+\[ (?<text>[^\]]+)\]-+/ =~ line then
      line = text.gsub(/\W+$/, '')
    end

    len = line.length
    max = 80

    pad = (max - (len + 4))

    if pad < 2 then
      puts "Line too long."
      return
    end

    pad /= 2

    new_line = ""
    new_line += "-" * pad
    new_line += "-" if len % 2 != 0
    new_line += "[ " + line + " ]"
    new_line += "-" * pad

    line_number = $curbuf.line_number
    $curbuf[line_number] = new_line
  end

  banner
EOF
endfunction

function! Man(page)
  "Create a new unnamed buffer to display our splash screen inside of.
  tabnew

  " Set some options for this buffer to make sure that does not act like a
  " normal winodw.
  setlocal
    \ bufhidden=wipe
    \ buftype=nofile
    \ nobuflisted
    \ nocursorcolumn
    \ nocursorline
    \ nolist
    \ nonumber
    \ noswapfile
    \ norelativenumber

  " Our message goes here. Mine is simple.
  "call append('$', "hello")
  exec ":r !man" a:page

  " When we are done writing out message set the buffer to readonly.
  setlocal
    \ nomodifiable
    \ nomodified

  "" Just like with the default start page, when we switch to insert mode
  "" a new buffer should be opened which we can then later save.
  "nnoremap <buffer><silent> e :enew<CR>
  "nnoremap <buffer><silent> i :enew <bar> startinsert<CR>
  "nnoremap <buffer><silent> o :enew <bar> startinsert<CR>
endfunction

" Without the range keyword, function will run once per Visual selected line
function! Box() range
ruby <<EOF

  def box
    _, st_lnum, st_col, _ = Vim::evaluate("getpos(\"'<\")")
    _, en_lnum, en_col, _ = Vim::evaluate("getpos(\"'>\")")

    longest = 0
    (st_lnum..en_lnum).each do |i|
      l = $curbuf[i].length
      longest = l if l > longest
    end

    (st_lnum..en_lnum).each do |i|
      l = $curbuf[i].length
      d = longest - l
      pl = d / 2
      pr = d / 2 + if d % 2 == 0 then 0 else 1 end
      $curbuf[i] = "| #{' ' * pl}#{$curbuf[i]}#{' ' * pr} |"
    end

    $curbuf.append(st_lnum-1, "+-#{'-' * longest}-+")
    $curbuf.append(en_lnum+1, "+-#{'-' * longest}-+")
  end

  box
EOF
endfunction

function! UnBox() range
ruby <<EOF

  def unbox
    _, st_lnum, st_col, _ = Vim::evaluate("getpos(\"'<\")")
    _, en_lnum, en_col, _ = Vim::evaluate("getpos(\"'>\")")

    (st_lnum..en_lnum).each do |i|
      $curbuf[i] = $curbuf[i].sub(/^\| +/, '')
      $curbuf[i] = $curbuf[i].sub(/ +\|/, '')
      $curbuf[i] = $curbuf[i].sub(/^\+-+\+/, '')
    end
  end

  unbox
EOF
endfunction

function! JiraCommentRef()
ruby <<EOF
  def jira_comment_ref
    line = $curbuf.line
    if /(?<id>comment-\d+)$/ =~ line then
      $curbuf.line = "[#{id}|#{line}]"
    end
  end

  jira_comment_ref
EOF
endfunction

function! JiraQuote() range
ruby <<EOF
  def jira_quote
    _, st_lnum, st_col, _ = Vim::evaluate("getpos(\"'<\")")
    _, en_lnum, en_col, _ = Vim::evaluate("getpos(\"'>\")")

    (st_lnum..en_lnum).each do |i|
      $curbuf[i] = "{color:#00875a}>#{$curbuf[i]}{color}"
    end
  end

  jira_quote
EOF
endfunction

function! JiraRbLink() range
ruby <<EOF
  def rb_link
    _, st_lnum, st_col, _ = Vim::evaluate("getpos(\"'<\")")
    _, en_lnum, en_col, _ = Vim::evaluate("getpos(\"'>\")")

    if st_lnum != en_lnum then
      puts "A multiline hyperlink? I don't think so, human."
      return
    end

    ref = $curbuf[st_lnum][(st_col-1)..(en_col-1)]
    if ref !~ /^\/r\/\d+$/ then
      puts "What the heck is #{ref}?"
      puts "Try something like /r/12345"
      return
    end

    st = st_col-2
    st = 0 if st < 0

    if st_col > 1 then
      st = $curbuf[st_lnum][0..(st_col - 2)]
    else
      st = ""
    end
    en = $curbuf[st_lnum][(en_col)..-1]

    $curbuf[st_lnum] = st +
      "[#{ref}|https://reviewboard.solarflarecom.com#{ref}]" +
      en
  end

  rb_link
EOF
endfunction

nmap <C-b> :call Banner()<CR>
vmap <C-b> :call Box()<CR>
noremap K :call Man(expand("<cword>"))<cr>

"so $MYVIMRC
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""" Gentoo Settings """""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Default configuration file for Vim
" $Header: /var/cvsroot/gentoo-x86/app-editors/vim-core/files/vimrc-r4,v 1.3 2010/04/15 19:30:32 darkside Exp $

" Written by Aron Griffis <agriffis@gentoo.org>
" Modified by Ryan Phillips <rphillips@gentoo.org>
" Modified some more by Ciaran McCreesh <ciaranm@gentoo.org>
" Added Redhat's vimrc info by Seemant Kulleen <seemant@gentoo.org>

" You can override any of these settings on a global basis via the
" "/etc/vim/vimrc.local" file, and on a per-user basis via "~/.vimrc". You may
" need to create these.

" {{{ General settings
" The following are some sensible defaults for Vim for most users.
" We attempt to change as little as possible from Vim's defaults,
" deviating only where it makes sense
set nocompatible        " Use Vim defaults (much better!)
set bs=2                " Allow backspacing over everything in insert mode
set ai                  " Always set auto-indenting on
set history=50          " keep 50 lines of command history
set ruler               " Show the cursor position all the time

set viminfo='20,\"500   " Keep a .viminfo file.

" Don't use Ex mode, use Q for formatting
map Q gq

" }}}

" {{{ Locale settings
if v:lang =~? "^ja_JP"
  set fileencodings=euc-jp
  set guifontset=-misc-fixed-medium-r-normal--14-*-*-*-*-*-*-*
endif

" If we have a BOM, always honour that rather than trying to guess.
if &fileencodings !~? "ucs-bom"
  set fileencodings^=ucs-bom
endif

" Always check for UTF-8 when trying to determine encodings.
if &fileencodings !~? "utf-8"
  " If we have to add this, the default encoding is not Unicode.
  " We use this fact later to revert to the default encoding in plaintext/empty
  " files.
  let g:added_fenc_utf8 = 1
  set fileencodings+=utf-8
endif

" Make sure we have a sane fallback for encoding detection
if &fileencodings !~? "default"
  set fileencodings+=default
endif
" }}}

syntax on


" {{{ Autocommands
if has("autocmd")

augroup gentoo
  au!

  " Gentoo-specific settings for ebuilds.  These are the federally-mandated
  " required tab settings.  See the following for more information:
  " http://www.gentoo.org/proj/en/devrel/handbook/handbook.xml
  " Note that the rules below are very minimal and don't cover everything.
  " Better to emerge app-vim/gentoo-syntax, which provides full syntax,
  " filetype and indent settings for all things Gentoo.
  au BufRead,BufNewFile *.e{build,class} let is_bash=1|setfiletype sh
  au BufRead,BufNewFile *.e{build,class} set ts=4 sw=4 noexpandtab

  " In text files, limit the width of text to 78 characters, but be careful
  " that we don't override the user's setting.
  autocmd BufNewFile,BufRead *.txt
        \ if &tw == 0 && ! exists("g:leave_my_textwidth_alone") |
        \     setlocal textwidth=78 |
        \ endif

  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
        \ if ! exists("g:leave_my_cursor_position_alone") |
        \     if line("'\"") > 0 && line ("'\"") <= line("$") |
        \         exe "normal g'\"" |
        \     endif |
        \ endif

  " When editing a crontab file, set backupcopy to yes rather than auto. See
  " :help crontab and bug #53437.
  autocmd FileType crontab set backupcopy=yes

  " If we previously detected that the default encoding is not UTF-8
  " (g:added_fenc_utf8), assume that a file with only ASCII characters (or no
  " characters at all) isn't a Unicode file, but is in the default encoding.
  " Except of course if a byte-order mark is in effect.
  autocmd BufReadPost *
        \ if exists("g:added_fenc_utf8") && &fileencoding == "utf-8" && 
        \    ! &bomb && search('[\x80-\xFF]','nw') == 0 && &modifiable |
        \       set fileencoding= |
        \ endif

augroup END

endif " has("autocmd")
" }}}

nnoremap <C-o> :set invpaste paste?<CR>
set pastetoggle=<C-o>
set showmode

highlight DiffAdd    ctermbg=234
highlight DiffDelete ctermbg=234
highlight DiffChange ctermbg=234
highlight DiffText   ctermbg=88
"highlight DiffAdd    cterm=bold ctermfg=10 ctermbg=17
"highlight DiffDelete cterm=bold ctermfg=10 ctermbg=17
"highlight DiffChange cterm=bold ctermfg=10 ctermbg=17
"highlight DiffText   cterm=bold ctermfg=10 ctermbg=88
"
"reload vimrc
" :so $MYVIMRC

" block append do not use $ before or after the block select
"
" 1. manually extend first line to desired length
" a   =>   a   
" bb  =>   bb
" a   =>   a
" bbc =>   bbc
" a   =>   a
"
" 2. Go to end of first line with l *not $*, C-v, jjjj, A, text...
" a   =>   a   |
" bb  =>   bb  |
" a   =>   a   |
" bbc =>   bbc |
" a   =>   a   |
"
" 3. Navigating to end of line with $ causes this
" a   =>   a   |
" bb  =>   bb|
" a   =>   a|
" bbc =>   bbc|
" a   =>   a|
