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
int buscarToken(FILE* pf, char* tk);
void agregarToken(FILE* pf, char* tk, char* tipo);
void eliminarCaracter(char* str, char ch);

#endif