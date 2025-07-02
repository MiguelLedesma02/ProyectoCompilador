include macros2.asm
include number.asm

.MODEL LARGE
.386
.STACK 200h

.DATA
    _s db '-', '$'
    _xesmenorque4 db 'x es menor que 4', '$'
.CODE
extrn STRLEN:proc, COPIAR:proc, CONCAT:proc

START:
    mov AX, @DATA
    mov DS, AX
    mov ES, AX
    displayString __temp0
    newLine 1
    mov ax, 4C00h
    int 21h
END START
