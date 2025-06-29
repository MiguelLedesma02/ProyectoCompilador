#include "Tercetos.h"
#include "../Lista/Lista.h"
/*VARIABLES GLOBALES*/
int tercetosApilados[20];
int indiceTercetoApiladoActual = 0;

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

// int crearTerceto(char operador[], char op1[], char op2[]) {
//     if (indiceTerceto >= MAX_TERCETOS) {
//         printf("Error: Se ha excedido el límite de tercetos\n");
//         exit(EXIT_FAILURE);
//     }

//     strcpy(tercetos[indiceTerceto].operador, operador);
//     strcpy(tercetos[indiceTerceto].operando1, op1);
//     strcpy(tercetos[indiceTerceto].operando2, op2);


//     return indiceTerceto++;
// }

void modificarTerceto_etiquetaCond(char etiqueta[], int indice){
    char condInversa[50];
    if(strcmp(etiqueta, "BEQ") == 0){strcpy(condInversa, "BNE");}
    if(strcmp(etiqueta, "BNE") == 0){strcpy(condInversa, "BEQ");}
    if(strcmp(etiqueta, "BLE") == 0){strcpy(condInversa, "BGT");}
    if(strcmp(etiqueta, "BLT") == 0){strcpy(condInversa, "BGE");}
    if(strcmp(etiqueta, "BGE") == 0){strcpy(condInversa, "BLT");}
    if(strcmp(etiqueta, "BGT") == 0){strcpy(condInversa, "BLE");}

    strcpy(tercetos[indice].operador, condInversa);
}

void modificarTerceto_saltoCondicional(int indice){
    char indActual[50];
    sprintf(indActual, "[%d]", indiceTerceto);
    strcpy(tercetos[indice].operando1, indActual);
}

void apilarTercetos(int t){
    indiceTercetoApiladoActual++;
    tercetosApilados[indiceTercetoApiladoActual] = t;
}

int desapilarTercetos(){
    int res;
    if(indiceTercetoApiladoActual == 0){
        res = -1;
    }
    else{
        res = tercetosApilados[indiceTercetoApiladoActual];
        indiceTercetoApiladoActual--;
    }
    
    return res;
}

void generar_assembler(tLista* listaSimbolos){
    FILE *archivo;
    archivo = fopen("final.asm", "w+");

    if (!archivo) {
        printf("Error al abrir el archivo.");
        return;
    }

    imprimirEncabezadoAss(archivo);
    fprintf(archivo, ".DATA\n");
    imprimirDataAsm(listaSimbolos, archivo);

    generarDataAsm(archivo, listaSimbolos);

    fprintf(archivo, ".CODE\n");
    fprintf(archivo, "START:\n");
    fprintf(archivo, "mov AX, DGROUP    ; Inicializa el segmento de datos\n");
    fprintf(archivo, "mov DS, AX\n");
    fprintf(archivo, "mov ES, AX\n\n");
    // escribir una funcion que vaya leyecndo todos los tercetos 
	generarCodigoDesdeTercetos(archivo);

    fprintf(archivo, ".MOV EAX, 4C00h\n");
    fprintf(archivo, "INT 21h\n");
    fprintf(archivo, "END;\n");

    fclose(archivo);
}


void imprimirEncabezadoAss(FILE* archivo){
	fprintf(archivo, "include macros2.asm\n");
    fprintf(archivo, "include numbers.asm\n");
    fprintf(archivo, ".MODEL LARGE\n");
    fprintf(archivo, ".386\n");
    fprintf(archivo, "stack 200h\n");
}

void imprimirTercetos()
{
    for (int i = 0; i < indiceTerceto; i++)
        fprintf(ptercetos, "[%d] (%s, %s, %s)\n", i, tercetos[i].operador, tercetos[i].operando1, tercetos[i].operando2);

    return;
}