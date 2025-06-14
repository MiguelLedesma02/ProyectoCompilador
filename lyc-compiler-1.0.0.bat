:: RUTAS A CARPETAS Y ARCHIVOS
set SRC_LEXICO=./Compilador/Lexico
set SRC_ARCHIVO=./Compilador/Archivo
set SRC_UTILITARIOS=./Compilador/Utilitarios

set INPUTS=./Inputs/test.txt
set OUTPUTS=./Outputs/lexer.test

set INCLUDES=-I%SRC_LEXICO% -I%SRC_ARCHIVO% -I%SRC_UTILITARIOS%
set SOURCES=%SRC_LEXICO%/Lexico.c %SRC_ARCHIVO%/Archivo.c

flex ./Compilador/Lexico/Lexico.l

gcc.exe %INCLUDES% lex.yy.c %SOURCES% -o compilador.exe

compilador.exe %INPUTS% %OUTPUTS%

@echo off
del compilador.exe
del lex.yy.c

pause
