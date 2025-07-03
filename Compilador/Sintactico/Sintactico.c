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
    
    int i = 0;
    for(i; i < cantVarEnLinea; i ++)
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
    int i = 0;
    for(i; i < cantVarDeclaradas; i ++)
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
    // int indice;
    // int parteIzq = desapilar(Bpila);
    // int parteDer = Eind;
    // char op1[10], op2[10];
    // int auxTD = desapilar(ETDpila);
    // char td[MAX_LONG_TD];

    // if (auxTD == 1)
    //     strcpy(td, "CTE_INTEGER");
    // else
    //     strcpy(td, "CTE_FLOAT");

    // if (strcmp(ETDind, td) != 0)
    //     yyerror("No se pueden comparar tipos de datos incompatibles.");

    // sprintf(op1, "[%d]", parteIzq);
    // sprintf(op2, "[%d]", parteDer);
    // crearTerceto("CMP", op1, op2);

    // // Mapear correctamente el operador de comparación
    // char jump_op[MAX_LONG_STR];
    // if (strcmp(condicion, "<") == 0)
    //     strcpy(jump_op, "BLT");
    // else if (strcmp(condicion, ">") == 0)
    //     strcpy(jump_op, "BGT");
    // else if (strcmp(condicion, ">=") == 0)
    //     strcpy(jump_op, "BGE");
    // else if (strcmp(condicion, "<=") == 0)
    //     strcpy(jump_op, "BLE");
    // else if (strcmp(condicion, "==") == 0)
    //     strcpy(jump_op, "BEQ");
    // else if (strcmp(condicion, "!=") == 0)
    //     strcpy(jump_op, "BNE");
    // else
    //     strcpy(jump_op, condicion); // Por si ya es un operador de salto

    // indice = crearTerceto(jump_op, "_", "_");
    // apilar(Bpila, indice);

    // return indice;
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
    // int inicioWhile;
    // int finWhile;
    // int salto;
    // char op[10];

    // salto = desapilar(Bpila); // e.g., [10] para x > 4
    // inicioWhile = desapilar(Bpila); // e.g., [3] para inicio de condición
    // sprintf(op, "[%d]", inicioWhile);
    // finWhile = crearTerceto("BI", op, "_"); // [18] (BI, [3], _)
    // sprintf(op, "[%d]", finWhile + 1); // [19]
    // // No completar 'salto' aquí, ya que ORPila maneja los saltos al bloque

    // char opAux[10];
    // int inicioBloque = desapilar(AUXPila); // e.g., [11]
    // sprintf(opAux, "[%d]", inicioBloque);

    // // Manejo de OR: Completar con el índice del bloque sin negar
    // while (!pilaVacia(ORPila))
    // {
    //     int aux = desapilar(ORPila); // e.g., [6] para x < 10, [10] para x > 4
    //     completarTerceto(aux, opAux); // Completa con [11]
    // }

    // // Manejo de AND: Completar con la salida
    // while (!pilaVacia(ANDPila))
    // {
    //     int aux = desapilar(ANDPila);
    //     completarTerceto(aux, op);
    // }

    // // Agregar terceto de salida explícito
    // crearTerceto("END", "_", "_"); // [19] (END, _, _)

    // return;
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

    return;
}

void generarWrite(char* str, int string)
{
    /* str es la cadena a imprimir*/
    /* Si es string es 1, se agregan comillas, si es 0 no*/

    char op[1000];

    if(string == 1)
        sprintf(op, "\"%s\"", str);
    else
        sprintf(op, "%s", str);

    Eind = crearTerceto(op, "_", "_");

    sprintf(op, "[%d]", Eind);

    crearTerceto("WRITE", op, "_");

    return;
}

int sumarPrimos(int n)
{
    int suma = 0;
    int contador = 0;
    int numero = 2;

    while (contador < n)
    {
        if (esPrimo(numero))
        {
                suma += numero;
                contador ++;
        }

        numero++;
    }

    return suma;
}

int esPrimo(int n)
{
    if(n < 2)
        return 0;
    int i = 2;
    for(i; i * i <= n; i ++)
        if (n % i == 0) 
            return 0;

    return 1;
}

