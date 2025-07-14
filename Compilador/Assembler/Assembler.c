#include "Assembler.h"
#include <stdio.h>

//VARIABLES GLOBALES
int numLineas;
int numTercetos;

lineaTS lineas[MAX_TAM_VARIABLES];
terceto ternas[MAX_TAM_TERCETOS];

void generarAssembler(char* symbolTableFile, char* intermediaCodeFile, char* assemblerCodeFile)
{
    FILE* pAC;

    cargarVariables(symbolTableFile);
    cargarTercetos(intermediaCodeFile);

    if(abrirArchivo(&pAC, assemblerCodeFile, "wt") == 1)
        return;

    generarHeaders(&pAC);
    generarVariables(&pAC);
    generarCodigo(&pAC);

    fclose(pAC);

    return;
}

void cargarVariables(char* symbolTableFile)
{
    int menosUno = 0;
    FILE* pST;
    char linea[MAX_TAM_LINEA];

    if(abrirArchivo(&pST, symbolTableFile, "rt") == 1)
        return;

    //Se cargan las variables y constantes del programador
    while(fgets(linea, MAX_TAM_LINEA, pST) && numLineas < MAX_TAM_VARIABLES)
    {
        //Se guarda la variable en memoria
        sscanf(linea, "%[^|]|%[^|]|%[^|]|%u",
               lineas[numLineas].nombre,
               lineas[numLineas].tipoDato,
               lineas[numLineas].valor,
               &lineas[numLineas].longitud);

        if(strcmp(lineas[numLineas].valor, "-1") == 0)
            menosUno = 1;

        numLineas ++;
    }

    if(menosUno == 0)
    {
        strcpy(lineas[numLineas].nombre, "-1");
        strcpy(lineas[numLineas].tipoDato, "CTE_INTEGER");
        strcpy(lineas[numLineas].valor, "-1");
        lineas[numLineas].longitud = 2;

        numLineas ++;
    }

    fclose(pST);

    return;
}

void cargarTercetos(char* intermediaCodeFile)
{
    FILE* pIC;
    char linea[MAX_TAM_LINEA];

    if(abrirArchivo(&pIC, intermediaCodeFile, "rt") == 1)
        return;

    //Se cargan los tercetos
    while(fgets(linea, MAX_TAM_LINEA, pIC) && numTercetos < MAX_TAM_TERCETOS)
    {
        //Se guarda la variable en memoria
        sscanf(linea, "[%d] (%[^,], %[^,], %[^\n)])",
               &ternas[numTercetos].indice,
               ternas[numTercetos].op,
               ternas[numTercetos].arg1,
               ternas[numTercetos].arg2);

        numTercetos ++;
    }

    fclose(pIC);
    
    return;
}

void generarHeaders(FILE** pAC)
{
    fprintf(*pAC, "include macros2.asm\n");
    fprintf(*pAC, "include number.asm\n\n");
    fprintf(*pAC, ".MODEL LARGE\n");
    fprintf(*pAC, ".386\n");
    fprintf(*pAC, ".STACK 200h\n\n");

    return;
}

void generarVariables(FILE** pAC)
{
    int i;
    int numAux = -1;
    int maxAux = -1;
    char var[MAX_LONG_ID];

    fprintf(*pAC, ".DATA\n\n");

    //Se generan las variables del programador
    for(i = 0; i < numLineas; i ++)
        crearVariableProgramador(pAC, lineas[i]);

    //Se buscan todas las variables @auxN siendo N un número
    for(i = 0; i < numTercetos; i ++)
    {
        if(strstr(ternas[i].op, "@aux"))
        {
            sscanf(ternas[i].op, "@aux%d", &numAux);
            if(maxAux < numAux)
                maxAux = numAux;
        }
    }

    //Se generan las variables del compilador
    crearVariableCompilador(pAC, "ANTES_REORDER", "CTE_STRING", "ANTES REORDER", 16);
    crearVariableCompilador(pAC, "DESPUES_REORDER", "CTE_STRING", "DESPUES REORDER", 18);
    crearVariableCompilador(pAC, "@temp", "VAR_INTEGER", "-", 5);
    crearVariableCompilador(pAC, "@orden", "VAR_INTEGER", "-", 6);
    crearVariableCompilador(pAC, "@pivot", "VAR_INTEGER", "-", 6);
    crearVariableCompilador(pAC, "@cond1", "VAR_INTEGER", "-", 6);
    crearVariableCompilador(pAC, "@cond2", "VAR_INTEGER", "-", 6);

    for(i = 0; i <= maxAux; i ++)
    {
        sprintf(var, "@aux%d", i);
        crearVariableCompilador(pAC, var, "VAR_INTEGER", "-", strlen(var));
    }
        

    fprintf(*pAC, "\n");

    return;
}

