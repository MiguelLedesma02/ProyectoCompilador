:: Script para windows
flex lex.l

gcc.exe lex.yy.c -o compilador.exe

compilador.exe test.txt

@echo off
del compilador.exe
del lex.yy.c

pause
