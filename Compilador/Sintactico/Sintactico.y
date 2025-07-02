%{

#include "Sintactico.h"
#include "../Assembler/Assembler.c"

/*VARIABLES GLOBALES*/
extern int yylineno;
extern FILE *pparser;
extern FILE *pst;
extern FILE *ptemp;

int cantVarEnLinea = 0;
int cantVarDeclaradas = 0;
int varAux = 0;

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
    {
        imprimirTercetos();
        fclose(pparser);
        fclose(ptercetos);
        fclose(pst);
        fclose(ptemp);
        generarAssembler("./Outputs/symbol_table.txt", "./Outputs/intermediate-code.txt", "./Outputs/output.asm");
    }
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
        if(declararVar($3) == 0)
            yyerror("Se declaro una variable que habia sido previamente declarada.");

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
        if(declararVar($1) == 0)
            yyerror("Se declaro una variable que habia sido previamente declarada.");

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
        if(buscarVar($1) == 0)
            yyerror("No puede usar una variable que no fue declarada previamente.");

        char auxTD[MAX_LONG_TD];

        getTipo(pst, $1, auxTD);

        if(strcmp(auxTD, ETDind) != 0)
            yyerror("No se pueden realizar asignaciones con tipos de datos incompatibles.");
    }
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
        if(buscarVar($1) == 0)
            yyerror("No puede usar una variable que no fue declarada previamente.");

        char auxTD[MAX_LONG_TD];

        getTipo(pst, $1, auxTD);

        if(strcmp(auxTD, "CTE_STRING") != 0)
            yyerror("No se pueden realizar asignaciones con tipos de datos incompatibles.");
    }
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
	WHILE { apilar(Bpila, indiceTerceto); } PAR_AP condiciones PAR_CL LLA_AP
    { apilar(AUXPila, indiceTerceto); } bloque LLA_CL { generarWhile(); }
    { fprintf(pparser, "22) iteracion -> WHILE ( condiciones ) { bloque }\n"); }
    ;

seleccion:
	IF PAR_AP condiciones PAR_CL LLA_AP marcador_if bloque LLA_CL marcador_fin_if
    { fprintf(pparser, "23) seleccion -> IF ( condiciones ) { bloque }\n"); }
    ;

seleccion:
    IF PAR_AP condiciones PAR_CL LLA_AP marcador_if bloque LLA_CL marcador_else
    ELSE LLA_AP marcador_else_if bloque LLA_CL marcador_fin_else
    { fprintf(pparser, "24) seleccion -> IF ( condiciones ) { bloque } ELSE { bloque } \n"); }
    ;

marcador_if:
    { apilar(AUXPila, indiceTerceto); }
    ;

marcador_fin_if:
    { generarIf(); }
    ;

marcador_else:
    { generarInicioIfElse(); }
    ;

marcador_else_if:
    { apilar(AUXPila, indiceTerceto); }
    ;

marcador_fin_else:
    { generarFinIfElse(); }
    ;

read:
	READ PAR_AP ID PAR_CL
    { 
        if(buscarVar($3) == 0)
            yyerror("No puede usar una variable que no fue declarada previamente.");
        
        generarRead($3);
    }
    { fprintf(pparser, "25) read -> READ ( ID )\n") }
	;

write:
	WRITE PAR_AP ID PAR_CL
    {
        if(buscarVar($3) == 0)
            yyerror("No puede usar una variable que no fue declarada previamente.");

        generarWrite($3, 0);
    }
    { fprintf(pparser, "26) write -> WRITE ( ID )\n") }
	;

write:
	WRITE PAR_AP CONST_STRING PAR_CL { generarWrite($3, 1); }
    { fprintf(pparser, "27) write -> WRITE ( CONST_STRING )\n") }
	;

reorder:
    REORDER PAR_AP COR_AP expresiones COR_CL COMA CONST_INT COMA CONST_INT PAR_CL { reorder($7, $9); }
    { fprintf(pparser, "28) reorder -> REORDER ( [ expresiones ] , CONST_INT , CONST_INT )\n") }
    ;

sumfirstprimes:
	ID OP_ASIG SUMFIRSTPRIMES PAR_AP CONST_INT PAR_CL
    {
        if(buscarVar($1) == 0)
            yyerror("No puede usar una variable que no fue declarada previamente.");

        char auxTD[MAX_LONG_TD];

        getTipo(pst, $1, auxTD);

        if(strcmp(auxTD, "CTE_INTEGER") != 0)
            yyerror("No se pueden asignar el resultado de sumFirstPrimes a una variable no entera.");

        char op[MAX_LONG_STR];

        Strind = crearTerceto($5, "_", "_");

        sprintf(op, "[%d]", Strind);
        crearTerceto("SFP", op, "_");

        int suma = sumarPrimos(atoi($5));

        sprintf(op, "%d", suma);

        Eind = crearTerceto(op, "_", "_");
        Aind = crearTerceto($1, "_", "_");

        char op1[MAX_LONG_STR];
        char op2[MAX_LONG_STR];

        sprintf(op1, "[%d]", Aind);
        sprintf(op2, "[%d]", Eind);

        crearTerceto(":=", op1, op2);
    }
    { fprintf(pparser, "29) sumfirstprimes -> ID := SUMFIRSTPRIMES ( CONST_INT )\n") }
	;

