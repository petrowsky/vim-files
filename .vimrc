" Author: Michael Sanders (msanders42 [at] gmail [dot] com)

set shm=atI " Disable intro screen
set hi=50 " Only store past 50 commands
set ul=150 " Only undo up to 150 times
set lz " Don't redraw screen during macros
set tf " Improves redrawing for newer computers
set titlestring=%f title " Display filename in terminal window
set ruf=%l:%c ru " Display current column/line in bottom right
set sc " Show incomplete command at bottom right
set bs=2 " Allow backspacing over anything
set wrap lbr pt=<f2> spl=en_us
set ic scs " Only be case sensitive when search contains uppercase
ru macros/matchit.vim " Enabled extended % matching
set nobk nowb noswf " Disable backup
" Enable command-line tab completion & hide irrelevant matches
set wim=full wmnu wig+=*.o,*.obj,*.pyc,*.DS_Store,*.db
set sb " Open new split windows below current
set smc=300 " Disable syntax highlighting on long lines
set gd " Assume /g flag on :s searches
set nofen fdm=indent " Close folds by default & create folds at every indent
set hid " Allow hidden buffers
set tm=500 " Lower timeout for mappings
set enc=utf-8
set cot=menu " Don't show extra info on completions
set report=0 " Always report when lines are changed

if has('gui_running')
	" Disable blinking cursor & default menus in gvim, and set font to
	" I've also defined some custom menus in my .gvimrc.
	set gcr=a:blinkon0 go=haMR
	set columns=100 lines=25 fuoptions=maxvert,maxhorz
endif

" Indentation
filetype plugin indent on
set ai ts=4 sw=4

" Theme
set t_Co=16 " Enable 16 colors
syn on | colo slate " My color scheme, adopted from TextMate
set cul hls " Highlight current line & search terms
if &diff | syn off | en " Turn syntax highlighting off for diff

" Plugin Settings
let snips_author = 'Michael Sanders'
let bufpane_showhelp = 0

" Correct some spelling mistakes
ia teh the
ia htis this
ia tihs this
ia eariler earlier
ia funciton function
ia funtion function
ia fucntion function
ia retunr return
ia reutrn return
ia foreahc foreach
ia !+ !=
ca eariler earlier
ca !+ !=

" Mappings
let mapleader = ','
" ^ is much more useful to me than 0
no 0 ^
no ^ 0
" Scroll down faster
no <s-j> 2<c-e>
no <s-k> 3<c-y>
" Swap ' and ` keys (` is much more useful)
no ` '
no ' `
" Much easier to type commands this way
no ; :
" Keep traditional ; functionality
no \ ;
" Keep traditional , functionality
no _ ,
" I always make this typo
no "- "_
" Paste yanked text
no gp "0p
no gP "0P

" gj/gk treat wrapped lines as separate
" (i.e. you can move up/down in one wrapped line)
nn j gj
nn k gk
" Keep traditional J functionality
nn <c-h> J
" Keep traditional K functionality
nn <c-l> K
" Make Y behave like D and C
nn Y y$
" Increment/decrement numbers
nn + <c-a>
nn - <c-x>
" Add a blank line while keeping cursor position
nn <silent> <c-o> :cal append('.', '')<cr>:sil! cal repeat#set("\<c-o>")<cr>
" Make space toggle folds
nn <space> zA
nn <m-space> za
" Easier ways to navigate windows
nn , <c-w>
nn ,, <c-w>p
nn ,W <c-w>w
nn ,n :vnew<cr>
nn ,w :w<cr>
nn ,x :x<cr>
" Switch to alternate window (mnemonic: ,alt)
nn ,a <c-^>
nn ,o <c-o>
" Vimshell keybindings
if !&cp && has('vimshell')
	nn <silent> ,e :new \|vimshell! bash<cr>
	nn <silent> ,E :vnew \| vimshell! bash<cr>
endif
" Standard (full-screen) shell
nn ,S :sh<cr>
" Switch to current dir
nn ,d :lcd %:p:h<cr>
" Toggle spell checking
nn <silent> ,D :se spell!<cr>
" Hide/show line numbers (useful for copying & pasting)
nn <silent> ,# :se invnumber<cr>
" Highlight/unhighlight lines over 80 columns
nn ,H :cal <SID>ToggleLongLineHL()<cr>
" Turn off search highlighting
nn <silent> <c-n> :noh<cr>
" List trailing whitespace
nn <silent> ,<space>  :se nolist!<cr>
nn <silent> ,R :cal<SID>RemoveWhitespace()<cr>
" Reload .vimrc
nn ,L :so $MYVIMRC<cr>
" Make c-g show full path/buffer number too
nn <c-g> 2<c-g>

