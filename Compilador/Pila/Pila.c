#include <stdio.h>
#include <stdlib.h>
#include "Pila.h"

/*FUNCIONES DE PILA*/
Pila* crearPila()
{
    Pila* pila = (Pila*)malloc(sizeof(Pila));
    pila->tope = NULL;

    return pila;
}

int pilaVacia(Pila* pila)
{
    if(pila->tope == NULL)
        return 0;

    return 1;
}

void apilar(Pila* pila, int elemento)
{
    Nodo* nuevo = (Nodo*)malloc(sizeof(Nodo));
    nuevo->dato = elemento;
    nuevo->siguiente = pila->tope;
    pila->tope = nuevo;

    return;
}

int desapilar(Pila* pila)
{
    Nodo* nodo = pila->tope;
    int dato = nodo->dato;
    pila->tope = nodo->siguiente;
    free(nodo);

    return dato;
}

int verTope(Pila* pila)
{
    return pila->tope->dato;
}

void destruirPila(Pila* pila)
{
    free(pila);

    return;
}

void mostrarPila(Pila* pila, void (*mostrar_dato)(void *))
{
    Nodo* actual = pila->tope;

    printf("Pila (tope -> fondo): ");
    while (actual != NULL)
    {
        printf("%d ", actual->dato);
        actual = actual->siguiente;
    }
    
    printf("\n");

    return;
}