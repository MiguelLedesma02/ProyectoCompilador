#ifndef ARCHIVO_H
#define ARCHIVO_H

#include "../Utilitarios/Utilitarios.h"

/*ESTRUCTURAS*/
typedef struct
{
    char nombre[MAX_LONG_ID];
    char tipoDato[MAX_LONG_TD];
    char valor[MAX_LONG_STR];
    unsigned longitud;
} entrada_ts;

/*FUNCIONES*/
int abrirArchivo(FILE** pf, char* nombreArchivo, char* modo);
int agregarTablaSimbolos(char* tk, int id);
int buscarTokenEnArchivo(FILE* pf, char* tk);

#endif