" Easier navigation in command mode
no! <c-a> <home>
no! <c-e> <end>
cno <c-h> <left>
cno <c-l> <right>
cno <c-b> <s-left>
cno <c-f> <s-right>
" Make c-k delete to end of line, like in Bash
cno <c-k> <c-\>estrpart(getcmdline(), 0, getcmdpos()-1)<cr>
cno jj <c-c>

" Map these in visual mode, but not select
xno j gj
xno k gk
" vm selects until the end of line (but not including the newline char)
xno m $h
" Pressing v again brings you out of visual mode
xno v <esc>
" * and # search for next/previous of selected text when used in visual mode
xno * :<c-u>cal <SID>VisualSearch()<cr>/<cr>
xno # :<c-u>cal <SID>VisualSearch()<cr>?<cr>
" Pressing backspace in visual mode deletes to black hole register
xno <bs> "_x
" Pressing gn in visual mode counts characters in selection
xno gn :<c-u>cal <SID>CountChars()<cr>

" Easier navigation in insert mode
ino <silent> <c-b> <esc>bi
ino <silent> <c-f> <esc>ea
ino <c-h> <left>
ino <c-l> <right>
" <c-p> & <c-n> will move up/down if popup menu not
" up; otherwise, they will select items in the menu
ino <expr> <c-p> pumvisible() ? '<c-p>' : '<c-o>gk'
ino <expr> <c-n> pumvisible() ? '<c-n>' : '<c-o>gj'
im <up> <c-p>
im <down> <c-n>
ino <c-k> <c-o>D
" Much easier than reaching for escape
ino jj <esc>
" Open/close completion menu
ino <expr> jx pumvisible() ? '<esc>a' : '<c-p>'
" Insert a newline & keep cursor position
ino <silent> <c-j> <c-o>:cal append('.', '')<cr>

hi OverLength ctermbg=none cterm=none
match OverLength /\%>80v/
fun! s:ToggleLongLineHL()
	if !exists('w:overLength')
		let w:overLength = matchadd('ErrorMsg', '.\%>80v', 0)
		echo 'Long lines highlighted'
	else
		cal matchdelete(w:overLength)
		unl w:overLength
		echo 'Long lines unhighlighted'
	endif
endf