expresiones:
    expresiones COMA expresion
    {
        char aux[10];
        char op1[10];
        char op2[10];

        sprintf(aux, "@aux%d", varAux);
        varAux ++;

        Aind = crearTerceto(aux, "_", "_");

        sprintf(op1, "[%d]", Aind);
        sprintf(op2, "[%d]", Eind);
        crearTerceto(":=", op1, op2);
    }
    { fprintf(pparser, "30) expresiones -> expresiones , expresion\n"); }
    ;

expresiones:
    expresion
    {
        char aux[10];
        char op1[10];
        char op2[10];

        sprintf(aux, "@aux%d", varAux);
        varAux ++;

        Aind = crearTerceto(aux, "_", "_");

        sprintf(op1, "[%d]", Aind);
        sprintf(op2, "[%d]", Eind);
        crearTerceto(":=", op1, op2);
    }
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
    condiciones AND { auxAND = desapilar(Bpila); apilar(ANDPila, auxAND); } condicion
    { fprintf(pparser, "34) condiciones -> condiciones AND condicion\n"); }
    ;

condiciones:
    condiciones OR { auxOR = desapilar(Bpila); apilar(ORPila, auxOR); } condicion
    { fprintf(pparser, "35) condiciones -> condiciones OR condicion\n"); }
    ;

condiciones:
    condiciones AND NOT condicion
    { fprintf(pparser, "36) condiciones -> condiciones AND NOT condicion\n"); }
    ;

condiciones:
    condiciones OR NOT condicion
    { fprintf(pparser, "37) condiciones -> condiciones OR NOT condicion\n"); }
    ;

condicion:
    expresion
    {
        apilar(Bpila, Eind);
        
        if(strcmp(ETDind, "CTE_INTEGER") == 0)
            apilar(ETDpila, 1);
        else
            apilar(ETDpila, 2);
    }
    OP_MAYOR expresion { Cind = generarCondicion("BLE"); }
    { fprintf(pparser, "38) condicion -> expresion > expresion\n"); }
    ;

condicion:
    expresion
    {
        apilar(Bpila, Eind);
        
        if(strcmp(ETDind, "CTE_INTEGER") == 0)
            apilar(ETDpila, 1);
        else
            apilar(ETDpila, 2);
    } 
    OP_MAYOR_IGUAL expresion { Cind = generarCondicion("BLT"); }
    { fprintf(pparser, "39) condicion -> expresion >= expresion\n"); }
    ;

condicion:
    expresion
    {
        apilar(Bpila, Eind);
        
        if(strcmp(ETDind, "CTE_INTEGER") == 0)
            apilar(ETDpila, 1);
        else
            apilar(ETDpila, 2);
    } 
    OP_MENOR expresion { Cind = generarCondicion("BGE"); }
    { fprintf(pparser, "40) condicion -> expresion < expresion\n"); }
    ;

condicion:
    expresion
    {
        apilar(Bpila, Eind);
        
        if(strcmp(ETDind, "CTE_INTEGER") == 0)
            apilar(ETDpila, 1);
        else
            apilar(ETDpila, 2);
    } 
    OP_MENOR_IGUAL expresion { Cind = generarCondicion("BGT"); }
    { fprintf(pparser, "41) condicion -> expresion <= expresion\n"); }
    ;

condicion:
    expresion
    {
        apilar(Bpila, Eind);
        
        if(strcmp(ETDind, "CTE_INTEGER") == 0)
            apilar(ETDpila, 1);
        else
            apilar(ETDpila, 2);
    } 
    OP_IGUAL expresion { Cind = generarCondicion("BNE"); }
    { fprintf(pparser, "42) condicion -> expresion == expresion\n"); }
    ;

condicion:
    expresion
    {
        apilar(Bpila, Eind);

        if(strcmp(ETDind, "CTE_INTEGER") == 0)
            apilar(ETDpila, 1);
        else
            apilar(ETDpila, 2);
    } 
    OP_DISTINTO expresion { Cind = generarCondicion("BEQ"); }
    { fprintf(pparser, "43) condicion -> expresion != expresion\n"); }
    ;

expresion:
    expresion
    {
        apilar(Epila, Eind);

        if(strcmp(ETDind, "CTE_INTEGER") == 0)
            apilar(ETDpila, 1);
        else
            apilar(ETDpila, 2);
    } 
    OP_SUMA termino
    { 
        Eind = desapilar(Epila);

        int auxTD = desapilar(ETDpila);

        if(auxTD == 1)
            strcpy(ETDind, "CTE_INTEGER");
        else
            strcpy(ETDind, "CTE_FLOAT");

        if(strcmp(ETDind, TTDind) != 0)
            yyerror("No se pueden sumar tipos de datos incompatibles.");
    }
    {
        char op1[10];
        char op2[10];

        sprintf(op1, "[%d]", Eind);
        sprintf(op2, "[%d]", Tind);

        Eind = crearTerceto($3, op1, op2);
    }
    { fprintf(pparser, "44) expresion -> expresion + termino\n"); }
    ;

