include macros2.asm
include number.asm

.MODEL LARGE
.386
.STACK 200h

.DATA
    _x dd ?
    _a dd ?
    _c dd ?
    _r dd ?
    _z dd ?
    _f dd ?
    _b db '-', '$'
    __3 dd 3
    __1 dd 1
    __9 dd 9
    __0 dd 0
    __9999999 dd 99999.99
    __99 dd 99.
    __9999 dd .9999
    _sdADaSjfladfg db '@sdADaSjfla%dfg', '$'
    _asldkfhsjf db 'asldk  fh sjf', '$'
    __27 dd 27
    __500 dd 500
    __34 dd 34
    __4 dd 4
    _ewr db 'ewr', '$'
    __2 dd 2
    __5 dd 5
    _aux0 dd ?
    _aux1 dd ?
    _aux2 dd ?
    _orden dd ?
    _pivot dd ?
    _temp dd ?
.CODE
extrn STRLEN:proc, COPIAR:proc, CONCAT:proc

START:
    mov AX, @DATA
    mov DS, AX
    mov ES, AX
    fld __temp1
    fadd __temp1
    fstp _temp2
    fld __temp2
    fstp __temp2
    fld __temp6
    fadd __temp6
    fstp _temp7
    fld __temp7
    fstp __temp7
    fld __temp11
    fsub __temp11
    fstp _temp12
    fld __temp12
    fstp __temp12
    fld __temp15
    fstp __temp15
    fld __temp18
    fstp __temp18
    fld __temp21
    fstp __temp21
    fld __temp24
    fstp __temp24
    fld __temp27
    fstp __temp27
    fld __temp30
    fstp __temp30
    fld __temp33
    fstp __temp33
    fld __temp36
    fstp __temp36
    fld __temp39
    fstp __temp39
    fld __temp42
    fstp __temp42
    fld __temp45
    fstp __temp45
    fld __temp48
    fstp __temp48
    fld __temp51
    fstp __temp51
    fld __temp55
    fsub __temp55
    fstp _temp56
    fld __temp56
    fstp __temp56
    fld __temp60
    fadd __temp60
    fstp _temp61
    fld __temp61
    fstp __temp61
    fld __temp65
    fmul __temp65
    fstp _temp66
    fld __temp66
    fstp __temp66
    fld __temp70
    fdiv __temp70
    fstp _temp71
    fld __temp71
    fstp __temp71
    fld __temp74
    fstp __temp74
    fld __temp77
    fstp __temp77
    GetFloat __temp80
    displayString __temp82
    newLine 1
    fld __temp84
    fstp __temp84
    fld __temp87
    fstp __temp87
    fld __temp90
    fstp __temp90
    fld __temp94
    fadd __temp94
    fstp _temp95
    fld __temp95
    fstp __temp95
    fld __temp99
    fadd __temp99
    fstp _temp100
    fld __temp100
    fstp __temp100
    fld __temp104
    fsub __temp104
    fstp _temp105
    fld __temp105
    fstp __temp105
    fld __temp108
    fstp __temp108
    fld __temp111
    fstp __temp111
    fld __temp114
    fstp __temp114
    fld __temp117
    fstp __temp117
    fld __temp120
    fstp __temp120
    fld __temp123
    fstp __temp123
    fld __temp126
    fstp __temp126
    fld __temp129
    fstp __temp129
    fld __temp134
    fstp __temp134
    mov ax, 4C00h
    int 21h
END START
