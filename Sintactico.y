// Usa Lexico_ClasePractica
//Solo expresiones sin ()
%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"
int yystopparser=0;
extern FILE *yyin;
int yyerror();
int yylex();


%}

%token CONST_INT
%token CONST_FLOAT
%token CONST_STRING
%token ID
%token OP_ASIG
%token OP_SUMA
%token OP_PRODUCTO
%token OP_RESTA
%token OP_COCIENTE
%token PAR_AP
%token PAR_CL
%token INIT
%token LLA_AP
%token LLA_CL
%token DOS_PUNTOS
%token INT
%token FLOAT
%token STRING
%token COMA
%token WHILE
%token AND
%token OR
%token NOT
%token OP_MAYOR
%token OP_MAYOR_IGUAL
%token OP_MENOR
%token OP_MENOR_IGUAL
%token OP_IGUAL
%token OP_DISTINTO
%token IF
%token ELSE
%token WRITE
%token READ
%token REORDER
%token COR_AP
%token COR_CL
%token SUMFIRSTPRIMES
%token EQ
%token ASIGCOMP
%token CONT
%token SET
%token SWITCH
%token CASE
%token ELSECASE
%token ENDSETCASE
%token FIB
%token PUNTO_Y_COMA
%token DOBLE_DOS_PUNTOS

%%

programa:
	{printf("\nINICIO DEL PROGRAMA\n");} variables bloque {printf("FIN DEL PROGRAMA\n");}
	;

variables:
	INIT LLA_AP declaraciones LLA_CL {printf("bloque sentencia es bloque\n\n");}
	;

declaraciones:
	declaraciones declaracion{printf("declaraciones declaracion es declaraciones\n\n");}
	|declaracion{printf("declaracion es declaraciones\n\n");}
	;

declaracion:
	lista_var DOS_PUNTOS t_dato{printf("lista_var : t_dato es declaracion\n");}
	;

t_dato:
	INT {
		printf("INT es t_dato\n");
	}
	|STRING {
		printf("STRING es t_dato\n");
	}
	|FLOAT	{
		printf("FLOAT es t_dato\n");
	}
	;

lista_var:
	lista_var COMA ID {
		printf("lista_var COMA ID es lista_var\n");
	}
	|ID {
		printf("ID es lista_var\n");
	}
	;


bloque:
	bloque sentencia {printf("bloque sentencia es bloque\n\n");}
	|sentencia{printf("sentencia es bloque\n\n");}
	;

sentencia:  	   
	asignacion {printf(" FIN\n");} ;
	|iteracion{printf("iteracion es sentencia\n");}
	|seleccion{printf("seleccion es sentencia\n");}
	|read{printf("read es sentencia\n");} 
	|write{printf("write es sentencia\n");}
	|reorder{printf("reorder es sentencia\n");}
	|sumfirstprimes {printf("sumfirstprimes es sentencia\n");}
	|asigcomp {printf("asignacion compleja es sentencia\n");}
	|fibonacci {printf("fibonacci es sentencia\n");}
	|contardistinto {printf("contar distinto es sentencia\n");}
	|setswitch {printf("setswitch es sentencia\n");}
	;
	
asignacion: 
    ID OP_ASIG expresion {printf("    ID = Expresion es ASIGNACION\n");}
	;

iteracion:
	WHILE PAR_AP condiciones PAR_CL LLA_AP bloque LLA_CL {printf("WHILE PAR_AP condiciones PAR_CL LLA_AP bloque LLA_CL es una iteracion\n");}
	;

seleccion:
	IF PAR_AP condiciones PAR_CL LLA_AP bloque LLA_CL {printf("IF PA condiciones PC CA bloque CC es seleccion\n");}
	|IF PAR_AP condiciones PAR_CL LLA_AP bloque LLA_CL ELSE LLA_AP bloque LLA_CL {printf("IF PA condiciones PC CA bloque CC ELSE CA bloque CC es seleccion\n");}
	;

read:
	READ PAR_AP ID PAR_CL{printf("READ PAR_AP ID PAR_CL es read\n");}
	;

write:
	WRITE PAR_AP ID PAR_CL{printf("WRITE PAR_AP ID PAR_CL es write\n");}
	| WRITE PAR_AP CONST_STRING PAR_CL{printf("WRITE PAR_AP CONST_STRING PAR_CL es write\n");}
	;
	
reorder:
	REORDER PAR_AP COR_AP expresiones COR_CL COMA CONST_INT COMA CONST_INT PAR_CL {printf("REORDER PAR_AP COR_AP expresiones COR_CL COMA CONST_INT COMA CONST_INT PAR_CL es reorder\n");}
	;

sumfirstprimes:
	ID EQ SUMFIRSTPRIMES PAR_AP CONST_INT PAR_CL {printf("ID OP_ASIG SUMFIRSTPRIMES PAR_AP CONST_INT PAR_CL es sumfirstprimes\n");}
	;
	
expresiones:
	expresiones COMA expresion {printf("expresiones COMA expresion es expresiones\n");}
	| expresion  {printf("expresion es expresiones\n");}
	;
	
