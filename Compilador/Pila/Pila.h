#ifndef PILA_H
#define PILA_H

#include "../Utilitarios/Utilitarios.h"
#include <stdbool.h>

/*ESTRUCTURAS*/
typedef struct Nodo
{
    int dato;
    struct Nodo* siguiente;
} Nodo;

typedef struct
{
    Nodo* tope;
} Pila;

/*FUNCIONES DE PILA*/
Pila* crearPila();
int pilaVacia(Pila* pila);
void apilar(Pila* pila, int elemento);
int desapilar(Pila* pila);
int verTope(Pila* pila);
void destruirPila(Pila* pila);
void mostrarPila(Pila* pila, void (*mostrar_dato)(void *));

#endif