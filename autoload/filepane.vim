au WinLeave File\ List cal<SID>LeaveFilePane()
au WinEnter File\ List cal filepane#Activate()

fun filepane#Activate()
	let s:opt = {} " Save current options.
	let s:opt['is'] = &is | let s:opt['hls'] = &hls
	set is nohls

	" If filepane has already been opened, reactivate it.
	if exists('s:filepaneBuffer') && bufexists(s:filepaneBuffer)
		let filepaneWin = bufwinnr(s:filepaneBuffer)
		if filepaneWin == -1
			sil exe 'to vert sb '.s:filepaneBuffer
			exe 'vert res'.g:filepaneWidth
			call s:UpdateFilePane()
		elseif winbufnr(2) == -1
			q " If no other windows are open, quit bufpane automatically.
		else " If filepane is out of focus, bring it back into focus.
			exe filepaneWin.'winc w'
			exe 'vert res'.g:filepaneWidth
		endif
	else " Otherwise, create the filepane.
		sil call s:CreateFilePane()
		call s:UpdateFilePane()
	endif
endf

fun s:CreateFilePane()
	if isdirectory(bufname('%')) " Delete directory buffer created by Vim
		exe 'bw'.bufnr('%')
	endif
	to vnew
	let g:filepaneWidth = exists('g:filepaneWidth') ? g:filepaneWidth : 25
	exe 'vert res'.g:filepaneWidth

	let s:sortPref = 0
	let s:filepaneBuffer = bufnr('%')

	f File\ List
	setl bt=nofile bh=wipe noswf nobl nonu nowrap

	if !exists('g:filepane_drawermode') || g:filepane_drawermode
		setl bh=hide
	endif

	nn <silent> <buffer> s :cal<SID>TogglePref(0)<cr>
	nn <silent> <buffer> x :cal<SID>CustomViewFile()<cr>
	nn <silent> <buffer> l :cal<SID>PreviousWindow()<cr>
	nn <silent> <buffer> R :cal<SID>RenameFile()<cr>
	nn <silent> <buffer> D :cal<SID>DeleteFile()<cr>
	nn <silent> <buffer> d :cal<SID>MakeDir()<cr>

	nm <silent> <buffer> . :cd ..<bar>cal<SID>UpdateFilePane()<cr>
	nm <silent> <buffer> - :cd -<bar>cal<SID>UpdateFilePane()<cr>
	nm <silent> <buffer> ~ :cd ~<bar>cal<SID>UpdateFilePane()<cr>
	nn <silent> <buffer> <cr> :cal<SID>FilePaneSelect()<cr>
	nn <silent> <buffer> o :cal<SID>FilePaneSelect(1)<cr>
	nn <silent> <buffer> O :cal<SID>FilePaneSelect(2)<cr>
	nn <silent> <buffer> v :cal<SID>FilePaneSelect(3)<cr>
	nn <silent> <buffer> > <c-w>>:let g:filepaneWidth+=1<cr>
	nn <silent> <buffer> < <c-w><:let g:filepaneWidth-=1<cr>
	nn <buffer> <c-l> :cal<SID>UpdateFilePane()<cr>:ec "File list refreshed."<cr>
	nn <buffer> q <c-w>q
	nm <buffer> gL l
	nm <buffer> p -
	nm <buffer> h ~
	nm <buffer> <leftmouse> <leftmouse><cr>

	syn match filepaneDir '.*/$' display
	syn match filepaneExt '.*\.\zs.*$' display

	hi link filepaneDir Special
	hi link filepaneExt Type
endf

" Goes to previous window if it exists; otherwise,
" tries to go to 'last' window.
fun s:PreviousWindow()
	exe winnr('#') != bufwinnr(s:filepaneBuffer) ? 'winc p' : winnr('$').'winc w'
endf

fun s:LeaveFilePane()
	for option in keys(s:opt)
		exe 'let &'.option.'='.s:opt[option]
	endfor
	unl s:opt
	if !exists('g:filepane_drawermode') || g:filepane_drawermode
		q
	else
		unl s:filepaneBuffer
	endif
