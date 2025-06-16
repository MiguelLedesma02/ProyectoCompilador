#ifndef UTILITARIOS_H
#define UTILITARIOS_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*CONSTANTES*/
#define MAX_LONG_ID 30
#define MAX_LONG_STR 50
#define MAX_LONG_TD 15
#define MAX_LONG_LONG 10

/*ESTRUCTURAS*/
typedef struct
{
    char nombre[MAX_LONG_ID];
    char tipoDato[MAX_LONG_TD];
    char valor[MAX_LONG_STR];
    unsigned longitud;
} entrada_ts;

/*FUNCIONES*/
void eliminarCaracter(char* str, char ch);

#endif