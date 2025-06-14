%{
//#include "y.tab.h"
#include "Lexico.h"
#include "../Archivo/Archivo.h"

/*VARIABLES GLOBALES*/
FILE *plexer = NULL;
FILE *pst = NULL;

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

{INT}               { fprintf(plexer, "INT: %s\n", yytext); }
{FLOAT}             { fprintf(plexer, "FLOAT: %s\n", yytext); }
{STRING}            { fprintf(plexer, "STRING: %s\n", yytext); }

{AND}               { fprintf(plexer, "AND: %s\n", yytext); }
{OR}                { fprintf(plexer, "OR: %s\n", yytext); }
{NOT}               { fprintf(plexer, "NOT: %s\n", yytext); }

{INIT}              { fprintf(plexer, "INIT: %s\n", yytext); }
{IF}                { fprintf(plexer, "IF: %s\n", yytext); }
{ELSE}              { fprintf(plexer, "ELSE: %s\n", yytext); }
{SET_SWITCH}        { fprintf(plexer, "SET SWITCH: %s\n", yytext); }
{CASE}              { fprintf(plexer, "CASE: %s\n", yytext); }
{ELSECASE}          { fprintf(plexer, "ELSECASE: %s\n", yytext); }
{ENDSETCASE}        { fprintf(plexer, "ENDSETCASE: %s\n", yytext); }
{WHILE}             { fprintf(plexer, "WHILE: %s\n", yytext); }
{READ}              { fprintf(plexer, "READ: %s\n", yytext); }
{WRITE}             { fprintf(plexer, "WRITE: %s\n", yytext); }
{ASIGCOMP}          { fprintf(plexer, "ASIGCOMP: %s\n", yytext); }
{CONT}              { fprintf(plexer, "CONT: %s\n", yytext); }
{REORDER}           { fprintf(plexer, "REORDER: %s\n", yytext); }
{SUMFIRSTPRIMES}    { fprintf(plexer, "SUMFIRSTPRIMES: %s\n", yytext); }
{FIB}               { fprintf(plexer, "FIB: %s\n", yytext); }

{OP_SUMA}           { fprintf(plexer, "OP_SUMA: %s\n", yytext); }
{OP_RESTA}          { fprintf(plexer, "OP_RESTA: %s\n", yytext); }
{OP_PRODUCTO}       { fprintf(plexer, "OP_PRODUCTO: %s\n", yytext); }
{OP_COCIENTE}       { fprintf(plexer, "OP_COCIENTE: %s\n", yytext); }

{OP_MAYOR}          { fprintf(plexer, "OP_MAYOR: %s\n", yytext); }
{OP_MAYOR_IGUAL}    { fprintf(plexer, "OP_MAYOR_IGUAL: %s\n", yytext); }
{OP_MENOR}          { fprintf(plexer, "OP_MENOR: %s\n", yytext); }
{OP_MENOR_IGUAL}    { fprintf(plexer, "OP_MENOR_IGUAL: %s\n", yytext); }
{OP_IGUAL}          { fprintf(plexer, "OP_IGUAL: %s\n", yytext); }
{OP_DISTINTO}       { fprintf(plexer, "OP_DISTINTO: %s\n", yytext); }

{PAR_AP}            { fprintf(plexer, "PAR_AP: %s\n", yytext); }
{PAR_CL}            { fprintf(plexer, "PAR_CL: %s\n", yytext); }
{COR_AP}            { fprintf(plexer, "COR_AP: %s\n", yytext); }
{COR_CL}            { fprintf(plexer, "COR_CL: %s\n", yytext); }
{LLA_AP}            { fprintf(plexer, "LLA_AP: %s\n", yytext); }
{LLA_CL}            { fprintf(plexer, "LLA_CL: %s\n", yytext); }

{COMA}              { fprintf(plexer, "COMA: %s\n", yytext); }
{PUNTO_Y_COMA}      { fprintf(plexer, "PUNTO_Y_COMA: %s\n", yytext); }
{DOS_PUNTOS}        { fprintf(plexer, "DOS_PUNTOS: %s\n", yytext); }
{DOBLE_DOS_PUNTOS}  { fprintf(plexer, "DOBLE_DOS_PUNTOS: %s\n", yytext); }

{ID}                { 
                        if(verificarLongId(yytext))
                        {
                            fprintf(plexer, "ID: %s\n", yytext);
                            agregarToken(pst, yytext, NULL);
                            //yylval.strVal = strdup(yytext);
                        }
                        else
                        {
                            yyerror("Longitud de identificador muy grande", yytext);
                        }
                    }
{CONST_INT}         {
                        if(verificarRangoInt(yytext))
                        { 
                            fprintf(plexer, "CONST_INT: %s\n", yytext);
                            agregarToken(pst, yytext, "CTE_INTEGER");
                        }
                        else
                        {
                            yyerror("Entero fuera de rango", yytext);
                        }
                    }
{CONST_FLOAT}       {
                        if(verificarRangoFloat(yytext))
                        {
                            fprintf(plexer, "CONST_FLOAT: %s\n", yytext);
                            agregarToken(pst, yytext, "CTE_FLOAT");
                        }
                        else
                        {
                            yyerror("Flotante fuera de rango", yytext);
                        }
                    }
{CONST_STRING}      {
                        if(verificarLongString(yytext))
                        {
                            fprintf(plexer, "CONST_STRING: %s\n", yytext);
                            agregarToken(pst, yytext, "CTE_STRING");
                        }
                        else
                        {
                            yyerror("Longitud de string muy grande", yytext);
                        }
                    }  

{OP_ASIG}           fprintf(plexer, "OP_ASIG: %s\n", yytext);

{COMENTARIO}
" "             		
"\n"      		
"\t"
"\n\t"
"\r\n"
.                   { yyerror("Caracter no reconocido", yytext); }

%%

int main (int argc, char* argv[])
{
    char nombreArchivo[] = "./Outputs/symbol_table.txt";

    system("cls");

    if(abrirArchivo(&yyin, argv[1], "rt") == 1)
        return 1;

    if(abrirArchivo(&plexer, argv[2], "wt") == 1)
        return 1;
    
    if(abrirArchivo(&pst, nombreArchivo, "w+t") == 1)
        return 1;

    printf("INICIO DEL ANALISIS LEXICO\n");
    printf("\n. . .\n");

    yylex();
    
    printf("\nFIN DEL ANALISIS LEXICO\n");
    printf("\n");
    printf("Se creo el archivo: %s con todos los tokens.\n", argv[2]);
    printf("Se creo el archivo: %s con todos los IDs y CTEs.\n", nombreArchivo);
    printf("\n");

    fclose(yyin);
    fclose(plexer);
    fclose(pst);

    return 0;
}

int yyerror(char* descripcion, char* lexema)
{
    /* descripcion es el error léxico */
    /* lexema es la cadena inválida */

    printf("\n");
    printf("ERROR LEXICO - %s: %s\n", descripcion, lexema);
    printf("LINEA: %d\n", yylineno);
    printf("\n");

    exit(1);
}