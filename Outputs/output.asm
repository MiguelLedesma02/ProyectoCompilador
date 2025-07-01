include macros2.asm
include number.asm

.MODEL LARGE
.386
.STACK 200h

.DATA
    _a dd ?
    _b dd ?
    __10 dd 10
    __5 dd 5
    _temp0 dd ?
    _temp1 dd ?
    _temp2 dd ?
    _temp3 dd ?
    _temp4 dd ?
    _temp5 dd ?
    _temp6 dd ?
.CODE
extrn STRLEN:proc, COPIAR:proc, CONCAT:proc

START:
    mov AX, @DATA
    mov DS, AX
    mov ES, AX
    fld __temp2
    fmul __temp2
    fstp _temp3
    fld __temp3
    fadd __temp3
    fstp _temp4
    fld __temp4
    fstp __temp4
    mov ax, 4C00h
    int 21h
END START
