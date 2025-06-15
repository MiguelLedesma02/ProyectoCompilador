#ifndef TERCETOS_H
#define TERCETOS_H

#include "../Utilitarios/Utilitarios.h"

/*CONSTANTES*/
#define MAX_TERCETOS 1000

/*VARIABLES GLOBALES*/
extern FILE *ptercetos;

/*ESTRUCTURA*/
typedef struct
{
    char operador[MAX_LONG_STR];
    char operando1[10];
    char operando2[10];
} Terceto;

/*VARIABLES GLOBALES*/
extern Terceto tercetos[MAX_TERCETOS];
extern int indiceTerceto;

int crearTerceto(char* operador, char* op1, char* op2);
void completarTerceto(int indice, char* op);
void imprimirTercetos();

#endif