void generarCodigo(FILE** pAC)
{
    generarInicio(pAC);
    generarInstrucciones(pAC);
    generarFin(pAC);

    return;
}

void crearVariableProgramador(FILE** pAC, lineaTS linea)
{
    //Si es una variable, se escribe un '?'. Si es una constante se escribe su valor
    if(strcmp(linea.valor, "-") == 0)
        strcpy(linea.valor, "?");

    if(strcmp(linea.tipoDato, "CTE_STRING") == 0 || strcmp(linea.tipoDato, "VAR_STRING") == 0)
    {
        formatearCadena(linea.nombre);
        fprintf(*pAC, "\t_%s\tdb\t'%s', '$'\n", linea.nombre, linea.valor);
    }

    if(strcmp(linea.tipoDato, "CTE_INTEGER") == 0 || strcmp(linea.tipoDato, "VAR_INTEGER") == 0)
    {
        if(strcmp(linea.valor, "?") == 0)
            fprintf(*pAC, "\t_%s\tdd\t?\n", linea.nombre);
        else
        {
            formatearNumero(linea.nombre);
            fprintf(*pAC, "\t_%s\tdd\t%d\n", linea.nombre, atoi(linea.valor));
        }
    }

    if(strcmp(linea.tipoDato, "CTE_FLOAT") == 0 || strcmp(linea.tipoDato, "VAR_FLOAT") == 0)
    {
        if(strcmp(linea.valor, "?") == 0)
            fprintf(*pAC, "\t_%s\tdd\t?\n", linea.nombre);
        else
        {
            formatearNumero(linea.nombre);
            fprintf(*pAC, "\t_%s\tdd\t%.2f\n", linea.nombre, atof(linea.valor));
        }
    }
    
    return;
}

void crearVariableCompilador(FILE** pAC, char *nombre, char *tipoDato, char *valor, int longitud)
{
    //printf("%s\n", tipoDato);
    strcpy(lineas[numLineas].nombre, nombre);
    strcpy(lineas[numLineas].tipoDato, tipoDato);
    strcpy(lineas[numLineas].valor, valor);
    lineas[numLineas].longitud = longitud;

    if(strcmp(tipoDato, "CTE_STRING") == 0)
        fprintf(*pAC, "\t_%s\tdb\t'%s', '$'\n", nombre, valor);
    else
        fprintf(*pAC, "\t_%s\tdd\t?\n", nombre);

    numLineas ++;

    return;
}

void generarInicio(FILE** pAC)
{
    fprintf(*pAC, ".CODE\n\n");
    fprintf(*pAC, "Start:\n\n");
    fprintf(*pAC, "\tmov AX, @DATA\n");
    fprintf(*pAC, "\tmov DS, AX\n");
    fprintf(*pAC, "\tmov ES, AX\n\n");

    return;
}

void generarInstrucciones(FILE** pAC)
{
    int i;
    NodoLista* actual;
    Lista* etiquetas;

    etiquetas = crearLista();

    crearEtiquetas(&etiquetas);

    for(i = 0; i < numTercetos; i ++)
    {
        //Busca si este terceto es alcanzado por un salto
        if(buscarYEliminar(etiquetas, i))
            generarEtiqueta(pAC, i);

        if(esLectura(i))
            generarLectura(pAC, i);

        if(esEscritura(i))
            generarEscritura(pAC, i);
        
        if(esAsignacion(i))
            generarAsignacion(pAC, i);
        
        if(esOperacion(i))
            generarOperacion(pAC, i);

        if(esComparacion(i))
            generarComparacion(pAC, i);

        if(esSalto(i))
            generarSalto(pAC, i);

        if(esSFP(i))
            generarSFP(pAC, i+1);
    }

    actual = etiquetas->cabeza;
    while (actual != NULL)
    {
        if(actual->dato >= numTercetos)
            generarEtiqueta(pAC, actual->dato);
            
        actual = actual->sig;
    }

    eliminarLista(etiquetas);

    return;
}

void generarFin(FILE** pAC)
{
    fprintf(*pAC, "mov AX, 4C00H\n");
    fprintf(*pAC, "int 21H\n");
    fprintf(*pAC, "END Start\n");

    return;
}

