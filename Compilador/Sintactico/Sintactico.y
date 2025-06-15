%{
#include "../Utilitarios/Utilitarios.h"

/*VARIABLES GLOBALES*/
extern int yylineno;
extern FILE *pparser;

/*FUNCIONES DEL SINTÁCTICO*/
int yylex();
int yyerror(char* descripcion);

%}

/*TIPOS DE DATOS*/

%token INT
%token FLOAT
%token STRING

/*CONECTORES LÓGICOS*/

%token AND
%token OR
%token NOT

/*PALABRAS RESERVADAS*/

%token INIT
%token IF
%token ELSE
%token SET_SWITCH
%token CASE
%token ELSECASE
%token ENDSETCASE
%token WHILE
%token READ
%token WRITE
%token ASIGCOMP
%token CONT
%token REORDER
%token SUMFIRSTPRIMES
%token FIB

/*TOKENS BÁSICOS*/

%token ID
%token CONST_INT
%token CONST_FLOAT
%token CONST_STRING
%token OP_ASIG

/*OPERADORES ARITMÉTICOS*/

%token OP_SUMA
%token OP_RESTA
%token OP_PRODUCTO
%token OP_COCIENTE

/*OPERADORES LÓGICOS*/

%token OP_MAYOR
%token OP_MAYOR_IGUAL
%token OP_MENOR
%token OP_MENOR_IGUAL
%token OP_IGUAL
%token OP_DISTINTO

/*BLOQUES*/

%token PAR_AP
%token PAR_CL
%token COR_AP
%token COR_CL
%token LLA_AP
%token LLA_CL

/*PUNTUACIÓN*/

%token COMA
%token PUNTO_Y_COMA
%token DOBLE_DOS_PUNTOS
%token DOS_PUNTOS

%%

programa:
	variables bloque
    { fprintf(pparser, "1) programa -> variables bloque\n"); }
	;

variables:
	INIT LLA_AP declaraciones LLA_CL
    { fprintf(pparser, "2) variables -> INIT { declaraciones }\n"); }
	;

declaraciones:
	declaraciones declaracion
    { fprintf(pparser, "3) declaraciones -> declaraciones declaracion\n"); }
	;

declaraciones:
	declaracion
    { fprintf(pparser, "4) declaraciones -> declaracion\n"); }
	;

declaracion:
	lista_var DOS_PUNTOS t_dato
    { fprintf(pparser, "5) declaracion -> lista_var : t_dato\n"); }
	;

t_dato:
	INT
    { fprintf(pparser, "6) t_dato -> INT\n"); }
    ;

t_dato:
	STRING
    { fprintf(pparser, "7) t_dato -> STRING\n"); }
    ;

t_dato:
	FLOAT
    { fprintf(pparser, "8) t_dato -> FLOAT\n"); }
    ;

lista_var:
	lista_var COMA ID
    { fprintf(pparser, "9) lista_var -> lista_var , ID\n"); }
	;

lista_var:
	ID
    { fprintf(pparser, "10) lista_var -> ID\n"); }
	;

bloque:
	bloque sentencia
    { fprintf(pparser, "11) bloque -> bloque sentencia\n"); }
	;

bloque:
	sentencia
    { fprintf(pparser, "12) bloque -> sentencia\n"); }
	;

sentencia:
	asignacion
    { fprintf(pparser, "13) sentencia -> asignacion\n"); }
    ;

sentencia:
	iteracion
    { fprintf(pparser, "14) sentencia -> iteracion\n"); }
    ;

sentencia:
	seleccion
    { fprintf(pparser, "15) sentencia -> seleccion\n"); }
    ;

sentencia:
	read
    { fprintf(pparser, "16) sentencia -> read\n"); }
    ;

sentencia:
	write
    { fprintf(pparser, "17) sentencia -> write\n"); }
    ;

sentencia:
	reorder
    { fprintf(pparser, "18) sentencia -> reorder\n"); }
    ;

sentencia:
	sumfirstprimes
    { fprintf(pparser, "19) sentencia -> sumfirstprimes\n"); }
    ;

asignacion:
	ID OP_ASIG expresion
    { fprintf(pparser, "20) asignacion -> ID := expresion\n"); }
    ;

asignacion:
	ID OP_ASIG CONST_STRING
    { fprintf(pparser, "21) asignacion -> ID := CONST_STRING\n"); }
    ;

iteracion:
	WHILE PAR_AP condiciones PAR_CL LLA_AP bloque LLA_CL
    { fprintf(pparser, "22) iteracion -> WHILE ( condiciones ) { bloque }\n"); }
    ;

seleccion:
	IF PAR_AP condiciones PAR_CL LLA_AP bloque LLA_CL
    { fprintf(pparser, "23) seleccion -> IF ( condiciones ) { bloque }\n"); }
    ;

