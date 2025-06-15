#include "Utilitarios.h"

/*FUNCIONES*/

void eliminarCaracter(char* str, char ch)
{
    /* str es la cadena */
    /* ch es el caracter */

    int i = 0;
    int j = 0;

    while (str[i])
    {
        if (str[i] != ch)
            str[j++] = str[i];

        i++;
    }

    str[j] = '\0';

    return;
}