fun! s:VisualSearch()
  let old = @" | norm! gvy
  let @/ = '\V'.substitute(escape(@", '\'), '\n', '\\n', 'g')
  let @" = old
endf

fun! s:CountChars()
	let old = @"
	sil! norm! gvy
	let l = len(@")
	echo l > 1 ? 'There were '.l.' characters in the selechotion.'
			\  : 'There was 1 character in the selechotion.'
	let @" = old
endf

" This is a modified version of something I found on the Vim wiki.
" It allows you to align a selection by typing ":Align {pattern}<cr>".
com! -nargs=? -range Align <line1>,<line2>cal Align('<args>')
xno <silent> ,a :Align<cr>
fun! Align(regex) range
	let blockmode = visualmode() !=? 'v'
	if blockmode
		let old = @"
		sil norm! gvy
		let @" = old
		let section = split(@", "\n")
	else
		let section = getline(a:firstline, a:lastline)
	endif
	let regex = a:regex == '' ? '=' : a:regex " Align = signs by default

	let maxpos = 0
	for line in section
		let pos = match(line, ' *'.regex)
		if pos > maxpos | let maxpos = pos | endif
	endfor

	call map(section, 'AlignLine(v:val, regex, maxpos)')

	if !blockmode
		return setline(a:firstline, section)
	endif

	let start = col("'<") - 1 | let end = col("'>") + 1
	let i = blockmode ? line("'<") : a:firstline
	for line in section
		let oldLine = getline(i)
		call setline(i, strpart(oldLine, 0, start).line.strpart(oldLine, end))
		let i += 1
	endfor
endf

fun! AlignLine(line, sep, maxpos)
	let m = matchlist(a:line, '\(.\{-}\) \{-}\('.a:sep.'.*\)')
	return empty(m) ? a:line : m[1].repeat(' ', a:maxpos - strlen(m[1])+1).m[2]
endf

fun! s:RemoveWhitespace()
	if stridx(&ft, 'snippets') != -1 | return | endif
	if &bin | return | endif
	if search('\s\+$', 'n')
		let line = line('.') | let col = col('.')
		sil %s/\s\+$//ge
		call cursor(line, col)
		echo 'Removed trailing whitespace.'
	else
		echo 'No trailing whitespace found.'
	endif
endf

" Uses Bwana.app to open man pages in browser.
fun! s:Bwana()
	if !exists('b:bwana_enabled')
		let b:bwana_enabled = 1
		" This is just a one-line shell script that uses "open man://"
		" I couldn't get vim to accept the colon without this.
		setl kp=gman
		echoh ModeMsg | echo 'Bwana man mode enabled' | echoh None
	else
		unl b:bwana_enabled | setl kp=man
		echoh ModeMsg | echo 'Bwana man mode disabled' | echoh None
	endif
endf

" Lets you make a session for a directory by typing :mks
" Then restore it by going back to that directory, opening Vim
" and typing :LoadSession.
com! -bar LoadSession cal<SID>LoadSession()
nn <F3> :cal<SID>LoadSession()
fun! s:LoadSession()
	so Session.vim
	let s:sessionloaded = 1
endf
fun! s:SaveSession()
	if exists('s:sessionloaded') | mks! | endif
endf
au VimLeave * call <SID>SaveSession()

" Tells whether file is executable (used for shell script autocommands).
fun! s:FileExecutable (fname)
  exe 'sil! !test -x' a:fname
  return v:shell_error
endf

if &cp | fini | en " Vi-compatible mode doesn't seem to like autocommands
aug vimrc_autocmds
	au!
	au BufWritePre * sil cal<SID>RemoveWhitespace()

	au FileType c,objc,python,html,xhtml,xml nn <buffer> <silent> ,r :w<cr>:lcd %:p:h<cr>:mak!<cr>
	" Look up documentation for current word under cursor
	au FileType c,objc,sh nn <buffer> <silent> <c-k> :cal <SID>Bwana()<cr>
	" Shortcut for typing a semicolon at the end of a line
	au FileType c,objc,cpp ino <buffer> <silent> ;; <c-o>:cal setline('.', getline('.').';')<cr>
	au FileType c nn <buffer> <silent> ,A :exe 'e '.expand('%:p:r').'.'.(expand('%:e') == 'c' ? 'h' : 'c')<cr>

	" compile.sh is a simple shell script I made for compiling a C/Objc
	" program with gcc & running it in a new window in Terminal.app
	au FileType c,objc setl cin fdm=syntax
					\  mp=compile.sh\ \"%:p\"\ \"%\"\ \-\q\ -\w
	au FileType objc setl inc=^#import
				\|   nn <buffer> <silent> ,A :exe 'e '.expand('%:p:r').'.'.(expand('%:e') == 'm' ? 'h' : 'm')<cr>

	" Functions for converting plist files (can be binary but have xml syntax)
	au BufReadPre,FileReadPre *.plist set bin | so ~/.vim/scripts/read_plist.vim

	au FileType python setl et makeprg=python\ -t\ \"%:p\"

	" Automatically make shell & python scripts executable if they aren't already
	" when saving file
	au BufWritePost *.\(sh\|py\) if <SID>FileExecutable("'%:p'")|exe "sil !chmod a+x '%'"|en
	au FileType sh nn <buffer> ,r :w<cr>:!'%:p'<cr>
	au FileType sh,python setl ar " Automatically read file when permissions are changed

	au FileType asm nn <buffer> ,r :w <cr>:mak!<cr>:!./a.out<cr>
				\|  setl mp=gcc\ -x\ assembler\ \"%:p\"

	au FileType xhtml,xml so ~/.vim/ftplugin/html_autoclosetag.vim

	" ,p to preview in browser; :make to validate
	au FileType html,xhtml,xml nn <buffer> ,p :w<cr>:!open -a safari %<cr>
							\| vno <buffer> <c-b> c<strong></strong><esc>9hp
							\| vno <buffer> <c-e> c<em></em><esc>5hp
							\| setl mp=xmllint\ --valid\ --noout\ %
							\  errorformat=%f:%l:\ %m

	" Look up documentation under :help instead of man for .vim files
	au FileType vim,help let&l:kp=':help'
	au FileType vim set ofu=syntaxcomplete#Complete
	" I'm never using macros in help; this is much more useful
	au FileType help nn <buffer> q <c-w>q
aug END
