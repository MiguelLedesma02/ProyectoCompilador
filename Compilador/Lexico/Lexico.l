%{
#include "../Sintactico/y.tab.h"

#include "Lexico.h"
#include "../Archivo/Archivo.h"

/*VARIABLES GLOBALES*/
extern FILE *plexer;
extern FILE *pst;

char *yytext;

/*FUNCIONES DEL LÉXICO*/
int informarError(char* descripcion, char* lexema);

%}

%option noyywrap
%option yylineno

/*CONJUNTOS*/

DIGITO              [0-9]
LETRA               [a-zA-Z]

/*TIPOS DE DATOS*/

INT                 "int"
FLOAT               "float"
STRING              "string"

/*CONECTORES LÓGICOS*/

AND                 "AND"
OR                  "OR"
NOT                 "NOT"

/*PALABRAS RESERVADAS*/

INIT                "init"
IF                  "if"
ELSE                "else"
WHILE               "while"
READ                "read"
WRITE               "write"
REORDER             "reorder"
SUMFIRSTPRIMES      "sumFirstPrimes"

/*TOKENS BÁSICOS*/

ID                  {LETRA}({LETRA}|{DIGITO}|"_")*
CONST_INT           "-"?{DIGITO}+
CONST_FLOAT         "-"?(({DIGITO}+("."{DIGITO}*)?)|("."{DIGITO}+))([eE][-+]?{DIGITO}+)?
CONST_STRING        \"[^\n"]*\"
OP_ASIG             ":="
COMENTARIO          "#+"([^\n]|\n)*"+#"

/*OPERADORES ARITMÉTICOS*/

OP_SUMA             "+"
OP_RESTA            "-"
OP_PRODUCTO         "*"
OP_COCIENTE         "/"

/*OPERADORES LÓGICOS*/

OP_MAYOR            ">"
OP_MAYOR_IGUAL      ">="
OP_MENOR            "<"
OP_MENOR_IGUAL      "<="
OP_IGUAL            "=="
OP_DISTINTO         "!="

/*BLOQUES*/

PAR_AP              "("
PAR_CL              ")"
COR_AP              "["
COR_CL              "]"
LLA_AP              "{"
LLA_CL              "}"

/*PUNTUACIÓN*/

COMA                ","
PUNTO_Y_COMA        ";"
DOS_PUNTOS          ":"
DOBLE_DOS_PUNTOS    "::"

%%

{INT}               { fprintf(plexer, "INT: %s\n", yytext); return INT; }
{FLOAT}             { fprintf(plexer, "FLOAT: %s\n", yytext); return FLOAT; }
{STRING}            { fprintf(plexer, "STRING: %s\n", yytext); return STRING; }

{AND}               { fprintf(plexer, "AND: %s\n", yytext); return AND; }
{OR}                { fprintf(plexer, "OR: %s\n", yytext); return OR; }
{NOT}               { fprintf(plexer, "NOT: %s\n", yytext); return NOT; }

{INIT}              { fprintf(plexer, "INIT: %s\n", yytext); return INIT; }
{IF}                { fprintf(plexer, "IF: %s\n", yytext); return IF; }
{ELSE}              { fprintf(plexer, "ELSE: %s\n", yytext); return ELSE; }
{WHILE}             { fprintf(plexer, "WHILE: %s\n", yytext); return WHILE; }
{READ}              { fprintf(plexer, "READ: %s\n", yytext); return READ; }
{WRITE}             { fprintf(plexer, "WRITE: %s\n", yytext); return WRITE; }
{REORDER}           { fprintf(plexer, "REORDER: %s\n", yytext); return REORDER; }
{SUMFIRSTPRIMES}    { fprintf(plexer, "SUMFIRSTPRIMES: %s\n", yytext); return SUMFIRSTPRIMES; }

{OP_SUMA}           {
                        fprintf(plexer, "OP_SUMA: %s\n", yytext);
                        yylval.texto = strdup(yytext);
                        return OP_SUMA;
                    }
{OP_RESTA}          {
                        fprintf(plexer, "OP_RESTA: %s\n", yytext);
                        yylval.texto = strdup(yytext);
                        return OP_RESTA;
                    }
{OP_PRODUCTO}       {
                        fprintf(plexer, "OP_PRODUCTO: %s\n", yytext); 
                        yylval.texto = strdup(yytext);
                        return OP_PRODUCTO;
                    }
{OP_COCIENTE}       {
                        fprintf(plexer, "OP_COCIENTE: %s\n", yytext);
                        yylval.texto = strdup(yytext);
                        return OP_COCIENTE; 
                    }

