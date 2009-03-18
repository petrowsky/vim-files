" Author: Michael Sanders (msanders42 [at] gmail [dot] com)
" Description: Slate colorscheme, adopted from TextMate
" Usage: This colorscheme is meant only for use with vim in Terminal.app or
"        gvim. I haven't tested it in other terminals. To get it to work in
"        Terminal.app, install TerminalColors
"        (http://www.culater.net/software/TerminalColors/TerminalColors.php)
"        and use this theme I made to go along with this color scheme:
"        http://msanders.homeip.net/Slate.terminal

" The following are the preferred 16 colors for Terminal.app:
"
"           Colors      Bright Colors
" Black     #4E4E4E     #7C7C7C
" Red       #FF6C60     #FFB6B0
" Green     #A8FF60     #CEFFAB
" Yellow    #FFFFB6     #FFFFCB
" Blue      #96CBFE     #FFFFCB
" Magenta   #FF73FD     #FF9CFE
" Cyan      #C6C5FE     #DFDFFE
" White     #EEEEEE     #FFFFFF

" These are the modified colors for this theme:
" 			Colors		Bright Colors
" Black		#0e2231		#b0b3ba (#0e2231 is used solely for highlighting the
" 								 current line)
" Red		#d8290d		#ff3a83
" Green		#78df51		#9df39f
" Yellow	#eee940		#f6f080
" Blue		#1e9ae0		#9effff
" Magenta	#f4a934		#f1994a (magenta == orange now)
" Cyan		#8996a8		#afc4db
" White		#f8f8f8		#ffffff

let colors_name = 'slate'
set bg=dark

" General colors
hi Normal		guifg=#f8f8f8	guibg=#12384b gui=none
hi NonText		guifg=#9effff	gui=none					ctermfg=blue

hi Cursor		guifg=NONE		guibg=#8ba7a7
hi LineNr		guifg=#b0b3ba	gui=bold					ctermfg=darkgray				cterm=bold

hi VertSplit	guifg=#f8f8f8	guibg=#0e2231	gui=none	ctermfg=gray	ctermbg=black	cterm=none

hi Visual		guibg=#afc4db	ctermbg=cyan

hi WildMenu		guifg=#0e2231	guibg=#b0b3ba	ctermfg=black	ctermbg=gray
hi ErrorMsg		guifg=#f8f8f8	guibg=#d8290d	gui=bold		ctermfg=gray	ctermbg=darkred	cterm=bold
hi WarningMsg	guifg=#f6f080	guibg=#0e2231	gui=bold		ctermfg=yellow	ctermbg=black cterm=bold

hi ModeMsg		guifg=#b0b3ba	guibg=#0e2231	gui=bold		ctermfg=gray	ctermbg=black	cterm=bold

if version >= 700 " Vim 7 specific colors
  hi CursorLine		guibg=#0e2231									ctermbg=black	cterm=none
  hi! link CursorColumn CursorLine
  hi MatchParen		guifg=#0e2231	guibg=#b0b3ba	ctermfg=black	ctermbg=gray
  hi Search			guifg=NONE		guibg=NONE		gui=inverse		ctermfg=none	ctermbg=none	cterm=inverse
en

hi Pmenu			guifg=#000000	guibg=#f8f8f8				ctermfg=black		ctermbg=gray
hi PmenuSbar		guifg=#8996a8	guibg=#f8f8f8	gui=none	ctermfg=darkcyan	ctermbg=gray	 cterm=none
hi PmenuThumb		guifg=#f8f8f8	guibg=#8996a8	gui=none	ctermfg=gray		ctermbg=darkcyan cterm=none

" Syntax highlighting
hi Comment			guifg=#1e9ae0	gui=italic		ctermfg=darkblue
hi String			guifg=#78df51					ctermfg=darkgreen
hi Number			guifg=#ff3a83					ctermfg=red

hi Keyword			guifg=#f4a934					ctermfg=darkmagenta
hi PreProc			guifg=#f1994a					ctermfg=magenta

hi Todo				guifg=#afc4db	guibg=NONE		ctermfg=cyan	ctermbg=none
hi Constant			guifg=#ff3a83					ctermfg=red

hi Identifier		guifg=#f1994a					ctermfg=magenta	cterm=none
hi Type				guifg=#f6f080	gui=none		ctermfg=yellow
hi Statement		guifg=#f1994a	gui=none		ctermfg=magenta

hi Special			guifg=#9df39f					ctermfg=green
hi Delimiter		guifg=#f1994a	gui=none		ctermfg=magenta

hi! link StatusLine     VertSplit
hi! link StatusLineNC   VertSplit
hi! link Identifier     Function
hi! link Question       Special
hi! link MoreMsg        Special
hi! link Folded         Normal

hi link Operator        Delimiter
hi link Function        Identifier
hi link PmenuSel        PmenuThumb
hi link Error			ErrorMsg
hi link Conditional		Keyword
hi link Character		String
hi link Boolean			Constant
hi link Float			Number
hi link Repeat			Statement
hi link Label			Statement
hi link Exception		Statement
hi link Include			PreProc
hi link Define			PreProc
hi link Macro			PreProc
hi link PreCondit		PreProc
hi link StorageClass	Type
hi link Structure		Type
hi link Typedef			Type
hi link Tag				Special
hi link SpecialChar		Special
hi link SpecialComment	Special
hi link Debug			Special

" Ruby
hi link rubyClass				Keyword
hi link rubyModule				Keyword
hi link rubyKeyword				Keyword
hi link rubyOperator			Operator
hi link rubyIdentifier			Identifier
hi link rubyInstanceVariable	Identifier
hi link rubyGlobalVariable		Identifier
hi link rubyClassVariable		Identifier
hi link rubyConstant			Type

" HTML/XML
hi link xmlTag				HTML
hi link xmlTagName			HTML
hi link xmlEndTag			HTML
hi link htmlTag				HTML
hi link htmlTagName			HTML
hi link htmlSpecialTagName	HTML
hi link htmlEndTag			HTML
hi link HTML 				NonText

" JavaScript
hi link javaScriptNumber	Number

" Obj-C
hi link objcDirective		Type

" CSS
hi link cssBraces			Normal
hi link cssTagName			NonText
hi link StorageClass		Special
hi link cssClassName		Special
hi link cssIdentifier		Identifier
hi link cssColor			Type
hi link cssValueInteger		Type
hi link cssValueNumber		Type
hi link cssValueLength		Type
hi cssPseudoClassId guifg=#eee940 ctermfg=darkyellow

hi clear SpellBad
hi SpellBad ctermfg=red term=underline cterm=underline
hi clear SpellCap
hi SpellCap term=underline cterm=underline
hi clear SpellRare
hi SpellRare term=underline cterm=underline
hi clear SpellLocal
hi SpellLocal term=underline cterm=underline
