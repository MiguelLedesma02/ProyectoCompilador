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

int declararVar(char* var)
{
    /*Se retorna 1 si la variable se guardó correctamente.*/
    /*Se retorna 0 si la variable ya existe.*/

    /*var es la variable*/

    if(buscarVar(var) == 1)
        return 0;

    strcpy(varDeclaradas[cantVarDeclaradas], var);

    cantVarDeclaradas ++;

    return 1;
}

int buscarVar(char* var)
{
    /*Se retorna 1 si la variable ya existe.*/
    /*Se retorna 0 si la variable no existe.*/

    /*var es la variable*/

    for(int i = 0; i < cantVarDeclaradas; i ++)
    {
        if(strcmp(var, varDeclaradas[i]) == 0)
            return 1;
    }

    return 0;
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

    int auxTD = desapilar(ETDpila);
    char td[MAX_LONG_TD];

    if(auxTD == 1)
        strcpy(td, "CTE_INTEGER");
    else
        strcpy(td, "CTE_FLOAT");

    if(strcmp(ETDind, td) != 0)
        yyerror("No se pueden comparar tipos de datos incompatibles.");

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

void generarWhile()
{
    int inicioWhile;
    int finWhile;
    int salto;
    char op[10];

    salto = desapilar(Bpila);
    inicioWhile = desapilar(Bpila);

    sprintf(op, "[%d]", inicioWhile);
    finWhile = crearTerceto("BI", op, "_");

    sprintf(op, "[%d]", finWhile + 1);
    completarTerceto(salto, op);

    char opAux[10];
    int inicioBloque = desapilar(AUXPila);
    sprintf(opAux, "[%d]", inicioBloque);

    while(!pilaVacia(ORPila))
    {
        int aux = desapilar(ORPila);
        negarCondicion(aux);
        completarTerceto(aux, opAux);
    }

    while(!pilaVacia(ANDPila))
    {
        int aux = desapilar(ANDPila);
        completarTerceto(aux, op);
    }

    return;
}

void generarIf()
{
    int salto;
    int finIf;
    char op[10];

    salto = desapilar(Bpila);
    finIf = indiceTerceto;

    sprintf(op, "[%d]", finIf);
    completarTerceto(salto, op);

    char opAux[10];
    int inicioBloque = desapilar(AUXPila);
    sprintf(opAux, "[%d]", inicioBloque);

    while(!pilaVacia(ORPila))
    {
        int aux = desapilar(ORPila);
        negarCondicion(aux);
        completarTerceto(aux, opAux);
    }

    while(!pilaVacia(ANDPila))
    {
        int aux = desapilar(ANDPila);
        completarTerceto(aux, op);
    }

    return;
}

void generarInicioIfElse()
{
    int salto;
    int finIf;
    char op[10];

    salto = desapilar(Bpila);
    finIf = crearTerceto("BI", "_", "_");
    apilar(Bpila, finIf);

    sprintf(op, "[%d]", finIf + 1);
    completarTerceto(salto, op);

    char opAux[10];
    int inicioBloque = desapilar(AUXPila);
    sprintf(opAux, "[%d]", inicioBloque);

    while(!pilaVacia(ORPila))
    {
        int aux = desapilar(ORPila);
        negarCondicion(aux);
        completarTerceto(aux, opAux);
    }

    return;
}

void generarFinIfElse()
{
    int salto;
    int finElse;
    char op[10];

    salto = desapilar(Bpila);
    finElse = indiceTerceto;

    sprintf(op, "[%d]", finElse);
    completarTerceto(salto, op);

    char opAux[10];
    int inicioBloque = desapilar(AUXPila);
    sprintf(opAux, "[%d]", inicioBloque);

    while(!pilaVacia(ANDPila))
    {
        int aux = desapilar(ANDPila);
        completarTerceto(aux, opAux);
    }

    return;
}

void generarRead(char* id)
{
    /* id es el id donde se almacenará la entrada*/

    char op[10];

    Eind = crearTerceto(id, "_", "_");

    sprintf(op, "[%d]", Eind);

    crearTerceto("READ", op, "_");
}

void generarWrite(char* str, int string)
{
    /* str es la cadena a imprimir*/
    /* Si es string es 1, se agregan comillas, si es 0 no*/

    char op[10];

    if(string == 1)
        sprintf(op, "\"%s\"", str);
    else\
        sprintf(op, "%s", str);

    Eind = crearTerceto(op, "_", "_");

    sprintf(op, "[%d]", Eind);

    crearTerceto("WRITE", op, "_");
}