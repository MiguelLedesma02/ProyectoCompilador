#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "Tercetos.h"
#include "Lista.h"
#include "assembler.h"

void generarDataAsm(FILE* f, tLista* listaSimbolos) {
    tNodo* nodoActual = *listaSimbolos;
    
    // Variables declaradas por el usuario
    while (nodoActual != NULL) {
        
        // Variables numéricas (enteros y flotantes)
        if (strncmp(nodoActual->nombre , "_", 1) == 0 && nodoActual->longitud  == 0) {
            // Es una constante numérica
            fprintf(f, "%-20s dd %s\n", nodoActual->nombre, nodoActual->valor);
        } 
        // Strings
        else if (nodoActual->longitud > 0) {
            fprintf(f, "%-20s db \"%s\", 0\n", nodoActual->nombre, nodoActual->valor);
        }
        // Variables no inicializadas
        else {
            fprintf(f, "%-20s dd ?\n", nodoActual->nombre);
        }
        
        nodoActual = nodoActual->sig;
    }
    
    // Variables temporales para resultados intermedios
    for (int i = 0; i < cant_tercetos; i++) {
        if (strcmp(tercetos[i].operador, "+") == 0 || strcmp(tercetos[i].operador, "-") == 0 ||
            strcmp(tercetos[i].operador, "*") == 0 || strcmp(tercetos[i].operador, "/") == 0 ||
            strcmp(tercetos[i].operador, ":=") == 0) {
            fprintf(f, "_temp%-10d dd ?\n", i);
        }
    }
    
    // Strings para WRITE
    for (int i = 0; i < cant_tercetos; i++) {
        if (strcmp(tercetos[i].operador, "WRITE") == 0 && 
            tercetos[i].operando1[0] == '"') {
            fprintf(f, "_str%-10d db %s, 0\n", i, tercetos[i].operando1);
        }
    }
}




void generarCodigoDesdeTercetos(FILE* f) {
    char tempVar1[50], tempVar2[50], tempResult[50];
    int tempCounter = 0;
    
    for (int i = 0; i < cant_tercetos; i++) {
        Terceto t = tercetos[i];
        
        // Comentario con el terceto original
        fprintf(f, "; [%d] %s, %s, %s\n", i, t.operador, t.operando1, t.operando2);
        
        // Procesamiento según el operador
        if (strcmp(t.operador, ":=") == 0) {
            generarAsignacion(f, &t, i);
        } 
        else if (strcmp(t.operador, "+") == 0 || strcmp(t.operador, "-") == 0 ||
                 strcmp(t.operador, "*") == 0 || strcmp(t.operador, "/") == 0) {
            generarOperacionAritmetica(f, &t, i);
        }
        else if (strcmp(t.operador, "CMP") == 0) {
            generarComparacion(f, &t);
        }
        else if (strcmp(t.operador, "BLE") == 0 || strcmp(t.operador, "BGT") == 0 ||
                 strcmp(t.operador, "BLT") == 0 || strcmp(t.operador, "BGE") == 0 ||
                 strcmp(t.operador, "BNE") == 0 || strcmp(t.operador, "BEQ") == 0) {
            generarSaltoCondicional(f, &t, i);
        }
        else if (strcmp(t.operador, "BI") == 0) {
            generarSaltoIncondicional(f, &t);
        }
        else if (strcmp(t.operador, "WRITE") == 0) {
            generarWrite(f, &t);
        }
        else if (strcmp(t.operador, "READ") == 0) {
            generarRead(f, &t);
        }
        else if (strcmp(t.operador, "WHILE") == 0) {
            generarWhile(f, &t, i);
        }
        else if (strcmp(t.operador, "IF") == 0) {
            generarIf(f, &t, i);
        }
        else if (strcmp(t.operador, "ELSE") == 0) {
            generarElse(f, &t, i);
        }
        
        fprintf(f, "\n");
    }
}

void generarAsignacion(FILE* f, Terceto* t, int indiceTerceto) {
    // Si es asignación de constante o variable
    if (t->operando1[0] == '[') {
        // Es una referencia a otro terceto
        int ref = atoi(t->operando1 + 1);
        fprintf(f, "MOV EAX, _temp%d\n", ref);
        fprintf(f, "MOV %s, EAX\n", t->operando2);
    } 
    else if (strncmp(t->operando1, "_", 1) == 0) {
        // Es una constante
        fprintf(f, "MOV %s, %s\n", t->operando2, t->operando1);
    }
    else {
        // Es una variable normal o temporal
        fprintf(f, "MOV EAX, %s\n", t->operando1);
        fprintf(f, "MOV %s, EAX\n", t->operando2);
    }
}


