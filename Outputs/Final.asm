include macros2.asm
include number.asm

.MODEL LARGE
.386
.STACK 200h

.DATA
    _x dd ?
    _5 dd 5
    _10 dd 10
    _4 dd 4
.CODE
extrn STRLEN:proc, COPIAR:proc, CONCAT:proc

START:
    mov AX, @DATA
    mov DS, AX
    mov ES, AX
    fld _5
    fst _x
    ffree
etiq1
    fld _x
    fld _10
    fxch 
    fcom 
    fstsw ax
    sahf
    ffree
    jl etiq2
    fld _x
    fld _4
    fxch 
    fcom 
    fstsw ax
    sahf
    ffree
    jle etiq3
    DisplayFloat _x
    newLine

    jmp etiq1
etiq4
etiq3
etiq2
    mov ax, 4C00h
    int 21h
END START
