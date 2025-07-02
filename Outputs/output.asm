include macros2.asm
include number.asm

.MODEL LARGE
.386
.STACK 200h

.DATA
    _x dd ?
    __5 dd 5
    _x db 'x', '$'
.CODE
extrn STRLEN:proc, COPIAR:proc, CONCAT:proc

START:
    mov AX, @DATA
    mov DS, AX
    mov ES, AX
    displayString __temp4
    newLine 1
    mov ax, 4C00h
    int 21h
END START
