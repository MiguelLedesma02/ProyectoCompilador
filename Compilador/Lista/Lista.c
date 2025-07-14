#include "Lista.h"

Lista* crearLista()
{
    Lista* lista = (Lista*)malloc(sizeof(Lista));

    if (!lista)
    {
        fprintf(stderr, "Error al reservar memoria para la lista.\n");
        exit(EXIT_FAILURE);
    }

    lista->cabeza = NULL;

    return lista;
}

void insertarInicio(Lista* lista, int dato)
{
    NodoLista* nuevo = malloc(sizeof(NodoLista));
    if (!nuevo)
    {
        fprintf(stderr, "Error al reservar memoria para el nodo.\n");
        exit(EXIT_FAILURE);
    }

    nuevo->dato = dato;
    nuevo->sig = lista->cabeza;
    lista->cabeza = nuevo;

    return;
}

int buscarYEliminar(Lista* lista, int dato)
{
    NodoLista* actual = lista->cabeza;
    NodoLista* anterior = NULL;

    while (actual != NULL)
    {
        if (actual->dato == dato)
        {
            if (anterior == NULL)
                lista->cabeza = actual->sig;
            else 
                anterior->sig = actual->sig;
    
            free(actual);
            return 1;
        }

        anterior = actual;
        actual = actual->sig;
    }

    return 0;
}

void eliminarLista(Lista* lista)
{
    NodoLista* actual = lista->cabeza;

    while (actual != NULL)
    {
        NodoLista* temp = actual;
        actual = actual->sig;
        free(temp);
    }

    return;
}