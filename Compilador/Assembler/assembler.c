#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../Tercetos/Tercetos.h"

#define MAX_SYMBOLS 500

typedef struct {
    char nombre[50];
    char tipoDato[20];
    char valor[50];
    int longitud;
} Simbolo;

Simbolo simbolos[MAX_SYMBOLS];
int cantSimbolos = 0;

void cargarTablaSimbolos(const char* ruta) {
    FILE* pf = fopen(ruta, "r");
    if (!pf) {
        perror("No se pudo abrir la tabla de símbolos");
        exit(1);
    }

    while (!feof(pf) && cantSimbolos < MAX_SYMBOLS) {
        fscanf(pf, "%[^|]|%[^|]|%[^|]|%d\n",
               simbolos[cantSimbolos].nombre,
               simbolos[cantSimbolos].tipoDato,
               simbolos[cantSimbolos].valor,
               &simbolos[cantSimbolos].longitud);
        cantSimbolos++;
    }

    fclose(pf);
}

const char* obtenerValorSimbolo(const char* nombre) {
    for (int i = 0; i < cantSimbolos; i++) {
        if (strcmp(simbolos[i].nombre, nombre) == 0)
            return simbolos[i].valor;
    }
    return nombre;
}

int esTerceto(const char* op) {
    return op[0] == '[';
}

void escribirAssembler(const char* ruta) {
    FILE* out = fopen(ruta, "wt");
    if (!out) {
        perror("No se pudo crear el archivo ASM");
        exit(1);
    }

    fprintf(out, "section .data\n");

    // Declaración de constantes y variables
    for (int i = 0; i < cantSimbolos; i++) {
        if (strcmp(simbolos[i].tipoDato, "CTE_INTEGER") == 0)
            fprintf(out, "%s dd %s\n", simbolos[i].nombre, simbolos[i].valor);
        else if (strcmp(simbolos[i].tipoDato, "CTE_FLOAT") == 0)
            fprintf(out, "%s dd %s\n", simbolos[i].nombre, simbolos[i].valor);
        else if (strcmp(simbolos[i].tipoDato, "CTE_STRING") == 0)
            fprintf(out, "%s db \"%s\", 0\n", simbolos[i].nombre, simbolos[i].valor);
    }

    // Declaración de temporales
    for (int i = 0; i < indiceTerceto; i++) {
        fprintf(out, "aux%d dd 0\n", i);
    }

    fprintf(out, "\nsection .text\n");
    fprintf(out, "global _start\n\n");
    fprintf(out, "_start:\n");

    // Cuerpo principal
    for (int i = 0; i < indiceTerceto; i++) {
        Terceto t = tercetos[i];
        char* op = t.operador;
        char* arg1 = t.operando1;
        char* arg2 = t.operando2;

        if (strcmp(op, ":=") == 0) {
            // Asignación: auxX := valor
            const char* fuente = esTerceto(arg2) ? "aux" : "";
            fprintf(out, "\tMOV EAX, %s%s\n", fuente, esTerceto(arg2) ? arg2 + 1 : obtenerValorSimbolo(arg2));
            const char* destino = esTerceto(arg1) ? "aux" : "";
            fprintf(out, "\tMOV %s%s, EAX\n", destino, esTerceto(arg1) ? arg1 + 1 : arg1);
        } else if (strcmp(op, "+") == 0 || strcmp(op, "-") == 0 || strcmp(op, "*") == 0 || strcmp(op, "/") == 0) {
            // Aritmética
            const char* reg = strcmp(op, "*") == 0 || strcmp(op, "/") == 0 ? "EAX" : "EBX";

            fprintf(out, "\tMOV EAX, %s%s\n", esTerceto(arg1) ? "aux" : "", esTerceto(arg1) ? arg1 + 1 : obtenerValorSimbolo(arg1));
            fprintf(out, "\tMOV %s, %s%s\n", reg, esTerceto(arg2) ? "aux" : "", esTerceto(arg2) ? arg2 + 1 : obtenerValorSimbolo(arg2));

            if (strcmp(op, "+") == 0)
                fprintf(out, "\tADD EAX, EBX\n");
            else if (strcmp(op, "-") == 0)
                fprintf(out, "\tSUB EAX, EBX\n");
            else if (strcmp(op, "*") == 0)
                fprintf(out, "\tIMUL EAX, EBX\n");
            else if (strcmp(op, "/") == 0) {
                fprintf(out, "\tCDQ\n");
                fprintf(out, "\tIDIV EBX\n");
            }

            fprintf(out, "\tMOV aux%d, EAX\n", i);
        } else if (strcmp(op, "CMP") == 0) {
            fprintf(out, "\tMOV EAX, %s%s\n", esTerceto(arg1) ? "aux" : "", esTerceto(arg1) ? arg1 + 1 : obtenerValorSimbolo(arg1));
            fprintf(out, "\tCMP EAX, %s%s\n", esTerceto(arg2) ? "aux" : "", esTerceto(arg2) ? arg2 + 1 : obtenerValorSimbolo(arg2));
        } else if (strncmp(op, "B", 1) == 0) {
            // Saltos condicionales
            fprintf(out, "\t%s etiqueta%s\n", op, arg1 + 1);
        } else if (strcmp(op, "BI") == 0) {
            fprintf(out, "\tJMP etiqueta%s\n", arg1 + 1);
        } else if (strcmp(op, "READ") == 0 || strcmp(op, "WRITE") == 0) {
            fprintf(out, "\t; %s %s (no implementado en ASM puro)\n", op, arg1);
        }

        // Etiqueta de línea
        fprintf(out, "etiqueta%d:\n", i + 1);
    }

    fprintf(out, "\tMOV EAX, 1\n\tMOV EBX, 0\n\tINT 0x80\n"); // Fin del programa
    fclose(out);
}
