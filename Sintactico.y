// Usa Lexico_ClasePractica
//Solo expresiones sin ()
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include "y.tab.h"
#include "Lista.h"
#include "Pila.h"
#include "Tercetos.h"

int yystopparser=0;
extern FILE *yyin;
extern char* yytext;
int yyerror();
int yylex();
tLista listaSimbolos;
t_pila pilaInit;

bool apilarInd = false;
bool pantalla = false;
bool numEncontrado = false;
bool condMult = false;

char nombre[200];
char valor[200];
char tipo[200];
char tipoLadoIzq[200];
char tipoLadoDer[200];
int longitud;

int Eind;
int Tind;
int Find;
int CADind;
int Aind;
int condInd;
int condIzqInd;
int BIind;
int condMultInd;
int pivotInd;
int auxInd;
int saltInd;
int ifAnidadoInd;

char EindC[50];
char readWrite[50];
char TindC[50];
char FindC[50];
char CADindC[50];
char AindC[50];
char WHind[50];
char condIndC[50];
char condIzqIndC[50];
char condMultIndC[50];
char etiquetaCond[50];
char escribirT[50];
char numeroABuscar[50];
char pivotIndC[50];
char auxIndC[50];
char nombreVarIzq[32];
%}

%union{
    /* Aca dentro se definen los campos de la variable yylval */
    char* strVal;
}

%token <strVal> CONST_INT
%token <strVal> CONST_FLOAT
%token <strVal> CONST_STRING
%token <strVal> ID
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
    ID OP_ASIG expresion {sprintf(EindC, "[%d]", Eind); Aind = crearTerceto(":=", nombreVarIzq, EindC);}
	;

iteracion:
	WHILE {apilarInd = true;} PAR_AP condiciones PAR_CL LLA_AP bloque LLA_CL {desapilar(&pilaInit, WHind); crearTerceto("BI", WHind, ""); desapilarTercetos(); modificarTerceto_saltoCondicional(condInd); apilarInd = false;}
	;

seleccion:
	IF PAR_AP condiciones PAR_CL LLA_AP bloque LLA_CL {if((condInd = desapilarTercetos()) != -1){modificarTerceto_saltoCondicional(condInd);}; if(condMult == true){modificarTerceto_saltoCondicional(condMultInd); condMult = false;};}
	|IF PAR_AP condiciones PAR_CL LLA_AP bloque LLA_CL {BIind = crearTerceto("BI", "", ""); if((condInd = desapilarTercetos()) != -1){modificarTerceto_saltoCondicional(condInd);};} ELSE LLA_AP bloque LLA_CL {modificarTerceto_saltoCondicional(BIind);}
	;

read:
	READ PAR_AP ID PAR_CL {printf("READ PAR_AP ID PAR_CL es read\n");crearTerceto("READ", $3, "");}
	;

write:
	WRITE PAR_AP ID PAR_CL {crearTerceto("WRITE", $3, "");}
	| WRITE PAR_AP CONST_STRING {strcpy(valor, yytext); strcpy(nombre, "_");
								strcat(nombre, eliminarComillas(valor)); insertarEnOrden(&listaSimbolos,nombre,"",valor,strlen(eliminarComillas(valor)) ? strlen(eliminarComillas(valor)) : 0); crearTerceto("WRITE", valor, "");} PAR_CL
	;
	
reorder:
    REORDER PAR_AP COR_AP expresiones COR_CL COMA CONST_INT COMA CONST_INT PAR_CL {
        printf("REORDER PAR_AP COR_AP expresiones COR_CL COMA CONST_INT COMA CONST_INT PAR_CL es reorder\n");
        // Primer CONST_INT
        strcpy(nombre, "_");
        strcat(nombre, $7); // Captura el primer índice
        insertarEnOrden(&listaSimbolos, nombre, "", $7, 0);
        sprintf(pivotIndC, "[%d]", pivotInd);
        pivotInd = crearTerceto(nombre, "", "");
        
        // Segundo CONST_INT
        strcpy(nombre, "_");
        strcat(nombre, $9); // Captura el segundo índice
        insertarEnOrden(&listaSimbolos, nombre, "", $9, 0);
        sprintf(auxIndC, "[%d]", auxInd);
        auxInd = crearTerceto(nombre, "", "");
        
        // Terceto REORDER con el arreglo y los índices
        sprintf(EindC, "[%d]", Eind); // Índice de la última expresión (representa el arreglo)
        //crearTerceto("REORDER", EindC, pivotIndC, auxIndC);
        
        // Terceto WRITE para el arreglo reordenado (asumiendo que es parte del comportamiento)
        sprintf(AindC, "_[%d]", Eind); // Representa el arreglo completo
        crearTerceto("WRITE", AindC, "");
    }
    ;

