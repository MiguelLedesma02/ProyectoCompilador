#include "Tercetos.h"

/*VARIABLES GLOBALES*/
Terceto tercetos[MAX_TERCETOS];
int indiceTerceto = 0;

int crearTerceto(char* operador, char* op1, char* op2)
{
    /* operador es el operador */
    /* op1 es el operando izquierdo */
    /* op2 es el operando derecho */

    strcpy(tercetos[indiceTerceto].operador, operador);
    strcpy(tercetos[indiceTerceto].operando1, op1);
    strcpy(tercetos[indiceTerceto].operando2, op2);

    return indiceTerceto++;
}

void completarTerceto(int indice, char* op)
{
    /* Esto se usa para completar los saltos */
    /* indice indica el terceto */
    /* op es el único operando */

    strcpy(tercetos[indice].operando1, op);

    return;
}

char* verOperadorTerceto(int indice)
{
    /* indice indica el terceto */

    return tercetos[indice].operador;
}

void modificarOperadorTerceto(int indice, char* op)
{
    /* Esto se usa para negar la condición de salto */
    /* indice indica el terceto */
    /* op es el salto */

    strcpy(tercetos[indice].operador, op);
}

void imprimirTercetos()
{
    int i = 0;
    for (i; i < indiceTerceto; i++)
        fprintf(ptercetos, "[%d] (%s, %s, %s)\n", i, tercetos[i].operador, tercetos[i].operando1, tercetos[i].operando2);

    return;
}