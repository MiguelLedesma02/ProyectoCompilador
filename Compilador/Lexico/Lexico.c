#include "Lexico.h"

/*FUNCIONES DE VALIDACIÓN*/

int verificarLongId(char* tk)
{
    /* tk es el lexema */

    if(strlen(tk) <= MAX_LONG_ID)
        return 1;

    return 0;
}

int verificarLongString(char* tk)
{
    /* tk es el lexema */

    if(strlen(tk) <= MAX_LONG_STR)
        return 1;

    return 0;
}

int verificarRangoInt(char* tk)
{
    /* tk es el lexema */

    int valor = atoi(tk);

    if(valor >= MIN_VALOR_INT && valor <= MAX_VALOR_INT)
        return 1;
    
    return 0;
}

int verificarRangoFloat(char* tk)
{
    /* tk es el lexema */

    float valor = atof(tk);

    if(valor >= MIN_VALOR_FLOAT && valor <= MAX_VALOR_FLOAT)
        return 1;
    
    return 0;
}