#!/bin/bash
 
# RUTAS A CARPETAS Y ARCHIVOS
SRC_LEXICO=./Compilador/Lexico
SRC_SINTACTICO=./Compilador/Sintactico
SRC_TERCETOS=./Compilador/Tercetos
SRC_PILA=./Compilador/Pila
SRC_ARCHIVO=./Compilador/Archivo
SRC_UTILITARIOS=./Compilador/Utilitarios
 
INPUTS=./Inputs/test.txt
OUTPUTS="./Outputs/lexer.txt ./Outputs/parser.txt ./Outputs/intermediate-code.txt"
 
INCLUDES="-I$SRC_LEXICO -I$SRC_SINTACTICO -I$SRC_TERCETOS -I$SRC_PILA -I$SRC_ARCHIVO -I$SRC_UTILITARIOS"
SOURCES="$SRC_LEXICO/Lexico.c $SRC_SINTACTICO/Sintactico.c $SRC_TERCETOS/Tercetos.c $SRC_PILA/Pila.c $SRC_ARCHIVO/Archivo.c $SRC_UTILITARIOS/Utilitarios.c"
COMPILADOR="lex.yy.c $SRC_SINTACTICO/y.tab.c ./Compilador/main.c"
 
# GENERAR ANALIZADOR LÉXICO Y SINTÁCTICO
flex $SRC_LEXICO/Lexico.l
bison -d -o $SRC_SINTACTICO/y.tab.c $SRC_SINTACTICO/Sintactico.y
 
# COMPILAR
gcc $INCLUDES $COMPILADOR $SOURCES -o compilador.out
 
# EJECUTAR
./compilador.out $INPUTS $OUTPUTS
 
# LIMPIAR ARCHIVOS INTERMEDIOS
rm -f compilador.out
rm -f lex.yy.c
rm -f $SRC_SINTACTICO/y.tab.c
rm -f $SRC_SINTACTICO/y.tab.h
 
# ESPERAR INPUT PARA FINALIZAR
read -p "Presione ENTER para salir..."