:: Script para windows
flex ./Lexico/Lexico.l

gcc.exe lex.yy.c ./Lexico/Lexico.c ./Archivo/Archivo.c -o compilador.exe

compilador.exe test.txt lexer.test

@echo off
del compilador.exe
del lex.yy.c

pause