sumfirstprimes:
	ID EQ SUMFIRSTPRIMES PAR_AP CONST_INT PAR_CL {printf("ID OP_ASIG SUMFIRSTPRIMES PAR_AP CONST_INT PAR_CL es sumfirstprimes\n");}
	;
	
expresiones:
    expresiones COMA expresion {
        printf("expresiones COMA expresion es expresiones\n");
        sprintf(EindC, "[%d]", Eind);
        apilar(&pilaInit, EindC); // Apilar índice de la expresión
    }
    | expresion {
        printf("expresion es expresiones\n");
        sprintf(EindC, "[%d]", Eind);
        apilar(&pilaInit, EindC); // Apilar índice de la expresión
    }
    ;
	
condiciones:
    condicion {printf("condicion es condiciones\n");}
	|NOT condicion {printf("NOT condicion es condiciones\n");
			if (condInd != -1) {
            // Invertir el salto condicional (e.g., BLE -> BGT)
            char* saltoOriginal = etiquetaCond;
            if (strcmp(saltoOriginal, "BLE") == 0) strcpy(etiquetaCond, "BGT");
            else if (strcmp(saltoOriginal, "BGT") == 0) strcpy(etiquetaCond, "BLE");
            else if (strcmp(saltoOriginal, "BLT") == 0) strcpy(etiquetaCond, "BGE");
            else if (strcmp(saltoOriginal, "BGE") == 0) strcpy(etiquetaCond, "BLT");
            else if (strcmp(saltoOriginal, "BNE") == 0) strcpy(etiquetaCond, "BEQ");
            else if (strcmp(saltoOriginal, "BEQ") == 0) strcpy(etiquetaCond, "BNE");
            // Reemplazar el terceto de salto con el inverso
            strcpy(tercetos[condInd].operador, etiquetaCond);
            apilarTercetos(condInd); // Reapilar el terceto modificado
        }
		}
    |condiciones AND condicion{printf("condiciones AND condicion es condiciones\n");
	int tempInd = desapilarTercetos();
        int cond2Ind = condInd; // Salto de la segunda condición
        // Crear un salto incondicional para el caso en que la primera condición sea falsa
        condMultInd = crearTerceto("BI", "", "");
        // Modificar el salto de la primera condición para que apunte a la segunda
        modificarTerceto_saltoCondicional(tempInd);
        // Apilar el salto de la segunda condición
        apilarTercetos(cond2Ind);
        condMult = true; // Indicar condición múltiple
		}
	|condiciones OR condicion{printf("condiciones OR condicion es condiciones\n");
	int tempInd = desapilarTercetos();
        int cond2Ind = condInd; // Salto de la segunda condición
        // Modificar el salto de la primera condición (inverso para OR)
        modificarTerceto_etiquetaCond(tercetos[tempInd].operador, tempInd);
        modificarTerceto_saltoCondicional(tempInd);
        // Apilar el salto de la segunda condición
        apilarTercetos(cond2Ind);
        condMult = true; // Indicar condición múltiple
	}
	|condiciones AND NOT condicion{printf("condiciones AND NOT condicion es condiciones\n");
		if (condInd != -1) {
            // Invertir el salto de la segunda condición
            char* saltoOriginal = etiquetaCond;
            if (strcmp(saltoOriginal, "BLE") == 0) strcpy(etiquetaCond, "BGT");
            else if (strcmp(saltoOriginal, "BGT") == 0) strcpy(etiquetaCond, "BLE");
            else if (strcmp(saltoOriginal, "BLT") == 0) strcpy(etiquetaCond, "BGE");
            else if (strcmp(saltoOriginal, "BGE") == 0) strcpy(etiquetaCond, "BLT");
            else if (strcmp(saltoOriginal, "BNE") == 0) strcpy(etiquetaCond, "BEQ");
            else if (strcmp(saltoOriginal, "BEQ") == 0) strcpy(etiquetaCond, "BNE");
            strcpy(tercetos[condInd].operador, etiquetaCond);
        }
        // Desapilar el terceto de salto de la primera condición
        int tempInd = desapilarTercetos();
        int cond2Ind = condInd; // Salto de la segunda condición (invertido)
        // Crear un salto incondicional para el caso en que la primera condición sea falsa
        condMultInd = crearTerceto("BI", "", "");
        // Modificar el salto de la primera condición para que apunte a la segunda
        modificarTerceto_saltoCondicional(tempInd);
        // Apilar el salto de la segunda condición
        apilarTercetos(cond2Ind);
        condMult = true; // Indicar condición múltiple
	}
	|condiciones OR NOT condicion{printf("condiciones OR NOT condicion es condiciones\n");
		if (condInd != -1) {
            // Invertir el salto de la segunda condición
            char* saltoOriginal = etiquetaCond;
            if (strcmp(saltoOriginal, "BLE") == 0) strcpy(etiquetaCond, "BGT");
            else if (strcmp(saltoOriginal, "BGT") == 0) strcpy(etiquetaCond, "BLE");
            else if (strcmp(saltoOriginal, "BLT") == 0) strcpy(etiquetaCond, "BGE");
            else if (strcmp(saltoOriginal, "BGE") == 0) strcpy(etiquetaCond, "BLT");
            else if (strcmp(saltoOriginal, "BNE") == 0) strcpy(etiquetaCond, "BEQ");
            else if (strcmp(saltoOriginal, "BEQ") == 0) strcpy(etiquetaCond, "BNE");
            strcpy(tercetos[condInd].operador, etiquetaCond);
        }
        // Desapilar el terceto de salto de la primera condición
        int tempInd = desapilarTercetos();
        int cond2Ind = condInd; // Salto de la segunda condición (invertido)
        // Modificar el salto de la primera condición (inverso para OR)
        modificarTerceto_etiquetaCond(tercetos[tempInd].operador, tempInd);
        modificarTerceto_saltoCondicional(tempInd);
        // Apilar el salto de la segunda condición
        apilarTercetos(cond2Ind);
        condMult = true; // Indicar condición múltiple
	}
	;

