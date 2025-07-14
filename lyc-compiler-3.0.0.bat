@echo off

:: RUTAS A CARPETAS Y ARCHIVOS
set SRC_LEXICO=./Compilador/Lexico
set SRC_SINTACTICO=./Compilador/Sintactico
set SRC_TERCETOS=./Compilador/Tercetos
set SRC_PILA=./Compilador/Pila
set SRC_LISTA=./Compilador/Lista
set SRC_ARCHIVO=./Compilador/Archivo
set SRC_UTILITARIOS=./Compilador/Utilitarios

set INPUTS=./Inputs/test.txt
set OUTPUTS=./Outputs/lexer.txt ./Outputs/parser.txt ./Outputs/intermediate-code.txt

set INCLUDES=-I%SRC_LEXICO% -I%SRC_SINTACTICO% -I%SRC_TERCETOS% -I%SRC_PILA% -I%SRC_LISTA% -I%SRC_ARCHIVO% -I%SRC_UTILITARIOS%
set SOURCES=%SRC_LEXICO%/Lexico.c %SRC_SINTACTICO%/Sintactico.c %SRC_TERCETOS%/Tercetos.c %SRC_PILA%/Pila.c %SRC_LISTA%/Lista.c %SRC_ARCHIVO%/Archivo.c %SRC_UTILITARIOS%/Utilitarios.c
set COMPILADOR=lex.yy.c %SRC_SINTACTICO%/y.tab.c ./Compilador/main.c

flex %SRC_LEXICO%/Lexico.l
bison -d -o %SRC_SINTACTICO%/y.tab.c %SRC_SINTACTICO%/Sintactico.y

gcc.exe %INCLUDES% %COMPILADOR% %SOURCES% -o compilador.exe

compilador.exe %INPUTS% %OUTPUTS%

del compilador.exe
del lex.yy.c
del Compilador\Sintactico\y.tab.c
del Compilador\Sintactico\y.tab.h

pause