seleccion:
	IF PAR_AP condiciones PAR_CL LLA_AP bloque LLA_CL ELSE LLA_AP bloque LLA_CL
    { fprintf(pparser, "24) seleccion -> IF ( condiciones ) { bloque } ELSE { bloque } \n"); }
    ;

read:
	READ PAR_AP ID PAR_CL
    { fprintf(pparser, "25) read -> READ ( ID )\n") }
	;

write:
	WRITE PAR_AP ID PAR_CL
    { fprintf(pparser, "26) write -> WRITE ( ID )\n") }
	;

write:
	WRITE PAR_AP CONST_STRING PAR_CL
    { fprintf(pparser, "27) write -> WRITE ( CONST_STRING )\n") }
	;

reorder:
    REORDER PAR_AP COR_AP expresiones COR_CL COMA CONST_INT COMA CONST_INT PAR_CL
    { fprintf(pparser, "28) reorder -> REORDER ( [ expresiones ] , CONST_INT , CONST_INT )\n") }
    ;

sumfirstprimes:
	ID OP_ASIG SUMFIRSTPRIMES PAR_AP CONST_INT PAR_CL
    { fprintf(pparser, "29) sumfirstprimes -> ID := SUMFIRSTPRIMES ( CONST_INT )\n") }
	;

expresiones:
    expresiones COMA expresion
    { fprintf(pparser, "30) expresiones -> expresiones , expresion\n"); }
    ;

expresiones:
    expresion
    { fprintf(pparser, "31) expresiones -> expresion\n"); }
    ;

condiciones:
    condicion
    { fprintf(pparser, "32) condiciones -> condicion\n"); }
    ;

condiciones:
    NOT condicion
    { fprintf(pparser, "33) condiciones -> NOT condicion\n"); }
    ;

condiciones:
    condiciones AND condicion
    { fprintf(pparser, "34) condiciones -> condiciones AND condicion\n"); }
    ;

condiciones:
    condiciones OR condicion
    { fprintf(pparser, "35) condiciones -> condiciones OR condicion\n"); }
    ;

condiciones:
    condiciones NOT condicion
    { fprintf(pparser, "36) condiciones -> condiciones NOT condicion\n"); }
    ;

condiciones:
    condiciones AND NOT condicion
    { fprintf(pparser, "37) condiciones -> condiciones AND NOT condicion\n"); }
    ;

condiciones:
    condiciones OR NOT condicion
    { fprintf(pparser, "38) condiciones -> condiciones OR NOT condicion\n"); }
    ;

condicion:
    expresion OP_MAYOR expresion
    { fprintf(pparser, "39) condicion -> expresion > expresion\n"); }
    ;

condicion:
    expresion OP_MAYOR_IGUAL expresion
    { fprintf(pparser, "40) condicion -> expresion >= expresion\n"); }
    ;

condicion:
    expresion OP_MENOR expresion
    { fprintf(pparser, "41) condicion -> expresion < expresion\n"); }
    ;

condicion:
    expresion OP_MENOR_IGUAL expresion
    { fprintf(pparser, "42) condicion -> expresion <= expresion\n"); }
    ;

condicion:
    expresion OP_IGUAL expresion
    { fprintf(pparser, "43) condicion -> expresion == expresion\n"); }
    ;

condicion:
    expresion OP_DISTINTO expresion
    { fprintf(pparser, "44) condicion -> expresion != expresion\n"); }
    ;

expresion:
    expresion OP_SUMA termino
    { fprintf(pparser, "45) expresion -> expresion + termino\n"); }
    ;

expresion:
    expresion OP_RESTA termino
    { fprintf(pparser, "46) expresion -> expresion - termino\n"); }
    ;

expresion:
    termino
    { fprintf(pparser, "47) expresion -> termino\n"); }
    ;

termino:
    termino OP_PRODUCTO factor
    { fprintf(pparser, "48) termino -> termino * factor\n"); }
    ;

termino:
    termino OP_COCIENTE factor
    { fprintf(pparser, "49) termino -> termino / factor\n"); }
    ;

termino:
    factor
    { fprintf(pparser, "50) termino -> factor\n"); }
    ;

factor:
    ID
    { fprintf(pparser, "51) factor -> ID\n"); }
    ;

factor:
    CONST_INT
    { fprintf(pparser, "52) factor -> CONST_INT\n"); }
    ;

factor:
    CONST_FLOAT
    { fprintf(pparser, "53) factor -> CONST_FLOAT\n"); }
    ;

factor:
    PAR_AP expresion PAR_CL
    { fprintf(pparser, "54) factor -> ( expresion )\n"); }
    ;

%%

int yyerror(char* descripcion)
{
    /* descripcion es el error sintáctico */

    printf("\n");
    printf("ERROR SINTACTICO\n");
    printf("LINEA: %d\n", yylineno);
    printf("\n");

    exit(1);
}