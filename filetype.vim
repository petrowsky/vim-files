if exists('did_load_filetypes') | fini | en
au BufRead,BufNewFile *.m,*.h setf objc
au BufRead,BufNewFile *.dict setf dict
au BufRead,BufNewFile *.applescript setf applescript
au BufRead,BufNewFile *.todo setf todo
au BufRead,BufNewFile .vimperatorrc setf vim
au BufRead,BufNewFile *.module,*.theme,*.inc,*.install,*.info,*.engine,*.profile,*.test setf php
