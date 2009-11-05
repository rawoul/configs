" Vim indent file
" Language:		fbxbus
" Maintainer:		Clement Vasseur <cvasseur@freebox.fr>
" Latest Revision:	2014-02-20

if exists("b:did_indent")
	finish
endif
let b:did_indent = 1

setlocal indentexpr=GetFbxbusIndent()
setlocal indentkeys+==prefix,=path,=enum,=struct,=union,=method,=signal,=property,=config,=target,=end,=exceptions,=bitmask,=const

if exists("*GetFbxbusIndent")
	finish
endif

let s:cpo_save = &cpo
set cpo&vim

function GetFbxbusIndent()
	let curline = getline(v:lnum)

	" Force comments, prefix and path to column 0
	if curline =~ '^\s*\(//\|prefix\|path\)'
		return 0
	endif

	let lnum = prevnonblank(v:lnum - 1)
	if lnum == 0
		return 0
	endif

	" Add a 'shiftwidth' after prefix, path, enum, struct, method, signal,
	" property, target, exceptions
	let ind = indent(lnum)
	let line = getline(lnum)
	if line =~ '^\s*\(prefix\|path\|enum\|struct\|union\|method\|signal\|property\|config\|target\|exceptions\|bitmask\)\>'
		let ind = ind + &sw
	endif

	" Subtract a 'shiftwidth' on a path, enum, struct, method,
	" signal, property, config, target, end, exceptions, bitmask,
	" include, const
	if curline =~ '^\s*\(enum\|struct\|union\|method\|signal\|property\|config\|target\|end\|exceptions\|bitmask\|include\|const\)\>'
		if line !~ '^\s*\(prefix\|path\|target\|include\|const\)\>'
			let ind = ind - &sw
		endif
	endif

	" Subtract a second 'shiftwidth' on end
	if curline =~ '^\s*end\>'
		let ind = ind - &sw
	endif

	return ind
endfunction

let &cpo = s:cpo_save
unlet s:cpo_save