void crearEtiquetas(Lista** etiquetas)
{
    int i;
    int salto;

    for(i = 0; i < numTercetos; i ++)
    {
        if(esSalto(i))
        {
            //Se busca el terceto con la variable
            sscanf(ternas[i].arg1, "[%d]", &salto);
            insertarInicio(*etiquetas, salto);
        }
    }

    return;
}

int esLectura(int indice)
{
    if(strcmp(ternas[indice].op, "READ") == 0)
        return 1;

    return 0;    
}

int esEscritura(int indice)
{
    if(strcmp(ternas[indice].op, "WRITE") == 0)
        return 1;

    return 0;    
}

int esAsignacion(int indice)
{
    if(strcmp(ternas[indice].op, ":=") == 0)
        return 1;
    
    return 0;
}

int esOperacion(int indice)
{
    if(strcmp(ternas[indice].op, "+") == 0)
        return 1;
            
    if(strcmp(ternas[indice].op, "-") == 0)
        return 1;

    if(strcmp(ternas[indice].op, "*") == 0)
        return 1;

    if(strcmp(ternas[indice].op, "/") == 0)
        return 1;

    return 0;
}

int esComparacion(int indice)
{
    if(strcmp(ternas[indice].op, "CMP") == 0)
        return 1;

    return 0;    
}

int esSalto(int indice)
{
    if(strcmp(ternas[indice].op, "BGT") == 0)
        return 1;

    if(strcmp(ternas[indice].op, "BGE") == 0)
        return 1;

    if(strcmp(ternas[indice].op, "BLT") == 0)
        return 1;

    if(strcmp(ternas[indice].op, "BLE") == 0)
        return 1;

    if(strcmp(ternas[indice].op, "BEQ") == 0)
        return 1;

    if(strcmp(ternas[indice].op, "BNE") == 0)
        return 1;

    if(strcmp(ternas[indice].op, "BI") == 0)
        return 1;

    return 0;
}

int esSFP(int indice)
{
    if(strcmp(ternas[indice].op, "SFP") == 0)
        return 1;

    return 0;
}

void generarEtiqueta(FILE** pAC, int indice)
{
    fprintf(*pAC, "Etiq%d:\n\n", indice);

    return;
}

void generarLectura(FILE** pAC, int indice)
{
    int i;
    int indArg1;
    char var[MAX_LONG_STR];
    char tipoDato[MAX_LONG_TD];

    //Se busca el terceto con la variable
    sscanf(ternas[indice].arg1, "[%d]", &indArg1);

    //Se accede a la variable
    strcpy(var, ternas[indArg1].op);
    formatearCadena(var);

    //Se busca la variable
    for(i = 0; i < numLineas; i ++)
    {   
        if(strcmp(lineas[i].nombre, var) == 0)
        {
            //Se guarda su tipo de dato
            strcpy(tipoDato,  lineas[i].tipoDato);
            break;
        }
    }
    
    if(strcmp(tipoDato, "CTE_STRING") == 0 || strcmp(tipoDato, "VAR_STRING") == 0)
        fprintf(*pAC, "\tgetString _%s\n", var);
    else
        fprintf(*pAC, "\tGetFloat _%s\n", var);

    fprintf(*pAC, "\tnewLine\n\n");

    return;
}

void generarEscritura(FILE** pAC, int indice)
{
    int i;
    int indArg1;
    char aux[MAX_LONG_STR];
    char var[MAX_LONG_STR];
    char tipoDato[MAX_LONG_TD];

    //Se busca el terceto con la variable
    sscanf(ternas[indice].arg1, "[%d]", &indArg1);

    //Se accede a la variable
    strcpy(var, ternas[indArg1].op);

    eliminarComillas(var);

    if(!strstr(var, "@aux") && strcmp(var, "ANTES_REORDER") != 0 && strcmp(var, "DESPUES_REORDER") != 0)
        formatearCadena(var);

    //Se busca la variable
    for(i = 0; i < numLineas; i ++)
    {   
        strcpy(aux, lineas[i].nombre);
        formatearCadena(aux);

        if(strcmp(aux, var) == 0 || strcmp(lineas[i].nombre, var) == 0)
        {
            //Se guarda su tipo de dato
            strcpy(tipoDato,  lineas[i].tipoDato);
            break;
        }
    }

    if(strcmp(tipoDato, "") == 0)
        strcpy(tipoDato, "VAR_INTEGER");

    if(strcmp(tipoDato, "CTE_STRING") == 0 || strcmp(tipoDato, "VAR_STRING") == 0)
        fprintf(*pAC, "\tdisplayString _%s\n", var);

    if(strcmp(tipoDato, "CTE_INTEGER") == 0 || strcmp(tipoDato, "VAR_INTEGER") == 0)
        fprintf(*pAC, "\tDisplayInteger _%s\n", var);

    if(strcmp(tipoDato, "CTE_FLOAT") == 0 || strcmp(tipoDato, "VAR_FLOAT") == 0)
        fprintf(*pAC, "\tDisplayFloat _%s, 2\n", var);
    
    fprintf(*pAC, "\tnewLine\n\n");

    return;
}