condicion:
	 expresion {
        condIzqInd = Eind; // Guardar el índice de la primera expresión
    } OP_MAYOR  expresion {sprintf(condIzqIndC, "[%d]", condIzqInd);
        if (apilarInd == true) { apilar(&pilaInit, condIzqIndC); }
        sprintf(EindC, "[%d]", Eind);
        crearTerceto("CMP", condIzqIndC, EindC);
        strcpy(etiquetaCond, "BLE");
        condInd = crearTerceto(etiquetaCond, "", "");
        apilarTercetos(condInd);}
	| expresion {
        condIzqInd = Eind; // Guardar el índice de la primera expresión
    } OP_MAYOR_IGUAL expresion {sprintf(condIzqIndC, "[%d]", condIzqInd);
        if (apilarInd == true) { apilar(&pilaInit, condIzqIndC); }
        sprintf(EindC, "[%d]", Eind);
        crearTerceto("CMP", condIzqIndC, EindC);
        strcpy(etiquetaCond, "BLT");
        condInd = crearTerceto(etiquetaCond, "", "");
        apilarTercetos(condInd);}
	| expresion {
        condIzqInd = Eind; // Guardar el índice de la primera expresión
    } OP_MENOR  expresion {sprintf(condIzqIndC, "[%d]", condIzqInd);
        if (apilarInd == true) { apilar(&pilaInit, condIzqIndC); }
        sprintf(EindC, "[%d]", Eind);
        crearTerceto("CMP", condIzqIndC, EindC);
        strcpy(etiquetaCond, "BGE");
        condInd = crearTerceto(etiquetaCond, "", "");
        apilarTercetos(condInd);}
	| expresion {
        condIzqInd = Eind; // Guardar el índice de la primera expresión
    } OP_MENOR_IGUAL expresion {sprintf(condIzqIndC, "[%d]", condIzqInd);
        if (apilarInd == true) { apilar(&pilaInit, condIzqIndC); }
        sprintf(EindC, "[%d]", Eind);
        crearTerceto("CMP", condIzqIndC, EindC);
        strcpy(etiquetaCond, "BGT");
        condInd = crearTerceto(etiquetaCond, "", "");
        apilarTercetos(condInd);}
	| expresion {
        condIzqInd = Eind; // Guardar el índice de la primera expresión
    } OP_IGUAL expresion {sprintf(condIzqIndC, "[%d]", condIzqInd);
        if (apilarInd == true) { apilar(&pilaInit, condIzqIndC); }
        sprintf(EindC, "[%d]", Eind);
        crearTerceto("CMP", condIzqIndC, EindC);
        strcpy(etiquetaCond, "BNE");
        condInd = crearTerceto(etiquetaCond, "", "");
        apilarTercetos(condInd);}
	| expresion {
        condIzqInd = Eind; // Guardar el índice de la primera expresión
    } OP_DISTINTO expresion {sprintf(condIzqIndC, "[%d]", condIzqInd);
        if (apilarInd == true) { apilar(&pilaInit, condIzqIndC); }
        sprintf(EindC, "[%d]", Eind);
        crearTerceto("CMP", condIzqIndC, EindC);
        strcpy(etiquetaCond, "BEQ");
        condInd = crearTerceto(etiquetaCond, "", "");
        apilarTercetos(condInd);}
	;
	
