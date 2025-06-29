#ifndef TERCETOS_H
#define TERCETOS_H

#include "../Utilitarios/Utilitarios.h"
#include "../Lista/Lista.h"

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
char* verOperadorTerceto(int indice);
void modificarOperadorTerceto(int indice, char* op);
void imprimirTercetos();
void generar_assembler(tLista* listaSimbolos);
void imprimirEncabezadoAss(FILE* archivo);
int desapilarTercetos();
void apilarTercetos(int t);
void modificarTerceto_saltoCondicional(int indice);


#endif