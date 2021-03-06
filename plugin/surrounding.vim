" File: surrounding.vim
" Author: Michael Sanders
" Description: A heavily modified, simplified version of surround.vim by Tim Pope.

if exists('s:did_surrounding') || &cp || version < 700
	finish
endif
let s:did_surrounding = 1

nn cs :<c-u>call <SID>ModifySurround(<SID>Input(), <SID>Input())<cr>
nn ds :<c-u>call <SID>ModifySurround(<SID>Input())<cr>
xno s :<c-u>call AddSurround(visualmode(), 1)<cr>
nn <silent> ys :<c-u>set opfunc=AddSurround<cr>g@
nm yss 0ys$

fun s:Input()
	echoh ModeMsg | ec '-- SURROUND --' | echoh None
	let c = nr2char(getchar())
	if c == ' '
		let c .= nr2char(getchar())
	endif
	echo '' | redraw
	return c == "\<esc>" || c == "\<cr>" ? '' : c
endf

fun AddSurround(type, ...)
	let char = s:Input()

	" Deal with motions, if used in normal mode.
	if !a:0
		let sel_save = &sel | let &sel = 'inclusive'
		exe 'norm! `['.(a:type == 'char' ? 'v' : 'V')."`]\<esc>"
		let sel_save = &sel
	endif

	if a:type ==# 'V'
		let chars = s:Wrap('', char) | let half = len(chars)/2
		call setline("'<", strpart(chars, 0, half).getline("'<"))
		call setline("'>", getline("'>").strpart(chars, half))
	else
		let old = @"
		norm! gvc
		let @" = s:Wrap(@", char)
		exe 'norm! '.(col('.') == 1 ? 'P' : 'p')
		let @" = old
	endif

	if a:0
		sil! call repeat#set('1vs'.char)
	elseif a:type " If a:type is a number
		" NOTE: this needs to be fixed -- it needs to save the motion/char used
		sil! call repeat#set('ys')
	endif
endf

fun s:MatchChar(char)
	if a:char ==# 'b' || a:char == '(' || a:char == ')'
		return ['(', ')']
	elseif a:char ==# 'r' || a:char == ']' || a:char == '['
		return ['[', ']']
	elseif a:char ==# 'B' || a:char == '{' || a:char == '}'
		return ['{', '}']
	elseif a:char ==# 'a' || a:char == '<' || a:char == '>'
		return ['<', '>']
	elseif a:char == 't' " Insert tag
		if !hasmapto('>', 'c')
			let remapped = 1
			cno > <cr>
		endif
		let tag = input('<')
		if !remapped | let tag = substitute(tag, '>*$', '', '') | endif
		echo '<'.tag.'>'
		if remapped
			sil! cunmap >
		endif
		let cl = tag =~ '/$' ? '' : '</'.substitute(tag, ' .*', '', '').'>'
		return a:char ==# 'T' ? ['<'.tag.">\n", "\n".cl] : ['<'.tag.'>', cl]
	endif
	return a:char =~ '\W' ? [a:char, a:char] : ['', '']
endf

" Change or delete surrounding characters
fun s:ModifySurround(orig, ...)
	if a:orig == '' | return | endif
	if a:0 " save position if using cs
		if a:1 == '' | return | endif
		let line = line('.') | let col = col('.')
	endif

	let char = a:orig
	if len(char) > 1
		let space = ' '
		let char = strpart(char, 1)
	endif

	if char ==# 'a' | let char = '>'
	elseif char ==# 'r' | let char = ']' | endif

	let old = @"
	let @" = ''
	exe 'norm! d'.v:count1.'i'.char

	" If di<char> failed, quit.
	if @" == ''
		let @" = old | return
	elseif exists('space')
		let @" = substitute(@",'^\s+\|\s+$', '', 'g')
	endif

	let oldLine = getline('.') | let oldLnum = line('.')
	let oldLineLen = col('$')
	if char == '"' || char == "'" || char == '`'
		exe "norm! i \<esc>\"_d2i".char
	else
		exe 'norm! "_da'.char
	endif

	if a:0 | let @" = s:Wrap(@", a:1) | endif
	let endLine = col('$')
	sil exe 'norm! ""'.(col("']") == endLine && col('.')+1 == endLine ? 'p' : 'P')

	let @" = old
	if exists('space') | let char = ' '.char | endif
	if a:0
		sil! call repeat#set('cs'.char.a:1)
		call cursor(line, col)
	else
		sil! call repeat#set('ds'.char)
	endif
endf

fun s:Wrap(string, char)
	if len(a:char) > 1
		let space = ' '
		let chars = s:MatchChar(strpart(a:char, 1))
	else
		let space = ''
		let chars = s:MatchChar(a:char)
	endif
	return chars[0].space.a:string.space.chars[1]
endf
" vim:noet:sw=4:ts=4:ft=vim
