include macros2.asm
include number.asm

.MODEL LARGE
.386
.STACK 200h

.DATA
    _x dd ?
    __5 dd 5
    __10 dd 10
.CODE
extrn STRLEN:proc, COPIAR:proc, CONCAT:proc

START:
    mov AX, @DATA
    mov DS, AX
    mov ES, AX
    fld 5
    fld 10
    fadd
    ffree 1
    fst x
    ffree
    mov ax, 4C00h
    int 21h
END START