void generarAsignacion(FILE** pAC, int indice)
{

    int i;
    int indArg1, indArg2;
    int existe = 0;
    char var1[MAX_LONG_STR], var2[MAX_LONG_STR];

    //Se busca el terceto con la variable
    sscanf(ternas[indice].arg1, "[%d]", &indArg1);
    sscanf(ternas[indice].arg2, "[%d]", &indArg2);

    //Se accede a la variable
    strcpy(var1, ternas[indArg1].op);
    strcpy(var2, ternas[indArg2].op);

    //Se busca la variable de origen
    for(i = 0; i < numLineas; i ++)
    {   
        if(strcmp(lineas[i].nombre, var2) == 0)
        {
            //Si llego acá es porque es una variable o constante
            formatearNumero(var2);
            existe = 1;
            break;
        }
    }

    if(existe)
        fprintf(*pAC, "\tFLD _%s\n", var2);

    fprintf(*pAC, "\tFST _%s\n", var1);
    fprintf(*pAC, "\tFFREE\n\n");

    return;
}

void generarOperacion(FILE** pAC, int indice)
{

    int i;
    int indArg1, indArg2;
    int existe1 = 0, existe2 = 0;
    char var1[MAX_LONG_STR], var2[MAX_LONG_STR];

    //Se busca el terceto con la variable
    sscanf(ternas[indice].arg1, "[%d]", &indArg1);
    sscanf(ternas[indice].arg2, "[%d]", &indArg2);

    //Se accede a la variable
    strcpy(var1, ternas[indArg1].op);
    strcpy(var2, ternas[indArg2].op);

    //Se busca la variable de origen
    for(i = 0; i < numLineas; i ++)
    {   
        //Si llego acá es porque es una variable
        if(strcmp(lineas[i].nombre, var1) == 0)
        {
            formatearNumero(var1);
            existe1 = 1;
        }
        
        //Si llego acá es porque es una variable
        if(strcmp(lineas[i].nombre, var2) == 0)
        {
            formatearNumero(var2);
            existe2 = 1;
        }
    }

    if(existe1)
        fprintf(*pAC, "\tFLD _%s\n", var1);
    if(existe2)
        fprintf(*pAC, "\tFLD _%s\n", var2);

    if(indArg1 < indArg2 - 1)
        fprintf(*pAC, "\tFXCH \n");

    if(strcmp(ternas[indice].op, "+") == 0)
        fprintf(*pAC, "\tFADD\n");
            
    if(strcmp(ternas[indice].op, "-") == 0)
        fprintf(*pAC, "\tFSUB\n");

    if(strcmp(ternas[indice].op, "*") == 0)
        fprintf(*pAC, "\tFMUL\n");

    if(strcmp(ternas[indice].op, "/") == 0)
        fprintf(*pAC, "\tFDIV\n");

    fprintf(*pAC, "\tFFREE ST(1)\n\n");

    return;
}

void generarComparacion(FILE** pAC, int indice)
{
    //TODO: Revisar comparaciones, no funciona comparando expresiones complejas
    int i;
    int indArg1, indArg2;
    int existe1 = 1, existe2 = 1;
    char var1[MAX_LONG_STR], var2[MAX_LONG_STR];

    //Se busca el terceto con la variable
    sscanf(ternas[indice].arg1, "[%d]", &indArg1);
    sscanf(ternas[indice].arg2, "[%d]", &indArg2);

    //Se accede a la variable
    strcpy(var1, ternas[indArg1].op);
    strcpy(var2, ternas[indArg2].op);
    formatearNumero(var1);
    formatearNumero(var1);

    fprintf(*pAC, "\tFLD _%s\n", var1);
    fprintf(*pAC, "\tFLD _%s\n", var2);

    fprintf(*pAC, "\tFXCH \n");
    fprintf(*pAC, "\tFCOM \n");
    fprintf(*pAC, "\tFSTSW AX\n");
    fprintf(*pAC, "\tSAHF\n");
    fprintf(*pAC, "\tFFREE\n\n");

    return;
}

