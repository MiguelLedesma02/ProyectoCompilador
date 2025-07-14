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

entrada_ts buscarToken(FILE* pf, char* tk)
{
    /*Si ya está escrito el token retorna la entrada completa, si no retorna "NO ENCONTRADO".*/

    /* *pf es el puntero al archivo */
    /* tk es el lexema */

    int tam = MAX_LONG_STR + MAX_LONG_TD + MAX_LONG_STR + MAX_LONG_LONG;
    char *aux;
    char auxToken[MAX_LONG_STR];
    char* linea = malloc(tam);
    entrada_ts entrada;

    //Se coloca el puntero al inicio del archivo.
    rewind(pf);

    while(fgets(linea, tam, pf))
    {
        linea[strcspn(linea, "\n")] = '\0';

        aux = strtok(linea, "|");
        if(aux)
            strcpy(entrada.nombre, aux);

        aux = strtok(NULL, "|");
        if(aux)
            strcpy(entrada.tipoDato, aux);

        aux = strtok(NULL, "|");
        if(aux)
            strcpy(entrada.valor, aux);

        aux = strtok(NULL, "|");
        if(aux)
            entrada.longitud = atoi(aux);

        strcpy(auxToken, tk);
        ajustarCadena(auxToken);

        //printf("ARCHIVO: %s - CADENA: %s\n", entrada.nombre, auxToken);

        if(strcmp(entrada.nombre, auxToken) == 0)
            return entrada;
    }

    strcpy(entrada.nombre, "NO ENCONTRADO");

    return entrada;
}

void agregarToken(FILE* pf, char* tk, char* tipo)
{
    /* *pf es el puntero al archivo */
    /* tk es el lexema */
    /* tipo es el tipo de dato de una CTE. Si es NULL, se asume que es un ID */

    entrada_ts entrada;
    entrada_ts aux;

    rewind(pf);

    aux = buscarToken(pf, tk);

    /*Si ya se encuentra el token, me voy*/
    if(strcmp(aux.nombre, tk) == 0)
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

    fprintf(pf, "%s|%s|%s|%u\n", entrada.nombre, entrada.tipoDato, entrada.valor, entrada.longitud);

    return;
}

void modificarToken(FILE* pf, FILE* ptemp, entrada_ts nuevaEntrada)
{
    int tam = MAX_LONG_STR + MAX_LONG_TD + MAX_LONG_STR + MAX_LONG_LONG;
    char* aux;
    char* linea = malloc(tam);
    entrada_ts entrada;

    //Se coloca el puntero al inicio del archivo.
    rewind(pf);

    while(fgets(linea, tam, pf))
    {
        char* lineaAux = malloc(tam);
        strcpy(lineaAux, linea);

        sscanf(linea, "%[^|]|%[^|]|%[^|]|%u",
               entrada.nombre,
               entrada.tipoDato,
               entrada.valor,
               &entrada.longitud);

        if(strcmp(entrada.nombre, nuevaEntrada.nombre) == 0)
            fprintf(ptemp, "%s|%s|%s|%u\n",
                nuevaEntrada.nombre,
                nuevaEntrada.tipoDato,
                nuevaEntrada.valor,
                nuevaEntrada.longitud);
        else
            fputs(lineaAux, ptemp);

        free(lineaAux);
    }

    free(linea);

    return;
}

char* getTipo(FILE *pf, char* tk, char* td)
{
    int tam = MAX_LONG_STR + MAX_LONG_TD + MAX_LONG_STR + MAX_LONG_LONG;
    char* linea = malloc(tam);
    entrada_ts entrada;

    strcpy(entrada.tipoDato, "NULL");

    //Se coloca el puntero al inicio del archivo.
    rewind(pf);

    while(fgets(linea, tam, pf))
    {
        char* lineaAux = malloc(tam);
        strcpy(lineaAux, linea);

        sscanf(linea, "%[^|]|%[^|]|%[^|]|%u",
               entrada.nombre,
               entrada.tipoDato,
               entrada.valor,
               &entrada.longitud);

        if(strcmp(entrada.nombre, tk) == 0)
        {
            free(lineaAux);
            break;
        }

        free(lineaAux);
    }

    strcpy(td, entrada.tipoDato);
    memmove(td, td + 4, strlen(td) - 3);
    free(linea);

    return td;
}

void ajustarCadena(char *cadena)
{
    int len = strlen(cadena);

    if (len >= 2 && cadena[0] == '"' && cadena[len - 1] == '"')
    {
        memmove(cadena, cadena + 1, len - 2);
        cadena[len - 2] = '\0';
    }

    return;
}