void reorder(char* o, char* p)
{
    char op1[10];
    char op2[10];

    Eind = crearTerceto(o, "_", "_");
    Aind = crearTerceto("@orden", "_", "_");

    sprintf(op1, "[%d]", Aind);
    sprintf(op2, "[%d]", Eind);
    crearTerceto(":=", op1, op2);

    Eind = crearTerceto(p, "_", "_");
    Aind = crearTerceto("@pivot", "_", "_");

    sprintf(op1, "[%d]", Aind);
    sprintf(op2, "[%d]", Eind);
    crearTerceto(":=", op1, op2);

    int orden = atoi(o);
    int pivot = atoi(p);
    
    validarParametrosReorder(orden, pivot);

    if(orden)
        reorderIzquierda(pivot); 
    else
        reorderDerecha(pivot);
    varAux = 0;

    return;
}

void reorderIzquierda(int pivot)
{
    // pivot: Es la posición que se usa como referencia para el reordenamiento.

    //Variables Locales
    char auxInicial[10];
    char auxFinal[10];
    char op1[10];
    char op2[10];
    int inicio = 0;
    int fin = pivot/2;

    //Se recorre la lista desde el comienzo hasta la mitad
    while(inicio <= fin)
    {
        //Copiar @auxFinal en temp
        sprintf(auxFinal, "@aux%d", pivot - inicio);

        Eind = crearTerceto(auxFinal, "_", "_");
        Aind = crearTerceto("@temp", "_", "_");

        sprintf(op1, "[%d]", Aind);
        sprintf(op2, "[%d]", Eind);

        crearTerceto(":=", op1, op2);

        //Copiar @auxInicial en @auxFinal
        sprintf(auxInicial, "@aux%d", inicio);
        sprintf(auxFinal, "@aux%d", pivot - inicio);

        Eind = crearTerceto(auxInicial, "_", "_");
        Aind = crearTerceto(auxFinal, "_", "_");

        sprintf(op1, "[%d]", Aind);
        sprintf(op2, "[%d]", Eind);

        crearTerceto(":=", op1, op2);

        //Copiar @temp en @auxInicial
        sprintf(auxInicial, "@aux%d", inicio);

        Eind = crearTerceto("@temp", "_", "_");
        Aind = crearTerceto(auxInicial, "_", "_");

        sprintf(op1, "[%d]", Aind);
        sprintf(op2, "[%d]", Eind);

        crearTerceto(":=", op1, op2);

        //Control de condición
        inicio ++;
    }

    return;
}

void reorderDerecha(int pivot)
{
    // pivot: Es la posición que se usa como referencia para el reordenamiento.

    //Variables Locales
    char auxInicial[10];
    char auxFinal[10];
    char op1[10];
    char op2[10];
    int inicio = pivot;
    int fin = varAux;

    while (inicio < fin)
    {
        //Copiar @auxFinal en temp
        sprintf(auxInicial, "@aux%d", inicio);

        Eind = crearTerceto(auxInicial, "_", "_");
        Aind = crearTerceto("@temp", "_", "_");

        sprintf(op1, "[%d]", Aind);
        sprintf(op2, "[%d]", Eind);

        crearTerceto(":=", op1, op2);

        //Copiar @auxInicial en @auxFinal
        sprintf(auxInicial, "@aux%d", inicio);
        sprintf(auxFinal, "@aux%d", fin - 1);

        Eind = crearTerceto(auxFinal, "_", "_");
        Aind = crearTerceto(auxInicial, "_", "_");

        sprintf(op1, "[%d]", Aind);
        sprintf(op2, "[%d]", Eind);

        crearTerceto(":=", op1, op2);

        //Copiar @temp en @auxInicial
        sprintf(auxFinal, "@aux%d", fin - 1);

        Eind = crearTerceto("@temp", "_", "_");
        Aind = crearTerceto(auxFinal, "_", "_");

        sprintf(op1, "[%d]", Aind);
        sprintf(op2, "[%d]", Eind);

        crearTerceto(":=", op1, op2);

        //Control de condición
        inicio++;
        fin--;
    }

    return;
}

void validarParametrosReorder(int orden, int pivot)
{
    //Parámetros
    // orden: Si es 1, reordena a la izquierda del pivot. Si es 0, reordena a la derecha del pivot.
    // pivot: Es la posición que se usa como referencia para el reordenamiento.

    //Si el pivot es igual o superior al tamaño de la lista, no se puede ordenar.
    if(pivot >= varAux)
        yyerror("El pivot supera el tamano de la lista.");

    //Si el pivot es el primer elemento, no se puede reordenar hacia la izquierda.
    if(orden && pivot == 0)
        yyerror("No se puede reordenar hacia la izquierda cuando el pivot es el primer elemento.");

    //Si el pivot es el último elemento, no se puede reordenar hacia la derecha.
    if(!orden && pivot == varAux)
        yyerror("No se puede reordenar hacia la derecha cuando el pivot es el ultimo elemento.");

    return;
}