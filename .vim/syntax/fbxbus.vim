" Vim syntax file
" Language:	fbxbus
" Maintainer:	Clément Vasseur <cvasseur@freebox.fr>
" Last Change:	2014-02-20

if exists("b:current_syntax")
	finish
endif

syn match	fbxbusStorageClass	/^\s*\(prefix\|include\|path\|struct\|union\|enum\|bitmask\|method\|signal\|property\|config\|target\|end\|exceptions\|const\)\>/
syn match	fbxbusStatement		/^\s*\(desc\|in\|out\|arg\|mode\|default\|flags\|filter\)\>/
syn match	fbxbusStatement		/^\s*-/
syn region	fbxbusString		start=+"+ end=+"+
syn match	fbxbusType		/:\s*\[*\s*[a-zA-Z_][a-zA-Z0-9_]*\(\s*(\s*[0-9][0-9]*\s*)\|\s*\[\s*[a-zA-Z0-9_][a-zA-Z0-9_]*\s*\]\)*\s*\]*/ms=s+1
syn match	fbxbusPath		/\/[a-zA-Z0-9_\/ ]*/
syn region	fbxbusComment		start="//" skip="\\$" end="$" keepend

hi def link	fbxbusString		String
hi def link	fbxbusComment		Comment
hi def link	fbxbusStatement		Statement
hi def link	fbxbusStorageClass	StorageClass
hi def link	fbxbusString		String
hi def link	fbxbusType		Type
hi def link	fbxbusPath		PreProc

let b:current_syntax = "fbxbus"
