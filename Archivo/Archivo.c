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

int agregarTablaSimbolos (char* tk, int id)
{
    /* tk es el lexema */
    /* var se usa como boolean. Si es 1 es un campo ID, si no es un campo CONST */

    FILE *ts;
    entrada_ts entrada;

    if(abrirArchivo(&ts, "symbol_table.txt", "a+t") == 1)
        return 1;

    /*Si ya se encuentra el token, me voy*/
    if(buscarTokenEnArchivo(ts, tk) == 1)
    {
        fclose(ts);

        return 0;
    }

    strcpy(entrada.nombre, tk);
    entrada.longitud = strlen(tk);
    strcpy(entrada.tipoDato, "-"); //En este punto no se puede saber

    /*Si es ID, en valor no se pone nada, si es CONST, se pone el lexema*/
    if(id == 1)
        strcpy(entrada.valor, "-");
    else
        strcpy(entrada.valor, tk);

    fprintf(ts, "%s|%s|%d|%s\n", entrada.nombre, entrada.tipoDato, entrada.longitud, entrada.valor);

    fclose(ts);

    return 0;
}

int buscarTokenEnArchivo(FILE* pf, char* tk)
{
    /*Si ya está escrito el token retorna 0, si no retorna 1.*/
    /* *pf es el puntero al archivo */
    /* tk es el lexema */

    char linea[sizeof(entrada_ts)];

    rewind(pf);

    while (fscanf(pf, "%s", linea) != EOF)
    {

        char* campo = strtok(linea, "|");

        if (campo != NULL && strcmp(campo, tk) == 0)
            return 1;

    }

    return 0;
}