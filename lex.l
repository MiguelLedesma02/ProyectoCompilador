%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

FILE *yyin;
char *yytext;

/*CONSTANTES*/
int MAX_LONG_ID   = 30;
int MAX_LONG_STR  = 50;
int MIN_VALOR_INT = -32768;
int MAX_VALOR_INT = 32767;
float MIN_VALOR_FLOAT = -3.4028235e38;
float MAX_VALOR_FLOAT = 3.4028235e38;

/*FUNCIONES*/
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

/*Tokens básicos*/

IDENTIFICADOR     {LETRA}({LETRA}|{DIGITO}|"_")*
CONST_INT         "-"?{DIGITO}+
CONST_FLOAT       "-"?{DIGITO}+"."{DIGITO}+([eE][-+]?{DIGITO}+)?
CONST_STRING      \"[^\n"]*\"
OP_ASIG           ":="
COMENTARIO        "#+"([^\n]|\n)*"+#"

/*Operadores aritméticos*/

OP_SUMA           "+"
OP_RESTA          "-"
OP_PRODUCTO       "*"
OP_COCIENTE       "-"

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

{IDENTIFICADOR}   { if(verificarLongId(yytext) == 0){ printf("IDENTIFICADOR: %s\n", yytext); } }
{CONST_INT}       { if(verificarRangoInt(yytext) == 0){ printf("CONST_INT: %s\n", yytext); } }
{CONST_FLOAT}     { if(verificarRangoFloat(yytext) == 0){ printf("CONST_FLOAT: %s\n", yytext); } }
{CONST_STRING}    { if(verificarLongString(yytext) == 0){ printf("CONST_STRING: %s\n", yytext); } }  
{OP_ASIG}         { printf("OP_ASIG: %s\n", yytext); }

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

{COMENTARIO}
" "             		
"\n"      		
"\t"
"\n\t"
"\r\n"
.                 printf("ERROR LEXICO en %d - Caracter no reconocido: %s\n", yylineno, yytext);

%%

int main (int argc, char* argv[])
{
    if ( (yyin = fopen (argv[1], "rt")) == NULL)
        printf("No se pudo abrir el archivo %s\n", argv[1]);
    
    printf("\n\n");
    yylex();
    printf("\n\n");

    fclose(yyin);

    return 0;
}

/*Funciones de validación*/

int verificarLongId(char* tk)
{
    if(strlen(tk) <= MAX_LONG_ID)
        return 0;
    
    printf("ERROR LEXICO en %d - Longitud de identificador muy grande: %s\n", yylineno, yytext);

    return yyerror();;
}

int verificarLongString(char* tk)
{
    if(strlen(tk) <= MAX_LONG_STR)
        return 0;

    printf("ERROR LEXICO en %d - Longitud de string muy grande: %s\n", yylineno, yytext);

    return yyerror();
}

int verificarRangoInt(char* tk)
{
    int valor = atoi(tk);

    if(valor >= MIN_VALOR_INT && valor <= MAX_VALOR_INT)
        return 0;

    printf("ERROR LEXICO en %d - Entero fuera de rango: %s\n", yylineno, yytext);
    
    return yyerror();
}

int verificarRangoFloat(char* tk)
{
    int valor = atof(tk);

    if(valor >= MIN_VALOR_FLOAT && valor <= MAX_VALOR_FLOAT)
        return 0;

    printf("ERROR LEXICO en %d - Entero fuera de rango: %s\n", yylineno, yytext);
    
    return yyerror();
}

int yyerror(void)
{
    exit(1);
}