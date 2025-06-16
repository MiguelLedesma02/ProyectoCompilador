#include "Sintactico.h"

/*FUNCIONES SEMÁNTICAS*/

int setTipoDato(FILE *pf, FILE *ptemp, char* tipoDato)
{
    if(strcmp(tipoDato, "int") == 0)
        strcpy(tipoDato, "CTE_INTEGER");

    else if(strcmp(tipoDato, "float") == 0)
        strcpy(tipoDato, "CTE_FLOAT");

    else if(strcmp(tipoDato, "string") == 0)
        strcpy(tipoDato, "CTE_STRING");

    for(int i = 0; i < cantVarEnLinea; i ++)
    {
        entrada_ts aux;

        aux = buscarToken(pf, varEnLinea[i]);
        
        if(strcmp(aux.nombre, "NO ENCONTRADA") == 0)
            return 0;

        strcpy(aux.tipoDato, tipoDato);

        modificarToken(pf, ptemp, aux);

        fclose(ptemp);
        fclose(pf);

        remove("./Outputs/symbol_table.txt");
        rename("temp.txt", "./Outputs/symbol_table.txt");

        if(abrirArchivo(&pf, "./Outputs/symbol_table.txt", "r+t") == 1)
            return 0;

        if(abrirArchivo(&ptemp, "temp.txt", "wt") == 1)
            return 0;
    }

    cantVarEnLinea = 0;

    return 1;
}

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