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
    _1 dd 1
.CODE
extrn STRLEN:proc, COPIAR:proc, CONCAT:proc

START:
    mov AX, @DATA
    mov DS, AX
    mov ES, AX
    fld _5
    fst _x
    ffree
etiq3:
etiq1:
    fld _x
    fld _10
    fxch 
    fcom 
    fstsw ax
    sahf
    ffree
    jl etiq11
    fld _x
    fld _4
    fxch 
    fcom 
    fstsw ax
    sahf
    ffree
    jle etiq19
etiq11:
    DisplayFloat _x
    newLine

    fld _x
    fld _1
    fadd 
    ffree 1 
    fst _x
    ffree
    jmp etiq1
etiq19:
    mov ax, 4C00h
    int 21h
END START
