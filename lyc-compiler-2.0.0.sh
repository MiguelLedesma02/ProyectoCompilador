#!/bin/bash
SRC_LEXICO="./Compilador/Lexico"
SRC_SINTACTICO="./Compilador/Sintactico"
SRC_TERCETOS="./Compilador/Tercetos"
SRC_PILA="./Compilador/Pila"
SRC_ARCHIVO="./Compilador/Archivo"
SRC_UTILITARIOS="./Compilador/Utilitarios"

INPUTS="./Inputs/test.txt"
OUTPUTS="./Outputs/lexer.txt ./Outputs/parser.txt ./Outputs/intermediate-code.txt"

INCLUDES="-I$SRC_LEXICO -I$SRC_SINTACTICO -I$SRC_TERCETOS -I$SRC_PILA -I$SRC_ARCHIVO -I$SRC_UTILITARIOS"
SOURCES="$SRC_LEXICO/Lexico.c $SRC_SINTACTICO/Sintactico.c $SRC_TERCETOS/Tercetos.c $SRC_PILA/Pila.c $SRC_ARCHIVO/Archivo.c $SRC_UTILITARIOS/Utilitarios.c"
COMPILADOR="lex.yy.c $SRC_SINTACTICO/y.tab.c ./Compilador/main.c"

# Generar archivos con flex y bison
flex "$SRC_LEXICO/Lexico.l"
bison -d -o "$SRC_SINTACTICO/y.tab.c" "$SRC_SINTACTICO/Sintactico.y"

# Compilar el programa
gcc $INCLUDES $COMPILADOR $SOURCES -o compilador

# Ejecutar el compilador
./compilador $INPUTS $OUTPUTS

# Limpiar archivos generados
rm -f compilador lex.yy.c "$SRC_SINTACTICO/y.tab.c" "$SRC_SINTACTICO/y.tab.h"

# Pausar (equivalente a pause en .bat, espera a que el usuario presione Enter)
read -p "Presiona Enter para continuar..."