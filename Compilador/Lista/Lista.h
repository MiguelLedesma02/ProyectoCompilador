#ifndef LISTA_H
#define LISTA_H

#include "../Utilitarios/Utilitarios.h"
#include <stdbool.h>

typedef struct NodoLista
{
    int dato;
    struct NodoLista* sig;
} NodoLista;

typedef struct
{
    NodoLista* cabeza;
} Lista;

//FUNCIONES DE LISTA
Lista* crearLista();
void insertarInicio(Lista* lista, int dato);
int buscarYEliminar(Lista* lista, int dato);
void eliminarLista(Lista*);

#endif