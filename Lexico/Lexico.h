#ifndef LEXICO_H
#define LEXICO_H

#include "../Utilitarios/Utilitarios.h"

/*CONSTANTES*/
#define MIN_VALOR_INT -32768
#define MAX_VALOR_INT 32767
#define MIN_VALOR_FLOAT -3.4028235e38
#define MAX_VALOR_FLOAT 3.4028235e38

/*FUNCIONES DE VALIDACIÓN*/
int verificarLongId(char*);
int verificarLongString(char*);
int verificarRangoInt(char* tk);
int verificarRangoFloat(char* tk);

#endif