%{

#include "Sintactico.h"

/*VARIABLES GLOBALES*/
extern int yylineno;
extern FILE *pparser;
extern FILE *pst;
extern FILE *ptemp;

int cantVarEnLinea = 0;

/*FUNCIONES DEL SINTÁCTICO*/
int yylex();
int yyerror(char* descripcion);

%}

%union
{
    char* texto;
}

/*TIPOS DE DATOS*/

%token <texto> INT
%token <texto> FLOAT
%token <texto> STRING

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

%token <texto> ID
%token <texto> CONST_INT
%token <texto> CONST_FLOAT
%token <texto> CONST_STRING
%token <texto> OP_ASIG

/*OPERADORES ARITMÉTICOS*/

%token <texto> OP_SUMA
%token <texto> OP_RESTA
%token <texto> OP_PRODUCTO
%token <texto> OP_COCIENTE

/*OPERADORES LÓGICOS*/

%token <texto> OP_MAYOR
%token <texto> OP_MAYOR_IGUAL
%token <texto> OP_MENOR
%token <texto> OP_MENOR_IGUAL
%token <texto> OP_IGUAL
%token <texto> OP_DISTINTO

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
    {
        if(setTipoDato(pst, ptemp, tipoDato) == 0)
            yyerror("No se encontro la variable en la Tabla de Simbolos.");
        
    }
    { fprintf(pparser, "5) declaracion -> lista_var : t_dato\n"); }
	;

t_dato:
	INT { strcpy(tipoDato, $1); }
    { fprintf(pparser, "6) t_dato -> INT\n"); }
    ;

t_dato:
	FLOAT { strcpy(tipoDato, $1); }
    { fprintf(pparser, "8) t_dato -> FLOAT\n"); }
    ;

t_dato:
	STRING { strcpy(tipoDato, $1); }
    { fprintf(pparser, "7) t_dato -> STRING\n"); }
    ;

lista_var:
	lista_var COMA ID
    { 
        if(cantVarEnLinea >= MAX_VAR_EN_LINEA)
            yyerror("Se ha excedido de la cantidad de variables que pueden declararse en una linea.");

        strcpy(varEnLinea[cantVarEnLinea], $3);
        cantVarEnLinea ++;
    }
    { fprintf(pparser, "9) lista_var -> lista_var , ID\n"); }
	;

lista_var:
    ID
	{ 
        strcpy(varEnLinea[cantVarEnLinea], $1);
        cantVarEnLinea ++;
    }
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
    {
        char op1[10];
        char op2[10];

        Aind = crearTerceto($1, "_", "_");

        sprintf(op1, "[%d]", Aind);
        sprintf(op2, "[%d]", Eind);

        crearTerceto($2, op1, op2);
    }
    { fprintf(pparser, "20) asignacion -> ID := expresion\n"); }
    ;

asignacion:
	ID OP_ASIG CONST_STRING
    {
        char op[MAX_LONG_STR];
        char op1[10];
        char op2[10];

        sprintf(op, "%s", $3);

        Strind = crearTerceto(op, "_", "_");
        Aind = crearTerceto($1, "_", "_");

        sprintf(op1, "[%d]", Aind);
        sprintf(op2, "[%d]", Strind);

        crearTerceto($2, op1, op2);
    }
    { fprintf(pparser, "21) asignacion -> ID := CONST_STRING\n"); }
    ;

iteracion:
	WHILE { apilar(Bpila, indiceTerceto); } PAR_AP condiciones PAR_CL LLA_AP bloque LLA_CL { generarWhile(); }
    { fprintf(pparser, "22) iteracion -> WHILE ( condiciones ) { bloque }\n"); }
    ;

seleccion:
	IF PAR_AP condiciones PAR_CL LLA_AP bloque LLA_CL { generarIf(); }
    { fprintf(pparser, "23) seleccion -> IF ( condiciones ) { bloque }\n"); }
    ;

seleccion:
	IF PAR_AP condiciones PAR_CL LLA_AP bloque LLA_CL { generarInicioIfElse(); }
    ELSE LLA_AP bloque LLA_CL { generarFinIfElse(); }
    { fprintf(pparser, "24) seleccion -> IF ( condiciones ) { bloque } ELSE { bloque } \n"); }
    ;

read:
	READ PAR_AP ID PAR_CL { generarRead($3); }
    { fprintf(pparser, "25) read -> READ ( ID )\n") }
	;

write:
	WRITE PAR_AP ID PAR_CL { generarWrite($3, 0); }
    { fprintf(pparser, "26) write -> WRITE ( ID )\n") }
	;

