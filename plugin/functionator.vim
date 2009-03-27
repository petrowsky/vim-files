" File: functionator.vim
" Author: Michael Sanders (msanders42 [at] gmail [dot] com)
" Description: Shows the name of the function the cursor is currently in when
"              gn is pressed, and goes to the [count] line of that function when
"              [count]gn is used.
"              Currently supports: C, Obj-C, JavaScript, Python, Pascal and Vim.

if exists('s:did_functionator') || &cp || version < 700
	finish
endif
let s:did_functionator = 1
nn <silent> gn :<c-u>call <SID>ShowFuncName()<cr>

fun s:GetFuncName(ft)
	let line = line('.')
    if a:ft == 'c' || a:ft == 'objc'
		let funBegin = search('^[^ \t#/]\{2}.*(', 'bWcen')
		let funEnd = searchpair('^.*{', '', '}', 'n')
		let funName = funBegin ? substitute(getline(funBegin), '\s*{', '', '') : ''
	elseif a:ft == 'javascript'
		let funBegin = search('^\s*function\s\+\w\+\s*(\w*)', 'bWcen')
		let funEnd = searchpair('^.*{', '', '}', 'n')
		let funName = funBegin ? substitute(getline(funBegin), '^\s*function\s*\(\w\+\s*(\w*)\)\s*{\=', '\1', '') : ''
	" NOTE: This doesn't work for nested functions, I need to figure out how to
	" fix it
	elseif a:ft == 'python'
		let funBegin = search('^\s*def', 'bWcen')
		let funEnd = search('^\s\+$', 'n')
		if funBegin && funEnd > line
			return [substitute(getline(funBegin), '^\s*def\s*\(\w\+\s*(.*)\):', '\1', ''), (line - funBegin)]
		endif
		return []
	elseif a:ft == 'pascal'
		let col = col('.')
		let funBegin = search('^\(function\|procedure\)\s\+\w\+', 'bWce')
		call search('^\s*begin', 'ce')
		let funEnd = searchpair('^\s*begin', '', '^\s*end;')
		let funName = funBegin ? getline(funBegin) : ''
		call cursor(line, col)
	elseif a:ft == 'vim'
		let funBegin = search('^\s*fun.*$', 'bWen')
		let funEnd = searchpair('^\s*fun%[ction]!\=', '', '^\s*endf\%[unction]!\=', 'n')
		let funName = substitute(substitute(getline(funBegin),
							\ '^\s*fun\%[ction]!\=\s*', '', ''), ')\zs\s*".*', '', '')
	endif
	return funBegin && funEnd && funEnd >= line ? [funName, line - funBegin] : []
endf

fun s:ShowFuncName()
	let ft = stridx(&ft, '.') == -1 ? &ft : matchstr(&ft, '.\{-}\ze\.')
	if ft !~ '^\(c\|objc\|javascript\|python\|pascal\|vim\)$' | return | endif
	let function = s:GetFuncName(ft)
	if empty(function)
		echoh WarningMsg | ec 'Not in function.' | echoh None
	elseif !v:count
		echoh ModeMsg | ec function[0].': Line '.function[1] | echoh None
	else
		call cursor(line('.') - (function[1] - v:count), 0)
	endif
endf
