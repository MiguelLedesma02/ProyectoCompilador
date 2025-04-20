%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

FILE *yyin;
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
SET               "set" 
SWITCH            "switch"
CASE              "case"
ELSECASE          "elsecase"
ENDSETCASE        "endsetcase"
FIB               "fib"          

/*Tokens básicos*/

IDENTIFICADOR     {LETRA}({LETRA}|{DIGITO}|"_")*
CONST_INT         "-"?{DIGITO}+
CONST_FLOAT       "-"?{DIGITO}+"."{DIGITO}+([eE][-+]?{DIGITO}+)?
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

{INT}             { printf("INT: %s\n", yytext); }
{FLOAT}           { printf("FLOAT: %s\n", yytext); }
{STRING}          { printf("STRING: %s\n", yytext); }

{AND}             { printf("AND: %s\n", yytext); }
{OR}              { printf("OR: %s\n", yytext); }
{NOT}             { printf("NOT: %s\n", yytext); }

{IF}              { printf("IF: %s\n", yytext); }
{ELSE}            { printf("ELSE: %s\n", yytext); }
{WHILE}           { printf("WHILE: %s\n", yytext); }
{INIT}            { printf("INIT: %s\n", yytext); }
{READ}            { printf("READ: %s\n", yytext); }
{WRITE}           { printf("WRITE: %s\n", yytext); }
{REORDER}         { printf("REORDER: %s\n", yytext); }
{SUMFIRSTPRIMES}  { printf("SUMFIRSTPRIMES: %s\n", yytext); }
{ASIGCOMP}        { printf("ASIGCOMP: %s\n", yytext); }
{CONT}            { printf("CONT: %s\n", yytext); }
{SET}             { printf("SET: %s\n", yytext); }
{SWITCH}          { printf("SWITCH: %s\n", yytext); }
{CASE}            { printf("CASE: %s\n", yytext); }
{ELSECASE}        { printf("ELSECASE: %s\n", yytext); }
{ENDSETCASE}      { printf("ENDSETCASE: %s\n", yytext); }
{FIB}             { printf("FIB: %s\n", yytext); }

{IDENTIFICADOR}   { if(verificarLongId(yytext) == 0){ printf("IDENTIFICADOR: %s\n", yytext);agregarTablaSimbolos(yytext, 1); } }
{CONST_INT}       { if(verificarRangoInt(yytext) == 0){ printf("CONST_INT: %s\n", yytext);
agregarTablaSimbolos(yytext, 0); } }
{CONST_FLOAT}     { if(verificarRangoFloat(yytext) == 0){ printf("CONST_FLOAT: %s\n", yytext); 
agregarTablaSimbolos(yytext, 0); } }
{CONST_STRING}    { if(verificarLongString(yytext) == 0){ printf("CONST_STRING: %s\n", yytext);
agregarTablaSimbolos(yytext, 0); } }  

{OP_ASIG}         { printf("OP_ASIG: %s\n", yytext); }
{EQ}              { printf("EQ: %s\n", yytext); }

{OP_SUMA}         { printf("OP_SUMA: %s\n", yytext); }
{OP_RESTA}        { printf("OP_RESTA: %s\n", yytext); }
{OP_PRODUCTO}     { printf("OP_PRODUCTO: %s\n", yytext); }
{OP_COCIENTE}     { printf("OP_COCIENTE: %s\n", yytext); }

{OP_MAYOR}        { printf("OP_MAYOR: %s\n", yytext); }
{OP_MAYOR_IGUAL}  { printf("OP_MAYOR_IGUAL: %s\n", yytext); }
{OP_MENOR}        { printf("OP_MENOR: %s\n", yytext); }
{OP_MENOR_IGUAL}  { printf("OP_MENOR_IGUAL: %s\n", yytext); }
{OP_IGUAL}        { printf("OP_IGUAL: %s\n", yytext); }
{OP_DISTINTO}     { printf("OP_DISTINTO: %s\n", yytext); }

{PAR_AP}          { printf("PAR_AP: %s\n", yytext); }
{PAR_CL}          { printf("PAR_CL: %s\n", yytext); }
{COR_AP}          { printf("COR_AP: %s\n", yytext); }
{COR_CL}          { printf("COR_CL: %s\n", yytext); }
{LLA_AP}          { printf("LLA_AP: %s\n", yytext); }
{LLA_CL}          { printf("LLA_CL: %s\n", yytext); }

{COMA}            { printf("COMA: %s\n", yytext); }
{PUNTO_Y_COMA}    { printf("PUNTO_Y_COMA: %s\n", yytext); }
{DOS_PUNTOS}      { printf("DOS_PUNTOS: %s\n", yytext); }
{DOBLE_DOS_PUNTOS} { printf("DOBLE_DOS_PUNTOS: %s\n", yytext); }

{COMENTARIO}
" "             		
"\n"      		
"\t"
"\n\t"
"\r\n"
.                 printf("ERROR LEXICO en %d - Caracter no reconocido: %s\n", yylineno, yytext);

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
        printf("No se pudo abrir el archivo %s\n");
        return yyerror();
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
    
    printf("ERROR LEXICO en %d - Longitud de identificador muy grande: %s\n", yylineno, yytext);

    return yyerror();;
}

int verificarLongString(char* tk)
{
    /* tk es el lexema */

    if(strlen(tk) <= MAX_LONG_STR)
        return 0;

    printf("ERROR LEXICO en %d - Longitud de string muy grande: %s\n", yylineno, yytext);

    return yyerror();
}

int verificarRangoInt(char* tk)
{
    /* tk es el lexema */

    int valor = atoi(tk);

    if(valor >= MIN_VALOR_INT && valor <= MAX_VALOR_INT)
        return 0;

    printf("ERROR LEXICO en %d - Entero fuera de rango: %s\n", yylineno, yytext);
    
    return yyerror();
}

int verificarRangoFloat(char* tk)
{
    /* tk es el lexema */

    int valor = atof(tk);

    if(valor >= MIN_VALOR_FLOAT && valor <= MAX_VALOR_FLOAT)
        return 0;

    printf("ERROR LEXICO en %d - Entero fuera de rango: %s\n", yylineno, yytext);
    
    return yyerror();
}

/*
int yyerror(void)
{
    printf("\nError lexico: Caracter invalido: %s, saliendo...\n", yytext);
    exit(1);
}
*/