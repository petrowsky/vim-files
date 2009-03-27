" File:         HTML AutoCloseTag.vim
" Author:       Michael Sanders (msanders42 [at] gmail [dot] com)
" Last Updated: March 26 2009
" Version:      0.2
" Description:  Automatically closes HTML tag once you finish typing it with >

if exists('b:mapped_auto_closetag') || &cp | finish | endif
let b:mapped_auto_closetag = 1

" Autopair if closepair.vim is installed
if exists('did_closepair') | call AddPair('<', '>', 1) | endif
ino <buffer> <silent> > <c-r>=<SID>CloseTag()<cr>
ino <buffer> <expr> <cr> <SID>Return()

if exists('s:did_auto_closetag') | finish | endif
let s:did_auto_closetag = 1

" Gets the current HTML tag by the cursor
fun s:GetCurrentTag()
	return matchstr(matchstr(getline('.'), 
						\ '<\zs\(\w\|=\| \|''\|"\)*>\%'.col('.').'c'), '\a*')
endf

" Cleanly return after autocompleting an html/xml tag
fun s:Return()
	let tag = s:GetCurrentTag()
	return tag != '' && match(getline('.'), '</'.tag.'>') > -1 ? 
				\ "\<cr>\<cr>\<up>" : "\<cr>"
endf

fun s:InComment()
	return stridx(synIDattr(synID(line('.'), col('.')-1, 0), 'name'), 'omment') != -1
endf

" Returns whether a closing tag has already been inserted
fun s:ClosingTag(tag)
	let line = line('.') | let col = col('.')

	call cursor(1, 1)
	let tag = '\c<'.a:tag.'.\{-}>'
	let opencount = 0
	while search(tag, 'W')
		if !s:InComment()
			let opencount += 1
		endif
	endw

	let tag = '\c</'.a:tag.'>'
	call cursor(1, 1)
	let closecount = 0
	while search(tag, 'W')
		if !s:InComment()
			let closecount += 1
		endif
	endw

	call cursor(line, col)
	return closecount >= opencount
endf

" Automatically inserts closing tag after starting tag is typed
fun s:CloseTag()
	let line = getline('.')
	let col = col('.')
	if line[col-1] == '>'
		let col += 1
		call cursor(0, col)
		" Don't autocomplete next to a word or another tag or if inside comment
		if line[col] !~ '\w\|<\|>' && !s:InComment()
			let tag = s:GetCurrentTag()
			" Insert closing tag if tag is not self-closing and has not already 
			" been closed
			if tag != '' && tag !~ '\vimg|input|link|meta|br|hr|area|base|param|dd|dt'
						\ && !s:ClosingTag(tag)
				let line = substitute(line, '\%'.col.'c', '</'.escape(tag, '/').'>', '')
				call setline('.', line)
				call cursor(0, col)
			endif
		endif
		return ''
	endif
	return '>'
endf
" vim:noet:sw=4:ts=4:ft=vim
