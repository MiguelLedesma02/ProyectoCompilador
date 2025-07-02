include macros2.asm
include number.asm

.MODEL LARGE
.386
.STACK 200h

.DATA
    _x dd ?
    __5 dd 5
    __50 dd 50
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
    jle etiq
    fld 50
    fst x
    ffree
etiq1
    mov ax, 4C00h
    int 21h
END START
