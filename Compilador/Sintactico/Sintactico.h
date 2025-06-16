#ifndef SINTACTICO_H
#define SINTACTICO_H

#include "../Utilitarios/Utilitarios.h"
#include "../Tercetos/Tercetos.h"
#include "../Pila/Pila.h"

/*VARIABLES GLOBALES*/
extern Pila* Epila; //Expresion
extern Pila* Tpila; //Termino
extern Pila* Bpila; //Bloque

extern int indiceTerceto;

/*INDICES*/

int Strind; //String

int Aind; //Asignación
int Eind; //Expresión
int Tind; //Término
int Find; //Factor

int Cind; //Condición

/*FUNCIONES SEMÁNTICAS*/
int generarCondicion(char* condicion);
void negarCondicion(int indice);

#endif