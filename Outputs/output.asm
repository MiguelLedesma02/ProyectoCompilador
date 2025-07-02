include macros2.asm
include number.asm

.MODEL LARGE
.386
.STACK 200h

.DATA
    _x db '-', '$'
    _y db '-', '$'
    _z db '-', '$'
    _HolaMundo! db 'Hola Mundo!', '$'
.CODE
extrn STRLEN:proc, COPIAR:proc, CONCAT:proc

START:
    mov AX, @DATA
    mov DS, AX
    mov ES, AX
    displayString Hola Mundo!
    newLine

    mov ax, 4C00h
    int 21h
END START