{OP_MAYOR}          { fprintf(plexer, "OP_MAYOR: %s\n", yytext); return OP_MAYOR; }
{OP_MAYOR_IGUAL}    { fprintf(plexer, "OP_MAYOR_IGUAL: %s\n", yytext); return OP_MAYOR_IGUAL; }
{OP_MENOR}          { fprintf(plexer, "OP_MENOR: %s\n", yytext); return OP_MENOR; }
{OP_MENOR_IGUAL}    { fprintf(plexer, "OP_MENOR_IGUAL: %s\n", yytext); return OP_MENOR_IGUAL; }
{OP_IGUAL}          { fprintf(plexer, "OP_IGUAL: %s\n", yytext); return OP_IGUAL; }
{OP_DISTINTO}       { fprintf(plexer, "OP_DISTINTO: %s\n", yytext); return OP_DISTINTO; }

{PAR_AP}            { fprintf(plexer, "PAR_AP: %s\n", yytext); return PAR_AP; }
{PAR_CL}            { fprintf(plexer, "PAR_CL: %s\n", yytext); return PAR_CL; }
{COR_AP}            { fprintf(plexer, "COR_AP: %s\n", yytext); return COR_AP; }
{COR_CL}            { fprintf(plexer, "COR_CL: %s\n", yytext); return COR_CL; }
{LLA_AP}            { fprintf(plexer, "LLA_AP: %s\n", yytext); return LLA_AP; }
{LLA_CL}            { fprintf(plexer, "LLA_CL: %s\n", yytext); return LLA_CL; }

{COMA}              { fprintf(plexer, "COMA: %s\n", yytext); return COMA; }
{PUNTO_Y_COMA}      { fprintf(plexer, "PUNTO_Y_COMA: %s\n", yytext); return PUNTO_Y_COMA; }
{DOS_PUNTOS}        { fprintf(plexer, "DOS_PUNTOS: %s\n", yytext); return DOS_PUNTOS; }
{DOBLE_DOS_PUNTOS}  { fprintf(plexer, "DOBLE_DOS_PUNTOS: %s\n", yytext); return DOBLE_DOS_PUNTOS; }

{ID}                { 
                        if(verificarLongId(yytext))
                        {
                            fprintf(plexer, "ID: %s\n", yytext);
                            agregarToken(pst, yytext, NULL);
                            yylval.texto = strdup(yytext);
                            return ID;
                        }
                        else
                        {
                            informarError("Longitud de identificador muy grande", yytext);
                        }
                    }
{CONST_INT}         {
                        if(verificarRangoInt(yytext))
                        { 
                            fprintf(plexer, "CONST_INT: %s\n", yytext);
                            agregarToken(pst, yytext, "CTE_INTEGER");
                            yylval.texto = strdup(yytext);
                            return CONST_INT;
                        }
                        else
                        {
                            informarError("Entero fuera de rango", yytext);
                        }
                    }
{CONST_FLOAT}       {
                        if(verificarRangoFloat(yytext))
                        {
                            fprintf(plexer, "CONST_FLOAT: %s\n", yytext);
                            agregarToken(pst, yytext, "CTE_FLOAT");
                            yylval.texto = strdup(yytext);
                            return CONST_FLOAT;
                        }
                        else
                        {
                            informarError("Flotante fuera de rango", yytext);
                        }
                    }
{CONST_STRING}      {
                        if(verificarLongString(yytext))
                        {
                            fprintf(plexer, "CONST_STRING: %s\n", yytext);
                            agregarToken(pst, yytext, "CTE_STRING");
                            yylval.texto = strdup(yytext);
                            return CONST_STRING;
                        }
                        else
                        {
                            informarError("Longitud de string muy grande", yytext);
                        }
                    }  

{OP_ASIG}           { fprintf(plexer, "OP_ASIG: %s\n", yytext); return OP_ASIG; }

{COMENTARIO}
" "             		
"\n"      		
"\t"
"\n\t"
"\r\n"
.                   { informarError("Caracter no reconocido", yytext); }

%%

int informarError(char* descripcion, char* lexema)
{
    /* descripcion es el error léxico */
    /* lexema es la cadena inválida */

    printf("\n");
    printf("ERROR LEXICO - %s: %s\n", descripcion, lexema);
    printf("LINEA: %d\n", yylineno);
    printf("\n");

    exit(1);
}