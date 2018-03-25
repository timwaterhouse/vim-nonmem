" Vim indent file
" Language:	NONMEM
" Version:	0.1.0
" Last Change:	24 Mar 2018
" Maintainer:	Tim Waterhouse
" Usage:	For instructions, do :help fortran-indent from Vim
" Credits:
"  Heavily inspired by (i.e. basically mostly stolen from)
"  $VIMRUNTIME/indent/fortran.vim with minor tweaks

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

let s:cposet=&cpoptions
set cpoptions&vim

setlocal indentkeys+=0$,0;
setlocal indentkeys+==~end,=~case,=~if,=~else,=~do,=~where,=~elsewhere,=~select
setlocal indentkeys+==~endif,=~enddo,=~endwhere,=~endselect,=~elseif

" Define the appropriate indent function but only once
setlocal indentexpr=NonmemGetFreeIndent()
if exists("*NonmemGetFreeIndent")
  finish
endif

function NonmemGetIndent(lnum)
  let ind = indent(a:lnum)
  let prevline=getline(a:lnum)
  " Strip tail comment
  let prevstat=substitute(prevline, ';.*$', '', '')

  "Indent most lines by at least sw
  if ind == 0
    let ind = &sw
  endif

  "Add a shiftwidth to statements following if, else, else if, case,
  "where, else where, forall, type, interface and associate statements
  if prevstat =~? '^\s*\(case\|else\|else\s*if\|else\s*where\)\>'
  \ ||prevstat=~? '^\s*\(type\|interface\|associate\|enum\)\>'
  \ ||prevstat=~?'^\s*\(\d\+\s\)\=\s*\(\a\w*\s*:\)\=\s*\(forall\|where\|block\)\>'
  \ ||prevstat=~? '^\s*\(\d\+\s\)\=\s*\(\a\w*\s*:\)\=\s*if\>'
     let ind = ind + &sw
    " Remove unwanted indent after logical and arithmetic ifs
    if prevstat =~? '\<if\>' && prevstat !~? '\<then\>'
      let ind = ind - &sw
    endif
  endif

  "Subtract a shiftwidth from else, else if, elsewhere, case, end if,
  " end where, end select, end forall, end interface, end associate,
  " end enum, and end type statements
  if getline(v:lnum) =~? '^\s*\(\d\+\s\)\=\s*'
        \. '\(else\|else\s*if\|else\s*where\|case\|'
        \. 'end\s*\(if\|where\|select\|interface\|'
        \. 'type\|forall\|associate\|enum\)\)\>'
    let ind = ind - &sw
  endif

  return ind
endfunction

function NonmemGetFreeIndent()
  "Find the previous non-blank line
  let lnum = prevnonblank(v:lnum - 1)

  "Use zero indent at the top of the file
  if lnum == 0
    return 0
  endif

  "Use zero indent at the start of a block or record
  if getline(v:lnum) =~? '^\s*\$'
    return 0
  endif

  "Use zero indent for comments following start of block or record
  if ((indent(lnum) == 0) && (getline(v:lnum) =~? '^\s*;'))
    return 0
  endif

  let ind=NonmemGetIndent(lnum)
  return ind
endfunction

let &cpoptions=s:cposet
unlet s:cposet

" vim:sw=2 tw=130
