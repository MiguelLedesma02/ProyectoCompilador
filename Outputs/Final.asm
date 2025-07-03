include macros2.asm
include number.asm

.MODEL LARGE
.386
.STACK 200h

.DATA
    _a dd ?
    _x dd ?
    _c dd ?
    _r dd ?
    _z dd ?
    _f dd ?
    _b db '-', '$'
    _9999999 dd 99999.99
    _99 dd 99.
    _9999 dd .9999
    _sdADaSjfladfg db '@sdADaSjfla%dfg', '$'
    _asldkfhsjf db 'asldk  fh sjf', '$'
    _27 dd 27
    _500 dd 500
    _34 dd 34
    _3 dd 3
    _cesmasgrandequex db 'c es mas grande que x', '$'
    _cesmaschicooigualax db 'c es mas chico o igual a x', '$'
    _4 dd 4
    _1 dd 1
    _cesmasgrandequex db 'c es mas grande que x', '$'
    _ewr db 'ewr', '$'
    _2 dd 2
    _xesmasgrandequebyces db 'x es mas grande que b y c es mas grande que x', '$'
    _xesmasgrandequeroces db 'x es mas grande que r o c es mas grande que x', '$'
    _xnoesmasgrandequer db 'x no es mas grande que r', '$'
    _9 dd 9
    _5 dd 5
    _aux0 dd ?
    _aux1 dd ?
    _aux2 dd ?
    _orden dd ?
    _pivot dd ?
    _temp dd ?
.CODE
extrn STRLEN:proc, COPIAR:proc, CONCAT:proc

START:
    mov AX, @DATA
    mov DS, AX
    mov ES, AX
    fld _99999.99
    fst _a
    ffree
    fld _99.
    fst _a
    ffree
    fld _.9999
    fst _a
    ffree
    fld _@sdADaSjfla%dfg
    fst _b
    ffree
    fld _asldk  fh sjf
    fst _b
    ffree
    fld _27
    fld _c
    fsub 
    ffree 1 
    fst _x
    ffree
    fld _r
    fld _500
    fadd 
    ffree 1 
    fst _x
    ffree
    fld _34
    fld _3
    fmul 
    ffree 1 
    fst _x
    ffree
    fld _z
    fld _f
    fdiv 
    ffree 1 
    fst _x
    ffree
    fld _c
    fld _x
    fxch 
    fcom 
    fstsw ax
    sahf
    ffree
    jle etiq42
    displayString _cesmasgrandequex
    newLine

    jmp etiq44
etiq42:
    displayString _cesmaschicooigualax
    newLine

etiq44:
    fst _c
    ffree
    fld _1
    fst _x
    ffree
etiq50:
etiq1:
    fld _c
    fld _x
    fxch 
    fcom 
    fstsw ax
    sahf
    ffree
    jle etiq62
    displayString _cesmasgrandequex
    newLine

    fld _x
    fld _1
    fadd 
    ffree 1 
    fst _x
    ffree
    jmp etiq1
etiq62:
    GetFloat _x
    newLine

    displayString _ewr
    newLine

    fld _1
    fst _x
    ffree
    fld _1
    fst _r
    ffree
    fld _2
    fst _c
    ffree
    fld _x
    fld _r
    fxch 
    fcom 
    fstsw ax
    sahf
    ffree
    jle etiq85
    fld _c
    fld _x
    fxch 
    fcom 
    fstsw ax
    sahf
    ffree
    jle etiq85
etiq85:
    fld _r
    fxch 
    fcom 
    fstsw ax
    sahf
    ffree
    jg etiq93
    fld _c
    fld _x
    fxch 
    fcom 
    fstsw ax
    sahf
    ffree
    jle etiq95
etiq95:
    fld _r
    fxch 
    fcom 
    fstsw ax
    sahf
    ffree
    jg etiq101
    displayString _xnoesmasgrandequer
    newLine

etiq101:
    fld _3
    fadd 
    ffree 1 
    fst _@aux0
    ffree
    fld _1
    fld _1
    fadd 
    ffree 1 
    fst _@aux1
    ffree
    fld _9
    fld _x
    fsub 
    ffree 1 
    fst _@aux2
    ffree
    fld _1
    fst _@orden
    ffree
    fld _2
    fst _@pivot
    ffree
    fld _@aux2
    fst _@temp
    ffree
    fld _@aux0
    fst _@aux2
    ffree
    fld _@temp
    fst _@aux0
    ffree
    fld _@aux1
    fst _@temp
    ffree
    fld _@aux1
    fst _@aux1
    ffree
    fld _@temp
    fst _@aux1
    ffree
    fld _28
    fst _x
    ffree
etiq93:
    mov ax, 4C00h
    int 21h
END START