endf

fun s:UpdateFilePane()
	setl ma
	let line = 2
	let cursorLine = line('.')
	sil 1,$ d_
	call setline(1, '..')

	" Move filepane's window to the left side & reset its width.
	winc H | exe 'vert res'.g:filepaneWidth

	let firstFileLine = line
	let lastFile = bufnr('$')
	let currentDir = fnameescape(substitute(getcwd().'/', '//$', '/', ''))
	let dirNameLen = len(currentDir)

	for file in split(globpath(currentDir, '*'), "\n")
		if isdirectory(file) | let file .= '/' | endif
		call setline(line, strpart(file, dirNameLen))
		let line += 1
	endfor
	let currentDir = substitute(currentDir, '^'.$HOME, '~', '')
	let line -= firstFileLine
	exe 'setl stl=%<'.currentDir.'%=%l'
	ec '"'.currentDir.'" '.line.' item'.(line == 1 ? '' : 's')

	if s:sortPref == 1
		sil exe firstFileLine.',$sort /\d\+/'
	elseif s:sortPref == 2
		sil exe firstFileLine.',$sort /.*\./'
	endif

	call cursor(cursorLine, 1)
	setl noma
endf

fun s:TogglePref(toggle)
	if !a:toggle " Toggle sort
		let s:sortPref = (s:sortPref + 1) % 3
		setl ma
		if s:sortPref == 1
			ec 'Sorting by name.'
			sil exe '2,$sort /\d\+/'
		elseif s:sortPref == 2
			ec 'Sorting by extension.'
			sil exe '2,$sort /.*\./'
		else
			call s:UpdateFilePane()
		endif
		setl noma
	endif
endf

fun s:SelectedFile()
	let currentDir = substitute(getcwd().'/', '//$', '/', '')
	return currentDir.getline('.')
endf

fun s:FilePaneSelect(...)
	let file = s:SelectedFile()
	if isdirectory(file)
		exe 'cd'.fnameescape(file)
		call s:UpdateFilePane()
	elseif filereadable(file)
		winc p
		if a:0 && a:1 < 3
			let splitbelow = &sb
			exe 'let &sb = '.(a:1 == 1).' | sp | let &sb ='.splitbelow
		elseif a:0 && a:1 == 3
			vnew
		endif
		exe 'e'.fnameescape(file)
	else
		echo 'Could not read file '.file
	endif
endf

fun s:RenameFile()
	let file = s:SelectedFile()
	call rename(file, input('Rename "'.strpart(file, strridx(file, '/') + 1).
						\   '" to '))
	sil call s:UpdateFilePane()
endf

fun s:DeleteFile()
	let file = s:SelectedFile()
	if isdirectory(file)
		echo '"'.file.'" is a directory.'
	elseif confirm('Delete file "'.file.'"?', "&Delete\n&Cancel", 2) == 1
		redraw
		echo 'File "'.file.'" '.(delete(file) ? 'could not be' : 'was').' deleted'
		sil call s:UpdateFilePane()
	endif
endf

fun s:MakeDir()
	let dir = input('Create directory: ', '', 'file')
	if dir == '' | return | endif
	call mkdir(dir[:-1])
	sil call s:UpdateFilePane()
endf

fun s:CustomViewFile()
	if !exists('g:filepane_viewer')
		if !has('unix') | return | endif
		if executable('gnome-open')
			let g:filepane_viewer = 'gnome-open'
		elseif executable('kfmclient')
			let g:filepane_viewer = 'kfmclient'
		elseif executable('open')
			let g:filepane_viewer = 'open'
		else
			return
		endif
	endif
	let file = s:SelectedFile()
	sil exe '!'.g:filepane_viewer.' '.file
	redraw! " Skip enter prompt
endf
" vim:noet:sw=4:ts=4:ft=vim
