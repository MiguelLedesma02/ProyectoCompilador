%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"


char *yytext;

/*CONSTANTES*/
#define MAX_LONG_ID 30
#define MAX_LONG_STR 50
#define MAX_LONG_TD 10
#define MIN_VALOR_INT -32768
#define MAX_VALOR_INT 32767
#define MIN_VALOR_FLOAT -3.4028235e38
#define MAX_VALOR_FLOAT 3.4028235e38

typedef struct
{
    char nombre[MAX_LONG_ID];
    char tipoDato[MAX_LONG_TD];
    char valor[MAX_LONG_STR];
    unsigned longitud;
} entrada_ts;

/*FUNCIONES*/
int agregarTablaSimbolos(char* tk, int id);
int abrirArchivo(FILE** pf, char* nombreArchivo, char* modo);
int buscarTokenEnArchivo(FILE* pf, char* tk);

int verificarLongId(char*);
int verificarLongString(char*);
int verificarRangoInt(char* tk);
int verificarRangoFloat(char* tk);

int yyerror(void);

%}

%option noyywrap
%option yylineno

/*Conjuntos*/

DIGITO            [0-9]
LETRA             [a-zA-Z]

/*Tipos de datos*/

INT               "int"
FLOAT             "float"
STRING            "string"

/*Conectores lógicos*/

AND               "AND"
OR                "OR"
NOT               "NOT"

/*Palabras reservadas*/

IF                "if"
ELSE              "else"
WHILE             "while"
INIT              "init"
READ              "read"
WRITE             "write"
REORDER           "reorder"
SUMFIRSTPRIMES    "sumFirstPrimes"
ASIGCOMP          "AsigComp"
CONT              "!cont"
SET               "SET" 
SWITCH            "SWITCH"
CASE              "CASE"
ELSECASE          "ELSECASE"
ENDSETCASE        "ENDSETCASE"
FIB               "FIB"          

/*Tokens básicos*/

ID     {LETRA}({LETRA}|{DIGITO}|"_")*
CONST_INT         {DIGITO}+
CONST_FLOAT       (({DIGITO}+("."{DIGITO}*)?)|("."{DIGITO}+))([eE][-+]?{DIGITO}+)?
CONST_STRING      \"[^\n"]*\"
OP_ASIG           ":="
COMENTARIO        "#+"([^\n]|\n)*"+#"
EQ                "="

/*Operadores aritméticos*/

OP_SUMA           "+"
OP_RESTA          "-"
OP_PRODUCTO       "*"
OP_COCIENTE       "/"

/*Operadores lógicos*/

OP_MAYOR          ">"
OP_MAYOR_IGUAL    ">="
OP_MENOR          "<"
OP_MENOR_IGUAL    "<="
OP_IGUAL          "=="
OP_DISTINTO       "!="

/*Bloques*/

PAR_AP            "("
PAR_CL            ")"
COR_AP            "["
COR_CL            "]"
LLA_AP            "{"
LLA_CL            "}"

/*Puntuación*/

COMA              ","
PUNTO_Y_COMA      ";"
DOS_PUNTOS        ":"
DOBLE_DOS_PUNTOS  "::"

%%

{INT}             { printf("INT: %s\n", yytext); return INT;}
{FLOAT}           { printf("FLOAT: %s\n", yytext); return FLOAT;}
{STRING}          { printf("STRING: %s\n", yytext); return STRING;}

{AND}             { printf("AND: %s\n", yytext); return AND;}
{OR}              { printf("OR: %s\n", yytext); return OR;}
{NOT}             { printf("NOT: %s\n", yytext); return NOT;}

{IF}              { printf("IF: %s\n", yytext); return IF;}
{ELSE}            { printf("ELSE: %s\n", yytext); return ELSE;}
{WHILE}           { printf("WHILE: %s\n", yytext); return WHILE;}
{INIT}            { printf("INIT: %s\n", yytext); return INIT;}
{READ}            { printf("READ: %s\n", yytext); return READ;}
{WRITE}           { printf("WRITE: %s\n", yytext); return WRITE;}
{REORDER}         { printf("REORDER: %s\n", yytext); return REORDER;}
{SUMFIRSTPRIMES}  { printf("SUMFIRSTPRIMES: %s\n", yytext); return SUMFIRSTPRIMES;}
{ASIGCOMP}        { printf("ASIGCOMP: %s\n", yytext); return ASIGCOMP;}
{CONT}            { printf("CONT: %s\n", yytext); return CONT;}
{SET}             { printf("SET: %s\n", yytext); return SET;}
{SWITCH}          { printf("SWITCH: %s\n", yytext); return SWITCH;}
{CASE}            { printf("CASE: %s\n", yytext); return CASE;}
{ELSECASE}        { printf("ELSECASE: %s\n", yytext); return ELSECASE;}
{ENDSETCASE}      { printf("ENDSETCASE: %s\n", yytext); return ENDSETCASE;}
{FIB}             { printf("FIB: %s\n", yytext); return FIB;}

