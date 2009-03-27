" File:   filepane.vim
" Author: Michael Sanders (msanders42 [at] gmail [dot] com)
" Description: A very simple file browser for *nix systems.

if exists('s:did_filepane') || &cp || version < 700
	finish
endif
let s:did_filepane = 1

nn <silent> gL :cal filepane#Activate()<cr>

" Override netrw
au BufEnter * sil! au! FileExplorer
au BufEnter * cal<SID>CheckForDir(expand('<amatch>'))

fun s:CheckForDir(dir)
	if isdirectory(a:dir)
		redraw! " Disable 'illegal filename' warning
		exe 'cd'.fnameescape(a:dir)
		call filepane#Activate()
	endif
endf
" vim:noet:sw=4:ts=4:ft=vim