void generarOperacionAritmetica(FILE* f, Terceto* t, int indiceTerceto) {
    // Cargar primer operando
    if (t->operando1[0] == '[') {
        int ref = atoi(t->operando1 + 1);
        fprintf(f, "MOV EAX, _temp%d\n", ref);
    } else {
        fprintf(f, "MOV EAX, %s\n", t->operando1);
    }
    
    // Cargar segundo operando
    if (t->operando2[0] == '[') {
        int ref = atoi(t->operando2 + 1);
        fprintf(f, "MOV EBX, _temp%d\n", ref);
    } else {
        fprintf(f, "MOV EBX, %s\n", t->operando2);
    }
    
    // Realizar operación
    if (strcmp(t->operador, "+") == 0) {
        fprintf(f, "ADD EAX, EBX\n");
    } 
    else if (strcmp(t->operador, "-") == 0) {
        fprintf(f, "SUB EAX, EBX\n");
    }
    else if (strcmp(t->operador, "*") == 0) {
        fprintf(f, "IMUL EAX, EBX\n");
    }
    else if (strcmp(t->operador, "/") == 0) {
        fprintf(f, "XOR EDX, EDX\n");  // Limpiar EDX para división
        fprintf(f, "IDIV EBX\n");
    }
    
    // Guardar resultado en temporal
    fprintf(f, "MOV _temp%d, EAX\n", indiceTerceto);
}


void generarComparacion(FILE* f, Terceto* t) {
    // Cargar primer operando
    if (t->operando1[0] == '[') {
        int ref = atoi(t->operando1 + 1);
        fprintf(f, "MOV EAX, _temp%d\n", ref);
    } else {
        fprintf(f, "MOV EAX, %s\n", t->operando1);
    }
    
    // Cargar segundo operando
    if (t->operando2[0] == '[') {
        int ref = atoi(t->operando2 + 1);
        fprintf(f, "MOV EBX, _temp%d\n", ref);
    } else {
        fprintf(f, "MOV EBX, %s\n", t->operando2);
    }
    
    // Comparar
    fprintf(f, "CMP EAX, EBX\n");
}

void generarSaltoCondicional(FILE* f, Terceto* t, int indiceTerceto) {
    char* etiqueta = t->operando1[0] != '\0' ? t->operando1 : "fin";
    
    if (strcmp(t->operador, "BLE") == 0) {
        fprintf(f, "JG %s\n", etiqueta);
    }
    else if (strcmp(t->operador, "BGE") == 0) {
        fprintf(f, "JL %s\n", etiqueta);
    }
    else if (strcmp(t->operador, "BLT") == 0) {
        fprintf(f, "JGE %s\n", etiqueta);
    }
    else if (strcmp(t->operador, "BGT") == 0) {
        fprintf(f, "JLE %s\n", etiqueta);
    }
    else if (strcmp(t->operador, "BEQ") == 0) {
        fprintf(f, "JNE %s\n", etiqueta);
    }
    else if (strcmp(t->operador, "BNE") == 0) {
        fprintf(f, "JE %s\n", etiqueta);
    }
}

void generarSaltoIncondicional(FILE* f, Terceto* t) {
    fprintf(f, "JMP %s\n", t->operando1);
}

void generarWhile(FILE* f, Terceto* t, int indiceTerceto) {
    fprintf(f, "_while_%d:\n", indiceTerceto);
}

void generarIf(FILE* f, Terceto* t, int indiceTerceto) {
    fprintf(f, "; IF condition\n");
    // La condición ya fue generada por el CMP y el salto condicional
}

void generarElse(FILE* f, Terceto* t, int indiceTerceto) {
    fprintf(f, "_else_%d:\n", indiceTerceto);
}

void generarWrite(FILE* f, Terceto* t) {
    if (t->operando1[0] == '"') {
        // Es un string literal - necesitamos crear una variable para él
        char varName[50];
        sprintf(varName, "_str_%d", rand() % 1000);
        fprintf(f, "%s db %s, 0\n", varName, t->operando1);
        fprintf(f, "displayString %s\n", varName);
    } else {
        // Es una variable
        if (t->operando1[0] == '[') {
            int ref = atoi(t->operando1 + 1);
            fprintf(f, "displayInteger _temp%d\n", ref);
        } else {
            fprintf(f, "displayInteger %s\n", t->operando1);
        }
    }
}

void generarRead(FILE* f, Terceto* t) {
    fprintf(f, "getInteger %s\n", t->operando1);
}