void generarSalto(FILE** pAC, int indice)
{
    int salto;

    //Se busca el terceto donde saltar
    sscanf(ternas[indice].arg1, "[%d]", &salto);

    if (strcmp(ternas[indice].op, "BGT") == 0)
        fprintf(*pAC, "\tJA Etiq%d\n\n", salto);

    if (strcmp(ternas[indice].op, "BGE") == 0)
        fprintf(*pAC, "\tJNB Etiq%d\n\n", salto);

    if (strcmp(ternas[indice].op, "BLT") == 0) 
        fprintf(*pAC, "\tJB Etiq%d\n\n", salto);
    
    if (strcmp(ternas[indice].op, "BLE") == 0) 
        fprintf(*pAC, "\tJNA Etiq%d\n\n", salto);
    
    if (strcmp(ternas[indice].op, "BEQ") == 0) 
        fprintf(*pAC, "\tJE Etiq%d\n\n", salto);
    
    if (strcmp(ternas[indice].op, "BNE") == 0) 
        fprintf(*pAC, "\tJNE Etiq%d\n\n", salto);

    if (strcmp(ternas[indice].op, "BI") == 0) 
        fprintf(*pAC, "\tJMP Etiq%d\n\n", salto);
    
    return;
}

void generarSFP(FILE** pAC, int indice)
{
    int i;
    char var1[MAX_LONG_STR];
    char linea[MAX_TAM_LINEA];

    //Se accede a la variable
    strcpy(var1, ternas[indice].op);

    //fprintf(*pAC, "\tFLD _%s\n", var1);

    for(i = 0; i < numLineas; i ++)
    {
        if(strcmp(lineas[i].nombre, var1) == 0)
            return;
    }

    strcpy(lineas[numLineas].nombre, var1);
    strcpy(lineas[numLineas].tipoDato, "CTE_INTEGER");
    strcpy(lineas[numLineas].valor, var1);
    lineas[numLineas].longitud = strlen(var1);

    numLineas ++;

    fclose(*pAC);

    *pAC = fopen("./Outputs/Final.asm", "r");
    FILE* temporal = fopen("temporal.asm", "w");

    if (!*pAC || !temporal) {
        perror("Error abriendo archivos");
        return;
    }

    bool dentroData = false;
    bool variableAgregada = false;
    char nombreVariable[MAX_LONG_STR];
    sprintf(nombreVariable, "_%s", var1); // prefijo "_" para nombre asm

    while (fgets(linea, sizeof(linea), *pAC)) {
        fputs(linea, temporal);

        // Detectar la sección .DATA
        if (strstr(linea, ".DATA"))
            dentroData = true;

        // Si estamos dentro de .DATA y no hemos agregado aún la variable
        else if (dentroData && !variableAgregada && linea[0] == '\n') {
            fprintf(temporal, "\t%s\tdd\t%.d\n", nombreVariable, atoi(var1));
            variableAgregada = true;
        }
    }

    fclose(*pAC);
    fclose(temporal);

    remove("./Outputs/Final.asm");
    rename("temporal.asm", "./Outputs/Final.asm");

    *pAC = fopen("./Outputs/Final.asm", "a+t");

    return;
}

void formatearCadena(char *cadena)
{
    //Se reemplazan los caracteres especiales por guiones bajos
    while(*cadena)
    {
        if (!esLetra(*cadena) && !esNumero(*cadena))
            *cadena = '_';

        cadena++;
    }

    return;
}

void formatearNumero(char *numero)
{
    //Si es un numero negativo
    if(*numero == '-')
        *numero = '@';

    //Si es un float
    while(*numero)
    {
        if (*numero == '.')
            *numero = '_';

        numero++;
    }

    return;
}

void eliminarComillas(char *cadena)
{
    int len = strlen(cadena);

    if (len >= 2 && cadena[0] == '"' && cadena[len - 1] == '"')
    {
        memmove(cadena, cadena + 1, len - 2);
        cadena[len - 2] = '\0';
    }

    return;
}

int esLetra(char caracter)
{
    if(caracter >= 'A' && caracter <= 'Z')
        return 1;

    if(caracter >= 'a' && caracter <= 'z')
        return 1;
    
    return 0;
}

int esNumero(char caracter)
{
    if(caracter >= '0' && caracter <= '9')
        return 1;
    
    return 0;
}