{ID}   { if(verificarLongId(yytext) == 0){ printf("IDENTIFICADOR: %s\n", yytext);agregarTablaSimbolos(yytext, 1); return ID;} }
{CONST_INT}       { if(verificarRangoInt(yytext) == 0){ printf("CONST_INT: %s\n", yytext);
agregarTablaSimbolos(yytext, 0); return CONST_INT;} }
{CONST_FLOAT}     { if(verificarRangoFloat(yytext) == 0){ printf("CONST_FLOAT: %s\n", yytext); 
agregarTablaSimbolos(yytext, 0); return CONST_FLOAT;} }
{CONST_STRING}    { if(verificarLongString(yytext) == 0){ printf("CONST_STRING: %s\n", yytext);
agregarTablaSimbolos(yytext, 0); return CONST_STRING;} }  

{OP_ASIG}         { printf("OP_ASIG: %s\n", yytext); return OP_ASIG;}
{EQ}              { printf("EQ: %s\n", yytext); return EQ;}

{OP_SUMA}         { printf("OP_SUMA: %s\n", yytext); return OP_SUMA;}
{OP_RESTA}        { printf("OP_RESTA: %s\n", yytext); return OP_RESTA;}
{OP_PRODUCTO}     { printf("OP_PRODUCTO: %s\n", yytext); return OP_PRODUCTO;}
{OP_COCIENTE}     { printf("OP_COCIENTE: %s\n", yytext); return OP_COCIENTE;}

{OP_MAYOR}        { printf("OP_MAYOR: %s\n", yytext); return OP_MAYOR;}
{OP_MAYOR_IGUAL}  { printf("OP_MAYOR_IGUAL: %s\n", yytext); return OP_MAYOR_IGUAL;}
{OP_MENOR}        { printf("OP_MENOR: %s\n", yytext); return OP_MENOR;}
{OP_MENOR_IGUAL}  { printf("OP_MENOR_IGUAL: %s\n", yytext); return OP_MENOR_IGUAL;}
{OP_IGUAL}        { printf("OP_IGUAL: %s\n", yytext); return OP_IGUAL;}
{OP_DISTINTO}     { printf("OP_DISTINTO: %s\n", yytext); return OP_DISTINTO;}

{PAR_AP}          { printf("PAR_AP: %s\n", yytext); return PAR_AP;}
{PAR_CL}          { printf("PAR_CL: %s\n", yytext); return PAR_CL;}
{COR_AP}          { printf("COR_AP: %s\n", yytext); return COR_AP;}
{COR_CL}          { printf("COR_CL: %s\n", yytext); return COR_CL;}
{LLA_AP}          { printf("LLA_AP: %s\n", yytext); return LLA_AP;}
{LLA_CL}          { printf("LLA_CL: %s\n", yytext); return LLA_CL;}

{COMA}            { printf("COMA: %s\n", yytext); return COMA;}
{PUNTO_Y_COMA}    { printf("PUNTO_Y_COMA: %s\n", yytext); return PUNTO_Y_COMA;}
{DOS_PUNTOS}      { printf("DOS_PUNTOS: %s\n", yytext); return DOS_PUNTOS;}
{DOBLE_DOS_PUNTOS} { printf("DOBLE_DOS_PUNTOS: %s\n", yytext); return DOBLE_DOS_PUNTOS;}

{COMENTARIO}
" "             		
"\n"      		
"\t"
"\n\t"
"\r\n"
.                 { printf("\nERROR LEXICO: Caracter no reconocido: %s\n", yytext); yyerror(); }

%%

/*
int main (int argc, char* argv[])
{
    
    if(abrirArchivo(&yyin, argv[1], "rt") == 1)
        return 1;

    printf("\n\n");
    yylex();
    printf("\n\n");

    fclose(yyin);

    return 0;
}
*/

/*Tabla de Símbolos*/
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

/*Funciones de archivo*/
int abrirArchivo(FILE** pf, char* nombreArchivo, char* modo)
{
    /* *pf es el puntero al archivo */
    /* tk es el lexema */

    *pf = fopen(nombreArchivo, modo);

    if (*pf == NULL) {
        printf("No se pudo abrir el archivo %s\n",nombreArchivo);
        exit(1);
    }

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

/*Funciones de validación*/

int verificarLongId(char* tk)
{
    /* tk es el lexema */

    if(strlen(tk) <= MAX_LONG_ID)
        return 0;
    
    printf("\nERROR LEXICO: Longitud de identificador muy grande: %s\n", yytext);

    return yyerror();;
}

int verificarLongString(char* tk)
{
    /* tk es el lexema */

    if(strlen(tk) <= MAX_LONG_STR)
        return 0;

    printf("\nERROR LEXICO: Longitud de string muy grande: %s\n", yytext);

    return yyerror();
}

int verificarRangoInt(char* tk)
{
    /* tk es el lexema */

    int valor = atoi(tk);

    if(valor >= MIN_VALOR_INT && valor <= MAX_VALOR_INT)
        return 0;

    printf("\nERROR LEXICO: Entero fuera de rango: %s\n", yytext);
    
    return yyerror();
}

int verificarRangoFloat(char* tk)
{
    /* tk es el lexema */

    int valor = atof(tk);

    if(valor >= MIN_VALOR_FLOAT && valor <= MAX_VALOR_FLOAT)
        return 0;

    printf("\nERROR LEXICO: Entero fuera de rango: %s\n", yytext);
    
    return yyerror();
}


int yyerror(void)
{
    printf("LINEA: %d\n", yylineno);
    exit(1);
}
