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
extern Pila* Bpila; //Bloque

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

/*FUNCIONES SEMÁNTICAS*/
int setTipoDato(FILE *pf, FILE *ptemp, char* tipoDato);
int generarCondicion(char* condicion);
void negarCondicion(int indice);

#endif