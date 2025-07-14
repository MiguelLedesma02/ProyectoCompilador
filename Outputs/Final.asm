include macros2.asm
include number.asm

.MODEL LARGE
.386
.STACK 200h

.DATA

    _x  dd  ?
    _y  dd  ?
    _a  dd  ?
    _b  dd  ?
    _c  dd  ?
    _var1   db  '?', '$'
    __  db  '.', '$'
    _STRINGS    db  'STRINGS', '$'
    _Ingrese_una_palabra_   db  'Ingrese una palabra:', '$'
    _La_palabra_es__    db  'La palabra es: ', '$'
    _@1 dd  -1
    _ANTES_REORDER  db  'ANTES REORDER', '$'
    _DESPUES_REORDER    db  'DESPUES REORDER', '$'
    _@temp  dd  ?
    _@orden dd  ?
    _@pivot dd  ?
    _@cond1 dd  ?
    _@cond2 dd  ?

.CODE

Start:

    mov AX, @DATA
    mov DS, AX
    mov ES, AX

    displayString __
    newLine

    displayString _STRINGS
    newLine

    displayString __
    newLine

    displayString _Ingrese_una_palabra_
    newLine

    getString _var1
    newLine

    displayString _La_palabra_es__
    newLine

    displayString _var1
    newLine

mov AX, 4C00H
int 21H
END Start
