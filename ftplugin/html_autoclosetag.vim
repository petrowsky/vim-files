" File: autoclosetag.vim
" Author: Michael Sanders (msanders42 [at] gmail [dot] com)
" Description: Automatically closes HTML tag once you finish typing it with >
if exists('b:mapped_auto_closetag') || &cp | finish | endif
let b:mapped_auto_closetag = 1

" Autopair if closepair.vim is installed
if exists('did_closepair') | call AddPair('<', '>', 1) | endif
ino <buffer> <silent> > <c-r>=<SID>CloseTag()<cr>
ino <buffer> <silent> <cr> <c-r>=<SID>Return()<cr>

if exists('s:did_auto_closetag')
	finish
endif
let s:did_auto_closetag = 1

" Cleanly return after autocompleting an html/xml tag
fun s:Return()
	return strpart(getline('.'), col('.')-2, 2) == '><' ?
					\ "\<cr>\<cr>\<up>" : "\<cr>"
endf

" Automatically inserts closing tag after starting tag is typed
fun s:CloseTag()
	let line = getline('.')
	let col = col('.')
	if line[col-2] == '/'
		return "\<right>"
	elseif line[col-1] == '>'
		let col += 1
		call cursor(0, col)
		" Don't autocomplete next to a word or another tag or if inside
		" a comment
		if line[col] !~ '\w\|<\|>' && stridx(synIDattr(synID(line('.'), col-1, 0),'name'),
											\ 'omment') == -1
			let tag = matchstr(matchstr(line, '<\zs\(\w\|=\| \|''\|"\)*>\%'.col.'c'), '\a*')
			" Insert closing tag if tag is not self-closing
			if tag != '' && tag !~ 'img\|input\|link\|meta\|br\|hr\|area\|base\|param\|dd\|dt'
				exe 's/\%'.col.'c/<\/'.escape(tag, '/').'>'
				call cursor(0, col)
			endif
		endif
		return ''
	endif
	return '>'
endf