condiciones:
    condicion {printf("condicion es condiciones\n");}
	|NOT condicion {printf("NOT condicion es condiciones\n");}
    |condiciones AND condicion{printf("condiciones AND condicion es condiciones\n");}
	|condiciones OR condicion{printf("condiciones OR condicion es condiciones\n");}
	|condiciones AND NOT condicion{printf("condiciones AND NOT condicion es condiciones\n");}
	|condiciones OR NOT condicion{printf("condiciones OR NOT condicion es condiciones\n");}
	;

condicion:
	 expresion OP_MAYOR expresion  {printf("expresion OP_MEN expresion es condicion\n");}
	| expresion OP_MAYOR_IGUAL expresion  {printf("expresion OP_MAY expresion es condicion\n");}
	| expresion OP_MENOR expresion  {printf("expresion OP_MENI expresion es condicion\n");}
	| expresion OP_MENOR_IGUAL expresion  {printf("expresion OP_MAYI expresion es condicion\n");}
	| expresion OP_IGUAL expresion  {printf("expresion OP_IGUAL expresion es condicion\n");}
	| expresion OP_DISTINTO expresion  {printf("expresion OP_DIST expresion es condicion\n");}
	;
	
expresion:
     termino {printf("    Termino es Expresion\n");}
	|expresion OP_SUMA termino {printf("    Expresion+Termino es Expresion\n");}
	|expresion OP_RESTA termino {printf("    Expresion-Termino es Expresion\n");}
	;

termino: 
     factor {printf("    Factor es Termino\n");}
    |termino OP_PRODUCTO factor {printf("     Termino*Factor es Termino\n");}
    |termino OP_COCIENTE factor {printf("     Termino/Factor es Termino\n");}
    ;

factor: 
      ID {printf("    ID es Factor \n");}
      | CONST_INT {printf("CONST_INT es Factor\n");}
	  | CONST_FLOAT {printf("CONST_FLOAT es Factor\n");}
	  | CONST_STRING {printf("CONST_STRING es Factor\n");}
	| PAR_AP expresion PAR_CL {printf("    Expresion entre parentesis es Factor\n");}
	| OP_RESTA factor { printf("-Factor es Factor\n"); }
     	;

asigcomp:
	ASIGCOMP PAR_AP COR_AP asignacion_comp COR_CL PAR_CL {
		printf("ASIGCOMP PAR_AP COR_AP asignacion_comp COR_CL PAR_CL es asigcomp\n");
	}
	;

asignacion_comp:
	ID COR_CL DOS_PUNTOS COR_AP valor_asig {
		printf("ID COR_CL DOS_PUNTOS COR_AP valor_asig es asignacion_comp\n");
	}
	|ID COMA asignacion_comp COMA valor_asig {
		printf("ID COMA asignacion_comp COMA valor_asig es asignacion_comp\n");
	}
	;

valor_asig:
	CONST_INT { printf("CONST_INT es valor_asig\n"); }
	|ID { printf("ID es valor_asig\n"); }
	|CONST_FLOAT { printf("CONST_FLOAT es valor_asig\n"); }
	|CONST_STRING { printf("CONST_STRING es valor_asig\n"); }
	;

fibonacci:
	FIB PAR_AP CONST_INT PAR_CL {
		printf("FIB PAR_AP CONST_INT PAR_CL es fibonacci\n");
	}
	|FIB PAR_AP ID PAR_CL {
		printf("FIB PAR_AP ID PAR_CL es fibonacci\n");
	}
	;

contardistinto:
	ID OP_ASIG CONT PAR_AP expresion DOBLE_DOS_PUNTOS COR_AP lista_contar COR_CL PAR_CL {
		printf("ID OP_ASIG CONT PAR_AP expresion DOBLE_DOS_PUNTOS COR_AP lista_contar COR_CL PAR_CL es contardistinto\n");
	}
	;

lista_contar:
	ID { printf("ID es lista_contar\n"); }
	|CONST_INT { printf("CONST_INT es lista_contar\n"); }
	|lista_contar COMA ID { printf("lista_contar COMA ID es lista_contar\n"); }
	|lista_contar COMA CONST_INT { printf("lista_contar COMA CONST_INT es lista_contar\n"); }
	;

setswitch:
	SET SWITCH PAR_AP expresion PAR_CL cases elsecase ENDSETCASE {
		printf("SET SWITCH PAR_AP expresion PAR_CL cases elsecase ENDSETCASE es setswitch\n");
	}
	;

cases:
	cases CASE CONST_INT DOS_PUNTOS bloque {
		printf("cases CASE CONST_INT DOS_PUNTOS bloque es cases\n");
	}
	|CASE CONST_INT DOS_PUNTOS bloque {
		printf("CASE CONST_INT DOS_PUNTOS bloque es cases\n");
	}
	;

elsecase:
	ELSECASE DOS_PUNTOS bloque {
		printf("ELSECASE DOS_PUNTOS bloque es elsecase\n");
	}
	;
%%


int main(int argc, char *argv[])
{
    if((yyin = fopen(argv[1], "rt"))==NULL)
    {
        printf("\nNo se puede abrir el archivo de prueba: %s\n", argv[1]);
       
    }
    else
    { 
        printf("\n El archivo %s se abrio correctamente\n", argv[1]);
        yyparse();
        
    }
	fclose(yyin);
        return 0;
}

/*int yyerror(void)
     {
       printf("Error Sintactico\n");
	 exit (1);
     }
*/
