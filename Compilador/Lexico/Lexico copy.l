%{
#include "y.tab.h"
#include "Lexico/Lexico.h"
#include "Archivo/Archivo.h"

/*VARIABLES*/
char *yytext;

/*FUNCIONES DEL LÉXICO*/
int yyerror(char* descripcion, char* lexema);

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
SET_SWITCH          "set switch"
CASE                "case"
ELSECASE            "elsecase"
ENDSETCASE          "endsetcase"
WHILE               "while"
READ                "read"
WRITE               "write"
ASIGCOMP            "asigComp"
CONT                "!cont"
REORDER             "reorder"
SUMFIRSTPRIMES      "sumFirstPrimes"
FIB                 "fib"          

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

{INT}               { printf("INT: %s\n", yytext); return INT; }
{FLOAT}             { printf("FLOAT: %s\n", yytext); return FLOAT; }
{STRING}            { printf("STRING: %s\n", yytext); return STRING; }

{AND}               { printf("AND: %s\n", yytext); return AND; }
{OR}                { printf("OR: %s\n", yytext); return OR; }
{NOT}               { printf("NOT: %s\n", yytext); return NOT; }

{INIT}              { printf("INIT: %s\n", yytext); return INIT; }
{IF}                { printf("IF: %s\n", yytext); return IF; }
{ELSE}              { printf("ELSE: %s\n", yytext); return ELSE; }
{SET_SWITCH}        { printf("SET SWITCH: %s\n", yytext); return SET_SWITCH; }
{CASE}              { printf("CASE: %s\n", yytext); return CASE; }
{ELSECASE}          { printf("ELSECASE: %s\n", yytext); return ELSECASE; }
{ENDSETCASE}        { printf("ENDSETCASE: %s\n", yytext); return ENDSETCASE; }
{WHILE}             { printf("WHILE: %s\n", yytext); return WHILE; }
{READ}              { printf("READ: %s\n", yytext); return READ; }
{WRITE}             { printf("WRITE: %s\n", yytext); return WRITE; }
{ASIGCOMP}          { printf("ASIGCOMP: %s\n", yytext); return ASIGCOMP; }
{CONT}              { printf("CONT: %s\n", yytext); return CONT; }
{REORDER}           { printf("REORDER: %s\n", yytext); return REORDER; }
{SUMFIRSTPRIMES}    { printf("SUMFIRSTPRIMES: %s\n", yytext); return SUMFIRSTPRIMES; }
{FIB}               { printf("FIB: %s\n", yytext); return FIB; }

{OP_SUMA}           { printf("OP_SUMA: %s\n", yytext); return OP_SUMA; }
{OP_RESTA}          { printf("OP_RESTA: %s\n", yytext); return OP_RESTA; }
{OP_PRODUCTO}       { printf("OP_PRODUCTO: %s\n", yytext); return OP_PRODUCTO; }
{OP_COCIENTE}       { printf("OP_COCIENTE: %s\n", yytext); return OP_COCIENTE; }

{OP_MAYOR}          { printf("OP_MAYOR: %s\n", yytext); return OP_MAYOR; }
{OP_MAYOR_IGUAL}    { printf("OP_MAYOR_IGUAL: %s\n", yytext); return OP_MAYOR_IGUAL; }
{OP_MENOR}          { printf("OP_MENOR: %s\n", yytext); return OP_MENOR; }
{OP_MENOR_IGUAL}    { printf("OP_MENOR_IGUAL: %s\n", yytext); return OP_MENOR_IGUAL; }
{OP_IGUAL}          { printf("OP_IGUAL: %s\n", yytext); return OP_IGUAL; }
{OP_DISTINTO}       { printf("OP_DISTINTO: %s\n", yytext); return OP_DISTINTO; }

{PAR_AP}            { printf("PAR_AP: %s\n", yytext); return PAR_AP; }
{PAR_CL}            { printf("PAR_CL: %s\n", yytext); return PAR_CL; }
{COR_AP}            { printf("COR_AP: %s\n", yytext); return COR_AP; }
{COR_CL}            { printf("COR_CL: %s\n", yytext); return COR_CL; }
{LLA_AP}            { printf("LLA_AP: %s\n", yytext); return LLA_AP; }
{LLA_CL}            { printf("LLA_CL: %s\n", yytext); return LLA_CL; }

{COMA}              { printf("COMA: %s\n", yytext); return COMA; }
{PUNTO_Y_COMA}      { printf("PUNTO_Y_COMA: %s\n", yytext); return PUNTO_Y_COMA; }
{DOS_PUNTOS}        { printf("DOS_PUNTOS: %s\n", yytext); return DOS_PUNTOS; }
{DOBLE_DOS_PUNTOS}  { printf("DOBLE_DOS_PUNTOS: %s\n", yytext); return DOBLE_DOS_PUNTOS; }

{ID}                { 
                        if(verificarLongId(yytext))
                        {
                            printf("IDENTIFICADOR: %s\n", yytext);
                            agregarTablaSimbolos(yytext, 1);
                            yylval.strVal = strdup(yytext);
                            return ID;
                        }
                        else
                        {
                            yyerror("Longitud de identificador muy grande", yytext);
                        }
                    }
{CONST_INT}         {
                        if(verificarRangoInt(yytext) == 0)
                        { 
                            printf("CONST_INT: %s\n", yytext);
                            agregarTablaSimbolos(yytext, 0);
                            return CONST_INT;
                        }
                        else
                        {
                            printf("Longitud de string muy grande", yytext);
                        }
                    }
{CONST_FLOAT}       {
                        if(verificarRangoFloat(yytext) == 0)
                        {
                            printf("CONST_FLOAT: %s\n", yytext);
                            agregarTablaSimbolos(yytext, 0);
                            return CONST_FLOAT;
                        }
                        else
                        {
                            printf("Entero fuera de rango", yytext);
                        }
                    }
{CONST_STRING}      {
                        if(verificarLongString(yytext) == 0)
                        {
                            printf("CONST_STRING: %s\n", yytext);
                            agregarTablaSimbolos(yytext, 0);
                            return CONST_STRING;
                        }
                        else
                        {
                            printf("Flotante fuera de rango", yytext);
                        }
                    }  

{OP_ASIG}           { printf("OP_ASIG: %s\n", yytext); return OP_ASIG; }

{COMENTARIO}
" "             		
"\n"      		
"\t"
"\n\t"
"\r\n"
.                   { printf("\nERROR LEXICO: Caracter no reconocido: %s\n", yytext); yyerror(); }

%%

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

int yyerror(char* descripcion, char* lexema)
{
    /* descripcion es el error léxico */
    /* lexema es la cadena inválida */

    printf("ERROR LEXICO - %s : %s\n", descripcion, lexema);
    printf("LÍNEA: %d\n", yylineno);

    exit(1);
}
