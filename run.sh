#!/bin/bash

# Compilar con flex
flex lex.l

# Compilar el archivo generado con GCC
gcc lex.yy.c -o compilador

# Ejecutar el compilador con test.txt
./compilador test.txt

# Borrar archivos generados
rm -f compilador lex.yy.c
