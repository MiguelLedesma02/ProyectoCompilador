#include "Sintactico.h"

/*FUNCIONES SEMÁNTICAS*/

int generarCondicion(char* condicion)
{
    /*condicion es el salto que debe realizar*/
    int indice;

    int parteIzq;
    int parteDer;

    parteIzq = desapilar(Bpila);
    parteDer = Eind;
    
    char op1[10];
    char op2[10];

    sprintf(op1, "[%d]", parteIzq);
    sprintf(op2, "[%d]", parteDer);

    crearTerceto("CMP", op1, op2);
    indice = crearTerceto(condicion, "_", "_");

    apilar(Bpila, indice);

    return indice;
}

void negarCondicion(int indice)
{
    /*indice indica el terceto que contiene la condición de salto*/

    char condicion[MAX_LONG_STR];

    strcpy(condicion, verOperadorTerceto(indice));

    if(strcmp(condicion, "BGT") == 0)
        strcpy(condicion, "BLE");

    else if(strcmp(condicion, "BGE") == 0)
            strcpy(condicion, "BLT");

    else if(strcmp(condicion, "BLT") == 0)
            strcpy(condicion, "BGE");

    else if(strcmp(condicion, "BLE") == 0)
            strcpy(condicion, "BGT");

    else if(strcmp(condicion, "BEQ") == 0)
            strcpy(condicion, "BNE");

    else if(strcmp(condicion, "BNE") == 0)
            strcpy(condicion, "BEQ");

    modificarOperadorTerceto(indice, condicion);
}