write:
	WRITE PAR_AP CONST_STRING PAR_CL { generarWrite($3, 1); }
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
    NOT condicion { negarCondicion(Cind); }
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
    expresion { apilar(Bpila, Eind); } OP_MAYOR expresion { Cind = generarCondicion("BLE"); }
    { fprintf(pparser, "39) condicion -> expresion > expresion\n"); }
    ;

condicion:
    expresion { apilar(Bpila, Eind); } OP_MAYOR_IGUAL expresion { Cind = generarCondicion("BLT"); }
    { fprintf(pparser, "40) condicion -> expresion >= expresion\n"); }
    ;

condicion:
    expresion { apilar(Bpila, Eind); } OP_MENOR expresion { Cind = generarCondicion("BGE"); }
    { fprintf(pparser, "41) condicion -> expresion < expresion\n"); }
    ;

condicion:
    expresion { apilar(Bpila, Eind); } OP_MENOR_IGUAL expresion { Cind = generarCondicion("BGT"); }
    { fprintf(pparser, "42) condicion -> expresion <= expresion\n"); }
    ;

condicion:
    expresion { apilar(Bpila, Eind); } OP_IGUAL expresion { Cind = generarCondicion("BNE"); }
    { fprintf(pparser, "43) condicion -> expresion == expresion\n"); }
    ;

condicion:
    expresion { apilar(Bpila, Eind); } OP_DISTINTO expresion { Cind = generarCondicion("BEQ"); }
    { fprintf(pparser, "44) condicion -> expresion != expresion\n"); }
    ;

expresion:
    expresion { apilar(Epila, Eind); } OP_SUMA termino { Eind = desapilar(Epila); }
    {
        char op1[10];
        char op2[10];

        sprintf(op1, "[%d]", Eind);
        sprintf(op2, "[%d]", Tind);

        Eind = crearTerceto($3, op1, op2);
    }
    { fprintf(pparser, "45) expresion -> expresion + termino\n"); }
    ;

expresion:
    expresion { apilar(Epila, Eind); } OP_RESTA termino { Eind = desapilar(Epila); }
    {
        char op1[10];
        char op2[10];

        sprintf(op1, "[%d]", Eind);
        sprintf(op2, "[%d]", Tind);

        Eind = crearTerceto($3, op1, op2); 
    }
    { fprintf(pparser, "46) expresion -> expresion - termino\n"); }
    ;

expresion:
    termino
    { Eind = Tind; }
    { fprintf(pparser, "47) expresion -> termino\n"); }
    ;

termino:
    termino { apilar(Tpila, Tind); } OP_PRODUCTO factor { Tind = desapilar(Tpila); }
    {
        char op1[10];
        char op2[10];

        sprintf(op1, "[%d]", Tind);
        sprintf(op2, "[%d]", Find);

        Tind = crearTerceto($3, op1, op2); 
    }
    { fprintf(pparser, "48) termino -> termino * factor\n"); }
    ;

termino:
    termino { apilar(Tpila, Tind); } OP_COCIENTE factor { Tind = desapilar(Tpila); }
    {
        char op1[10];
        char op2[10];

        sprintf(op1, "[%d]", Tind);
        sprintf(op2, "[%d]", Find);

        Tind = crearTerceto($3, op1, op2); 
    }
    { fprintf(pparser, "49) termino -> termino / factor\n"); }
    ;

termino:
    factor
    { Tind = Find; }
    { fprintf(pparser, "50) termino -> factor\n"); }
    ;

factor:
    ID
    { Find = crearTerceto($1, "_", "_"); }
    { fprintf(pparser, "51) factor -> ID\n"); }
    ;

factor:
    CONST_INT
    { Find = crearTerceto($1, "_", "_"); }
    { fprintf(pparser, "52) factor -> CONST_INT\n"); }
    ;

factor:
    CONST_FLOAT
    { Find = crearTerceto($1, "_", "_"); }
    { fprintf(pparser, "53) factor -> CONST_FLOAT\n"); }
    ;

factor:
    PAR_AP expresion PAR_CL
    { Find = Eind; }
    { fprintf(pparser, "54) factor -> ( expresion )\n"); }
    ;

%%

int yyerror(char* descripcion)
{
    /* descripcion es el error sintáctico */

    printf("\n");
    printf("ERROR: %s\n", descripcion);
    printf("LINEA: %d\n", yylineno);
    printf("\n");

    exit(1);
}