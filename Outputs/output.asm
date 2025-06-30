include macros2.asm
include number.asm

.MODEL LARGE
.386
.STACK 200h

.DATA
    _a dd ?
    _x dd ?
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
    _temp0 dd ?
    _temp1 dd ?
    _temp2 dd ?
    _temp3 dd ?
    _temp4 dd ?
    _temp5 dd ?
    _temp6 dd ?
    _temp7 dd ?
    _temp8 dd ?
    _temp9 dd ?
    _temp10 dd ?
    _temp11 dd ?
    _temp12 dd ?
    _temp13 dd ?
    _temp14 dd ?
    _temp15 dd ?
    _temp16 dd ?
    _temp17 dd ?
    _temp18 dd ?
    _temp19 dd ?
    _temp20 dd ?
    _temp21 dd ?
    _temp22 dd ?
    _temp23 dd ?
    _temp24 dd ?
    _temp25 dd ?
    _temp26 dd ?
    _temp27 dd ?
    _temp28 dd ?
    _temp29 dd ?
    _temp30 dd ?
    _temp31 dd ?
    _temp32 dd ?
    _temp33 dd ?
    _temp34 dd ?
    _temp35 dd ?
    _temp36 dd ?
    _temp37 dd ?
    _temp38 dd ?
    _temp39 dd ?
    _temp40 dd ?
    _temp41 dd ?
    _temp42 dd ?
    _temp43 dd ?
    _temp44 dd ?
    _temp45 dd ?
    _temp46 dd ?
    _temp47 dd ?
    _temp48 dd ?
    _temp49 dd ?
    _temp50 dd ?
    _temp51 dd ?
    _temp52 dd ?
    _temp53 dd ?
    _temp54 dd ?
    _temp55 dd ?
    _temp56 dd ?
    _temp57 dd ?
    _temp58 dd ?
    _temp59 dd ?
    _temp60 dd ?
    _temp61 dd ?
    _temp62 dd ?
    _temp63 dd ?
    _temp64 dd ?
    _temp65 dd ?
    _temp66 dd ?
    _temp67 dd ?
    _temp68 dd ?
    _temp69 dd ?
    _temp70 dd ?
    _temp71 dd ?
    _temp72 dd ?
    _temp73 dd ?
    _temp74 dd ?
    _temp75 dd ?
    _temp76 dd ?
    _temp77 dd ?
    _temp78 dd ?
    _temp79 dd ?
    _temp80 dd ?
    _temp81 dd ?
    _temp82 dd ?
    _temp83 dd ?
    _temp84 dd ?
    _temp85 dd ?
    _temp86 dd ?
    _temp87 dd ?
    _temp88 dd ?
    _temp89 dd ?
    _temp90 dd ?
    _temp91 dd ?
    _temp92 dd ?
    _temp93 dd ?
    _temp94 dd ?
    _temp95 dd ?
    _temp96 dd ?
    _temp97 dd ?
    _temp98 dd ?
    _temp99 dd ?
    _temp100 dd ?
    _temp101 dd ?
    _temp102 dd ?
    _temp103 dd ?
    _temp104 dd ?
    _temp105 dd ?
    _temp106 dd ?
    _temp107 dd ?
    _temp108 dd ?
    _temp109 dd ?
    _temp110 dd ?
    _temp111 dd ?
    _temp112 dd ?
    _temp113 dd ?
    _temp114 dd ?
    _temp115 dd ?
    _temp116 dd ?
    _temp117 dd ?
    _temp118 dd ?
    _temp119 dd ?
    _temp120 dd ?
    _temp121 dd ?
    _temp122 dd ?
    _temp123 dd ?
    _temp124 dd ?
    _temp125 dd ?
    _temp126 dd ?
    _temp127 dd ?
    _temp128 dd ?
    _temp129 dd ?
    _temp130 dd ?
    _temp131 dd ?
    _temp132 dd ?
    _temp133 dd ?
    _temp134 dd ?
    _temp135 dd ?
    _temp136 dd ?
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