expresion:
    expresion
    {
        apilar(Epila, Eind);

        if(strcmp(ETDind, "CTE_INTEGER") == 0)
            apilar(ETDpila, 1);
        else
            apilar(ETDpila, 2);
    } 
    OP_RESTA termino
    { 
        Eind = desapilar(Epila);

        int auxTD = desapilar(ETDpila);

        if(auxTD == 1)
            strcpy(ETDind, "CTE_INTEGER");
        else
            strcpy(ETDind, "CTE_FLOAT");

        if(strcmp(ETDind, TTDind) != 0)
            yyerror("No se pueden restar tipos de datos incompatibles.");
    }
    {
        char op1[10];
        char op2[10];

        sprintf(op1, "[%d]", Eind);
        sprintf(op2, "[%d]", Tind);

        Eind = crearTerceto($3, op1, op2); 
    }
    { fprintf(pparser, "45) expresion -> expresion - termino\n"); }
    ;

expresion:
    termino
    {
        strcpy(ETDind , TTDind);
        Eind = Tind;
    }
    { fprintf(pparser, "46) expresion -> termino\n"); }
    ;

termino:
    termino
    {
        apilar(Tpila, Tind);

        if(strcmp(TTDind, "CTE_INTEGER") == 0)
            apilar(TTDpila, 1);
        else
            apilar(TTDpila, 2);
    } 
    OP_PRODUCTO factor
    { 
        Tind = desapilar(Tpila);
        int auxTD = desapilar(TTDpila);

        if(auxTD == 1)
            strcpy(TTDind, "CTE_INTEGER");
        else
            strcpy(TTDind, "CTE_FLOAT");

        if(strcmp(TTDind, FTDind) != 0)
            yyerror("No se pueden multiplicar tipos de datos incompatibles.");
    }
    {
        char op1[10];
        char op2[10];

        sprintf(op1, "[%d]", Tind);
        sprintf(op2, "[%d]", Find);

        Tind = crearTerceto($3, op1, op2); 
    }
    { fprintf(pparser, "47) termino -> termino * factor\n"); }
    ;

termino:
    termino
    {
        apilar(Tpila, Tind);

        if(strcmp(TTDind, "CTE_INTEGER") == 0)
            apilar(TTDpila, 1);
        else
            apilar(TTDpila, 2);
    } 
    OP_COCIENTE factor
    { 
        Tind = desapilar(Tpila);
        int auxTD = desapilar(TTDpila);

        if(auxTD == 1)
            strcpy(TTDind, "CTE_INTEGER");
        else
            strcpy(TTDind, "CTE_FLOAT");

        if(strcmp(TTDind, FTDind) != 0)
            yyerror("No se pueden dividir tipos de datos incompatibles.");
    }
    {
        char op1[10];
        char op2[10];

        sprintf(op1, "[%d]", Tind);
        sprintf(op2, "[%d]", Find);

        Tind = crearTerceto($3, op1, op2); 
    }
    { fprintf(pparser, "48) termino -> termino / factor\n"); }
    ;

termino:
    factor
    {
        strcpy(TTDind , FTDind);
        Tind = Find;
    }
    { fprintf(pparser, "49) termino -> factor\n"); }
    ;

factor:
    ID
    {
        if(buscarVar($1) == 0)
            yyerror("No puede usar una variable que no fue declarada previamente.");
        
        char auxTD[MAX_LONG_TD];

        getTipo(pst, $1, auxTD);

        strcpy(FTDind, auxTD);
        Find = crearTerceto($1, "_", "_");
    }
    { fprintf(pparser, "50) factor -> ID\n"); }
    ;

factor:
    CONST_INT
    { 
        strcpy(FTDind, "CTE_INTEGER");
        Find = crearTerceto($1, "_", "_");
    }
    { fprintf(pparser, "51) factor -> CONST_INT\n"); }
    ;

factor:
    CONST_FLOAT
    {
        strcpy(FTDind, "CTE_FLOAT");
        Find = crearTerceto($1, "_", "_");
    }
    { fprintf(pparser, "52) factor -> CONST_FLOAT\n"); }
    ;

factor:
    PAR_AP expresion PAR_CL
    {
        strcpy(FTDind, ETDind);
        Find = Eind;
    }
    { fprintf(pparser, "53) factor -> ( expresion )\n"); }
    ;

%%

int yyerror(char* descripcion)
{
    /* descripcion es el error sintáctico */

    printf("\n");
    printf("ERROR: %s\n", descripcion);
    printf("LINEA: %d\n", yylineno);
    printf("\n");

    fclose(ptemp);
    remove("temp.txt");
    exit(1);
}