expresion:
     termino {Eind = Tind;}
	|expresion OP_SUMA termino {sprintf(EindC, "[%d]", Eind); sprintf(TindC, "[%d]", Tind); Eind = crearTerceto("+", EindC, TindC);}
	|expresion OP_RESTA termino {sprintf(EindC, "[%d]", Eind); sprintf(TindC, "[%d]", Tind); Eind = crearTerceto("-", EindC, TindC);}
	;

termino: 
     factor {Tind = Find;}
    |termino OP_PRODUCTO factor {sprintf(TindC, "[%d]", Tind); sprintf(FindC, "[%d]", Find); Tind = crearTerceto("*", TindC, FindC);}
    |termino OP_COCIENTE factor {sprintf(TindC, "[%d]", Tind); sprintf(FindC, "[%d]", Find); Tind = crearTerceto("/", TindC, FindC);}
    ;

factor: 
      ID {Find = crearTerceto(yytext,"","");}
      | CONST_INT {strcpy(nombre, "_");
    strcat(nombre, yytext); insertarEnOrden(&listaSimbolos,nombre,"",yytext,0); Find = crearTerceto(nombre,"","");}
	  | CONST_FLOAT {strcpy(nombre, "_");
    strcat(nombre, yytext); insertarEnOrden(&listaSimbolos,nombre,"",yytext,0); Find = crearTerceto(nombre,"","");}
	  | CONST_STRING {strcpy(nombre, "_");
                             strcat(nombre, eliminarComillas(valor)); insertarEnOrden(&listaSimbolos,nombre,"",valor,strlen(eliminarComillas(valor)) ? strlen(eliminarComillas(valor)) : 0); 
                             CADind = crearTerceto(nombre, "", "");}
	| PAR_AP expresion PAR_CL {Find = Eind;}
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
		crearLista(&listaSimbolos);
        crear_pila(&pilaInit);
        yyparse();
		eliminarTabla(&listaSimbolos);
        imprimirTercetos();
        vaciar_pila(&pilaInit);
        
    }
	printf("\nFLEX finalizo la lectura del archivo %s \n", argv[1]);
	fclose(yyin);
        return 0;
}

int yyerrorTiposEntreIds(char* ptr)
     {
       printf("Error semantico: asignacion o comparacion (id y id o id y cte) de distinto tipos en id = %s, saliendo... \n",yytext);
         exit (1);
     }


int yyerrorNoExisteVariable(char* ptr)
     {
       printf("Error semantico: variable no declarada: %s, saliendo... \n",ptr);
       exit (1);
     }

/*int yyerror(void)
     {
       printf("Error Sintactico\n");
	 exit (1);
     }
*/
