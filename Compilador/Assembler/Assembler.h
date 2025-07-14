#ifndef ASSEMBLER_H
#define ASSEMBLER_H

#include "../Archivo/Archivo.h"
#include "../Lista/Lista.h"

//CONSTANTES
#define MAX_TAM_LINEA 200
#define MAX_TAM_VARIABLES 200
#define MAX_TAM_TERCETOS 500

//ESTRUCTURAS
typedef struct
{
    char nombre[MAX_LONG_STR];
    char tipoDato[MAX_LONG_STR];
    char valor[MAX_LONG_STR];
    unsigned longitud;
} lineaTS;

typedef struct
{
    char op[MAX_LONG_STR];
    char arg1[MAX_LONG_STR];
    char arg2[MAX_LONG_STR];
    int indice;
} terceto;

//FUNCIONES
void generarAssembler(char* symbolTableFile, char* intermediaCodeFile, char* assemblerCodeFile);

void cargarVariables(char* symbolTableFile);
void cargarTercetos(char* intermediaCodeFile);

void generarHeaders(FILE** pAC);
void generarVariables(FILE** pAC);
void generarCodigo(FILE** pAC);

//FUNCIONES DE GENERACIÓN DE VARIABLES
void crearVariableProgramador(FILE** pAC, lineaTS linea);
void crearVariableCompilador(FILE** pAC, char *nombre, char *tipoDato, char *valor, int longitud);

//FUNCIONES DE GENERACIÓN DE CÓDIGO
void generarInicio(FILE** pAC);
void generarInstrucciones(FILE** pAC);
void generarFin(FILE** pAC);

//FUNCIONES DE GENERACIÓN DE INSTRUCCIONES
void crearEtiquetas(Lista** etiquetas);

int esLectura(int indice);
int esEscritura(int indice);
int esAsignacion(int indice);
int esOperacion(int indice);
int esComparacion(int indice);
int esSalto(int indice);

int esSFP(int indice);

void generarEtiqueta(FILE** pAC, int indice);
void generarLectura(FILE** pAC, int indice);
void generarEscritura(FILE** pAC, int indice);
void generarAsignacion(FILE** pAC, int indice);
void generarOperacion(FILE** pAC, int indice);
void generarComparacion(FILE** pAC, int indice);
void generarSalto(FILE** pAC, int indice);

void generarSFP(FILE** pAC, int indice);

//FUNCIONES VARIAS
void formatearCadena(char *cadena);
void formatearNumero(char *numero);
void eliminarComillas(char *cadena);

int esLetra(char caracter);
int esNumero(char caracter);

#endif