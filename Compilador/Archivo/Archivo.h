#ifndef ARCHIVO_H
#define ARCHIVO_H

#include "../Utilitarios/Utilitarios.h"

/*FUNCIONES*/
int abrirArchivo(FILE** pf, char* nombreArchivo, char* modo);
entrada_ts buscarToken(FILE* pf, char* tk);
void agregarToken(FILE* pf, char* tk, char* tipo);
void modificarToken(FILE* pf, FILE* ptemp, entrada_ts nuevaEntrada);
char* getTipo(FILE *pf, char* tk, char* td);

#endif