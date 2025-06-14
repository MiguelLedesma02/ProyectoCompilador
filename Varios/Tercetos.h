#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "Lista.h"

#define MAX_TERCETOS 200

// Estructura para representar un terceto
typedef struct {
    char operador[50];
    char operando1[50];
    char operando2[50];
} Terceto;

// Arreglo para almacenar los tercetos
Terceto tercetos[MAX_TERCETOS];

int tercetosApilados[20];
int indiceTercetoApiladoActual = 0;

// Índice actual de terceto
int terceto_index = 0;
int cant_tercetos = 0;

void imprimirEncabezadoAss(FILE* archivo);

// Función para crear un terceto y retornar su índice
int crearTerceto(char operador[], char op1[], char op2[]) {
    if (terceto_index >= MAX_TERCETOS) {
        printf("Error: Se ha excedido el límite de tercetos\n");
        exit(EXIT_FAILURE);
    }

    strcpy(tercetos[terceto_index].operador, operador);
    strcpy(tercetos[terceto_index].operando1, op1);
    strcpy(tercetos[terceto_index].operando2, op2);

    cant_tercetos++;

    return terceto_index++;
}

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
    sprintf(indActual, "[%d]", terceto_index);
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

    fprintf(archivo, ".CODE\n");

    // escribir una funcion que vaya leyecndo todos los tercetos 
	
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
    FILE *archivo;
    archivo = fopen("Tercetos.txt", "w+");

    if (!archivo) {
        printf("Error al abrir el archivo.");
        return;
    }

    int i = 0;
    while (i < cant_tercetos) {
        fprintf(archivo, "[%d] (%s, %s, %s)\n", i, tercetos[i].operador, tercetos[i].operando1, tercetos[i].operando2);
        i++;
    }

    fclose(archivo);
}

