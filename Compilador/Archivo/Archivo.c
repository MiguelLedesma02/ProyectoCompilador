#include "Archivo.h"

/*FUNCIONES DE ARCHIVO*/

int abrirArchivo(FILE** pf, char* nombreArchivo, char* modo)
{
    /* *pf es el puntero al archivo */
    /* tk es el lexema */

    *pf = fopen(nombreArchivo, modo);

    if (*pf == NULL)
    {
        printf("No se pudo abrir el archivo %s\n",nombreArchivo);
        exit(1);
    }

    return 0;
}

int buscarToken(FILE* pf, char* tk)
{
    /*Si ya está escrito el token retorna 0, si no retorna 1.*/
    
    /* *pf es el puntero al archivo */
    /* tk es el lexema */

    int tam = MAX_LONG_STR + MAX_LONG_TD + MAX_LONG_STR + MAX_LONG_LONG;
    char* linea = malloc(tam);

    rewind(pf);

    while (fscanf(pf, "%s", linea) != EOF)
    {

        char* campo = strtok(linea, "|");

        if (campo != NULL && strcmp(campo, tk) == 0)
            return 1;

    }

    free(linea);

    return 0;
}

void agregarToken(FILE* pf, char* tk, char* tipo)
{
    /* *pf es el puntero al archivo */
    /* tk es el lexema */
    /* tipo es el tipo de dato de una CTE. Si es NULL, se asume que es un ID */

    entrada_ts entrada;

    rewind(pf);

    /*Si ya se encuentra el token, me voy*/
    if(buscarToken(pf, tk) == 1)
        return;

    if(tipo != NULL && strcmp(tipo, "CTE_STRING") == 0)
        eliminarCaracter(tk, '"');

    strcpy(entrada.nombre, tk);

    entrada.longitud = strlen(tk);

    /*No se puede determinar el tipo de dato ni el valor de una variable en el Análisis Léxico*/
    if(tipo != NULL)
    {
        strcpy(entrada.tipoDato, tipo); 
        strcpy(entrada.valor, tk);
    }
    else
    {
        strcpy(entrada.tipoDato, "-"); 
        strcpy(entrada.valor, "-");
    }

    fprintf(pf, "%-*s|%-*s|%-*s|%*d\n",
        MAX_LONG_STR, entrada.nombre,
        MAX_LONG_TD, entrada.tipoDato,
        MAX_LONG_STR, entrada.valor,
        MAX_LONG_LONG, entrada.longitud);

    return;
}