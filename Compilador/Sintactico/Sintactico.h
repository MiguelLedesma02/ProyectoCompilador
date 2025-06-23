#ifndef SINTACTICO_H
#define SINTACTICO_H

#include "../Utilitarios/Utilitarios.h"
#include "../Archivo/Archivo.h"
#include "../Tercetos/Tercetos.h"
#include "../Pila/Pila.h"

/*VARIABLES GLOBALES*/
#define MAX_VAR_EN_LINEA 15

extern Pila* Epila; //Expresion
extern Pila* Tpila; //Termino
extern Pila* ETDpila; //Expresion
extern Pila* TTDpila; //Termino
extern Pila* Bpila; //Bloque


/*
    Si en la pila de ETD o TTD pongo un 1 es un CTE_INTEGER.
    Si en la pila de ETD o TTD pongo un 2 es un CTE_FLOAT.
*/

extern int indiceTerceto;
extern int cantVarEnLinea;

//Esto limita a 15 la cantidad de variables que pueden declararse en una línea
char varEnLinea[MAX_VAR_EN_LINEA][MAX_LONG_ID];
char tipoDato[MAX_LONG_TD];

/*INDICES*/

int Strind; //String

int Aind; //Asignación
int Eind; //Expresión
int Tind; //Término
int Find; //Factor

int Cind; //Condición

char ETDind[MAX_LONG_TD]; //Tipo de Dato Expresión
char TTDind[MAX_LONG_TD]; //Tipo de Dato Término
char FTDind[MAX_LONG_TD]; //Tipo de Dato Factor

/*FUNCIONES SEMÁNTICAS*/
int setTipoDato(FILE *pf, FILE *ptemp, char* tipoDato);
int generarCondicion(char* condicion);
void negarCondicion(int indice);
void generarWhile();
void generarIf();
void generarInicioIfElse();
void generarFinIfElse();
void generarRead(char* id);
void generarWrite(char* str, int string);

extern int yyerror(char* descripcion);

#endif