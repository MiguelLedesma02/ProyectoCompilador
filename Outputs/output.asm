include macros2.asm
include number.asm

.MODEL LARGE
.386
.STACK 200h

.DATA
    _x dd ?
    _y dd ?
    _z dd ?
    __5 dd 5
    __2 dd 2
    __200 dd 200
.CODE
extrn STRLEN:proc, COPIAR:proc, CONCAT:proc

START:
    mov AX, @DATA
    mov DS, AX
    mov ES, AX
    fld x
    fld 5
    fxch 
    fcom 
    fstsw ax
    sahf
    ffree
    jle etiq1
    fld 2
    fst x
    ffree
    fld y
    fld z
    fxch 
    fcom 
    fstsw ax
    sahf
    ffree
    jge etiq2
    fld 200
    fst y
    ffree
etiq2
etiq1
    mov ax, 4C00h
    int 21h
END START
