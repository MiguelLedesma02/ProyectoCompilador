#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../Utilitarios/Utilitarios.h"
#include "../Pila/Pila.h"

#define MAX_LINE 256
#define MAX_TRIPLES 1000


// Estructura para los tercetos
typedef struct {
    char op[MAX_LONG_STR];
    char arg1[MAX_LONG_STR];
    char arg2[MAX_LONG_STR];
    int index;
} Triple;

entrada_ts symbol_table[1000];
int symbol_count = 0;
Triple triples[MAX_TRIPLES];
int triple_count = 0;

typedef struct NodoLista {
    Triple triple;
    struct NodoLista* sig;
} NodoLista;

typedef struct {
    NodoLista* cabeza;
} ListaTriples;

typedef struct NodoEntero {
    int dato;
    struct NodoEntero* siguiente;
} NodoEntero;

typedef struct {
    NodoEntero* cabeza;
    int tamanio;
} ListaEntero;

void EnteroCrearLista(ListaEntero* lista);
void EnteroInsertarAlFinal(ListaEntero* lista, int valor);
void EnteroEliminarValor(ListaEntero* lista, int valor);
int  EnteroObtenerElemento(ListaEntero* lista, int indice);
int  EnteroObtenerTamanio(ListaEntero* lista);
void EnteroMostrarLista(ListaEntero* lista);
void EnteroLiberarLista(ListaEntero* lista);
int EnteroExisteValor(ListaEntero* lista, int valor);

// Funciones públicas
void inicializarLista(ListaTriples* lista);
int insertarTriple(ListaTriples* lista, Triple t);
Triple* buscarTriplePorIndice(ListaTriples* lista, int index);
int eliminarTriplePorIndice(ListaTriples* lista, int index);
void mostrarLista(ListaTriples lista);
void liberarLista(ListaTriples* lista);

static int etiquetas = 1;
static int lastEtiqueta = -1;

void clean_identifier(char* dest, const char* src)
{
    int i = 0;
    int j = 0;
    char temp[MAX_LONG_ID] = {0};

    //Se recorre la cadena eliminando "@", ".", "%" y " " 
    for (i = 0; src[i] && j < MAX_LONG_ID - 10; i ++)
    {
        if (src[i] != '@' && src[i] != '.' && src[i] != '%' && src[i] != ' ')
            temp[j++] = src[i];
    }

    temp[j] = '\0';

    //Si es un dígito, se le agregan dos guiones bajos
    if (temp[0] >= '0' && temp[0] <= '9')
    {
        strcpy(dest, "_");
        strncat(dest, temp, MAX_LONG_ID - 3);
    }
    //Si es un indentificador, se le agrega solo guión bajo
    else
    {
        strcpy(dest, "_");
        strncat(dest, temp, MAX_LONG_ID - 2);
    }
}


const char* resolve_reference(const char* arg)
{
    static char buffer[MAX_LONG_STR];

    if (arg[0] == '[' && arg[strlen(arg)-1] == ']')
    {
        int ref_index;
        if (sscanf(arg, "[%d]", &ref_index) == 1 && ref_index >= 0 && ref_index < triple_count)
        {
            sprintf(buffer, "_temp%d", ref_index);
            return buffer;
        }
    }

    if (strcmp(arg, "_") == 0 || strlen(arg) == 0)
        return "";
        
    strcpy(buffer, arg);
    return buffer;
}

int load_symbol_table(const char* filename)
{
    char line[MAX_LINE];

    //Se abre la Tabla de Símbolos en modo lectura
    FILE* file = fopen(filename, "r");

    if (!file)
        return 1;

    //Se inicializa en cero el contador de elementos de la Tabla de Símbolos
    symbol_count = 0;

    //Lee la Tabla de Símbolos hasta terminarla o leer 1000 registros.
    while (fgets(line, MAX_LINE, file) && symbol_count < 1000)
    {
        //Guarda los campos del registro en un vector.
        sscanf(line, "%[^|]|%[^|]|%[^|]|%u",
               symbol_table[symbol_count].nombre,
               symbol_table[symbol_count].tipoDato,
               symbol_table[symbol_count].valor,
               &symbol_table[symbol_count].longitud);

        symbol_count++;
    }

    fclose(file);

    return 0;
}

int load_triples(const char* filename)
{
    char line[MAX_LINE];

    //Se abre el archivo con la GCI (Tercetos) en modo lectura
    FILE* file = fopen(filename, "r");

    if (!file)
        return 1;

    //Se inicializa en cero el contador de tercetos
    triple_count = 0;

    while (fgets(line, MAX_LINE, file) && triple_count < MAX_TRIPLES)
    {
        int index;
        char op[MAX_LONG_ID] = "", arg1[MAX_LONG_STR] = "", arg2[MAX_LONG_STR] = "";
        int matches = sscanf(line, "[%d] (%[^,], %[^,], %[^)])", &index, op, arg1, arg2);
        
        //Guarda los campos del terceto en un vector.
        if (matches >= 3)
        {
            triples[triple_count].index = index;
            strcpy(triples[triple_count].op, op);
            strcpy(triples[triple_count].arg1, arg1);
            if (matches == 4)
                strcpy(triples[triple_count].arg2, arg2);
            else
                strcpy(triples[triple_count].arg2, "_");
            triple_count++;
        }
    }

    fclose(file);

    return 0;
}

const char* get_symbol_type(const char* name) {
    int i = 0;
    for (i; i < symbol_count; i++) {
        if (strcmp(symbol_table[i].nombre, name) == 0) {
            return symbol_table[i].tipoDato;
        }
    }
    return NULL;
}

int esOperador(int indice)
{
    //Retorna 1 si es operador y 0 si no

    if(strcmp(triples[indice].op, "+") == 0)
        return 1;
            
    if(strcmp(triples[indice].op, "-") == 0)
        return 1;

    if(strcmp(triples[indice].op, "*") == 0)
        return 1;

    if(strcmp(triples[indice].op, "/") == 0)
        return 1;

    return 0;
}

int esAsignacion(int indice)
{
    if(strcmp(triples[indice].op, ":=") == 0)
        return 1;
    
    return 0;
}

int esComparacion(int indice)
{
    if(strcmp(triples[indice].op, "CMP") == 0)
        return 1;
    
    return 0;
}

int esSalto(int indice)
{
    if(strcmp(triples[indice].op, "BGT") == 0)
        return 1;

    if(strcmp(triples[indice].op, "BGE") == 0)
        return 1;

    if(strcmp(triples[indice].op, "BLT") == 0)
        return 1;

    if(strcmp(triples[indice].op, "BLE") == 0)
        return 1;

    if(strcmp(triples[indice].op, "BEQ") == 0)
        return 1;

    if(strcmp(triples[indice].op, "BNE") == 0)
        return 1;

    if(strcmp(triples[indice].op, "BI") == 0)
        return 1;

    return 0;
}

int esEtiqueta(Pila* pilaSaltos, int indice)
{
    if(!pilaVacia(pilaSaltos) && verTope(pilaSaltos) == triples[indice].index)
        return 1;

    return 0;
}

int esREAD(int indice)
{
    if(strcmp(triples[indice].op, "READ") == 0)
        return 1;

    return 0;    
}

int generarREAD(FILE* asm_file, ListaTriples* listaOperandos, int indice)
{
    int op1;

    sscanf(triples[indice].arg1, "[%d]", &op1);

    int i;
    int symbol_tableTAM = 1000;
    char tipo[30];

    Triple* arg1 = buscarTriplePorIndice(listaOperandos, op1);
    
    for(i = 0; i < symbol_tableTAM; i ++)
    {
        if (strcmp(symbol_table[i].nombre, arg1->op) == 0)
        {
            strcpy(tipo, symbol_table[i].tipoDato);
            break;
        }
    }

    if(strcmp(tipo, "CTE_STRING") == 0)
        fprintf(asm_file, "    getString _%s\n", arg1->op);
    else
        fprintf(asm_file, "    GetFloat _%s\n", arg1->op);

    fprintf(asm_file, "    newLine\n\n");
}

int esWRITE(int indice)
{
    if(strcmp(triples[indice].op, "WRITE") == 0)
        return 1;

    return 0;    
}

void eliminarEspacios(char* src, char* dest) {
    while (*src != '\0') {
        if (*src != ' ') {
            *dest = *src;
            dest++;
        }
        src++;
    }
    *dest = '\0';
}

int esDestinoEtiquetaDeSalto(int destino)
{
    int i = 0;
    for (i; i < triple_count; i++) {
        if (esSalto(i)) {
            int salto = -1;
            if (sscanf(triples[i].arg1, "[%d]", &salto) == 1) {
                if (salto == destino) {
                    return triples[i].index; // índice del terceto salto que apunta a 'destino'
                }
            }
        }
    }
    return 0; // No es destino de salto
}

void generarWRITE(FILE* asm_file, ListaTriples* listaOperandos, int indice)
{
    static int etiquetaImprimidaAnterior = -1; // para evitar imprimir etiqueta duplicada

    int etiqueta = esDestinoEtiquetaDeSalto(triples[indice].index);

    if (etiqueta > 0 && etiqueta != etiquetaImprimidaAnterior) {
        fprintf(asm_file, "etiq%d:\n", etiqueta);
        etiquetaImprimidaAnterior = etiqueta;
    }

    int op1;
    sscanf(triples[indice].arg1, "[%d]", &op1);
    Triple* arg1 = buscarTriplePorIndice(listaOperandos, op1);
    if (arg1 == NULL) return;

    // Limpiar cadena si tiene comillas dobles
    char aux[100];
    int len = strlen(arg1->op);
    if (len >= 2 && arg1->op[0] == '"' && arg1->op[len - 1] == '"') {
        strncpy(aux, arg1->op + 1, len - 2);
        aux[len - 2] = '\0';
        strcpy(arg1->op, aux);
    }

    // Buscar tipo y nombre en tabla de símbolos
    char tipo[30] = "";
    char nombre[100] = "";
    int i = 0;
    for (i; i < symbol_count; i++) {
        if (strcmp(symbol_table[i].nombre, arg1->op) == 0) {
            strcpy(tipo, symbol_table[i].tipoDato);
            strcpy(nombre, symbol_table[i].nombre);
            break;
        }
    }

    if (strcmp(tipo, "CTE_STRING") == 0) {
    char nombreSinEspacios[256];
    eliminarEspacios(nombre, nombreSinEspacios);
    fprintf(asm_file, "    displayString _%s\n", nombreSinEspacios);
    }
    else
        fprintf(asm_file, "    DisplayFloat _%s\n", nombre);

    fprintf(asm_file, "    newLine\n\n");
}

int esDestinoEtiquetaDeBLE(int destino) {
    int i = 0;
    for (i; i < triple_count; i++) {
        if ((strcmp(triples[i].op, "BLE") == 0) || (strcmp(triples[i].op, "BLT") == 0) ||
            (strcmp(triples[i].op, "BGE") == 0) || (strcmp(triples[i].op, "BGT") == 0) ||
            (strcmp(triples[i].op, "BEQ") == 0) || (strcmp(triples[i].op, "BNE") == 0)) {
            int salto = -1;
            if (sscanf(triples[i].arg1, "[%d]", &salto) == 1) {
                if (salto == destino) {
                    return triples[i].index; // Retorna la etiqueta (índice del terceto que apunta)
                }
            }
        }
    }
    return 0; // No es destino de ninguna etiqueta BLE
}

void generarAsignacion(FILE* asm_file, ListaTriples* listaOperandos, int indice)
{
    int op1;
    int op2;

    sscanf(triples[indice].arg1, "[%d]", &op1);
    sscanf(triples[indice].arg2, "[%d]", &op2);

    Triple* arg1 = buscarTriplePorIndice(listaOperandos, op1);

    Triple* arg2 = buscarTriplePorIndice(listaOperandos, op2);

    if(arg2 != NULL) 
        fprintf(asm_file, "    fld _%s\n", arg2->op);

    fprintf(asm_file, "    fst _%s\n", arg1->op);
    fprintf(asm_file, "    ffree\n");

    return;
}

void generarComparacion(FILE* asm_file, ListaTriples* listaOperandos, int indice)
{
    int op1;
    int op2; 

    sscanf(triples[indice].arg1, "[%d]", &op1);
    sscanf(triples[indice].arg2, "[%d]", &op2);

    //TODO: Falta cuando se tienen expresiones en las comparaciones
    //TODO: Crear siempre una etiqueta aunque nunca se salte por si hay un WHILE

    Triple* arg1 = buscarTriplePorIndice(listaOperandos, op1);

    if(arg1 != NULL) 
        fprintf(asm_file, "    fld _%s\n", arg1->op);

    Triple* arg2 = buscarTriplePorIndice(listaOperandos, op2);

    if(arg2 != NULL)
        fprintf(asm_file, "    fld _%s\n", arg2->op);

    fprintf(asm_file, "    fxch \n");
    fprintf(asm_file, "    fcom \n");
    fprintf(asm_file, "    fstsw ax\n");
    fprintf(asm_file, "    sahf\n");
    fprintf(asm_file, "    ffree\n");

    return;
}

void generarSalto(FILE* asm_file, Pila* pilaSaltos, Pila* pilaEtiquetas, Pila* pilaEtiquetasBucle, ListaTriples* listaOperandos, int indice,Pila* pilaEtiquetasPendientes)
{
    int salto;
    sscanf(triples[indice].arg1, "[%d]", &salto);

    apilar(pilaSaltos, salto);
    apilar(pilaEtiquetas, salto);  // Siempre apilamos la etiqueta para imprimir luego
    apilar(pilaEtiquetasPendientes, salto);

    if (strcmp(triples[indice].op, "BGT") == 0) {
        fprintf(asm_file, "    jg etiq%d\n", salto);
    }
    else if (strcmp(triples[indice].op, "BGE") == 0) {
        fprintf(asm_file, "    jge etiq%d\n", salto);
    }
    else if (strcmp(triples[indice].op, "BLT") == 0) {
        fprintf(asm_file, "    jl etiq%d\n", salto);
    }
    else if (strcmp(triples[indice].op, "BLE") == 0) {
        fprintf(asm_file, "    jle etiq%d\n", salto);
    }
    else if (strcmp(triples[indice].op, "BEQ") == 0) {
        fprintf(asm_file, "    je etiq%d\n", salto);
    }
    else if (strcmp(triples[indice].op, "BNE") == 0) {
        fprintf(asm_file, "    jne etiq%d\n", salto);
    }
    else if (strcmp(triples[indice].op, "BI") == 0) {
        // salto incondicional, puede ser backward (bucle) o forward
        if (triples[indice].index > salto) {
            // salto atrás: desapilar etiqueta de bucle para imprimir
            int etiq_bucle = desapilar(pilaEtiquetasBucle);
            fprintf(asm_file, "    jmp etiq%d\n", etiq_bucle);
        } else {
            fprintf(asm_file, "    jmp etiq%d\n", salto);
        }
    }
}

// Función auxiliar para detectar si el terceto es parte de un OR
int esParteDeOR(int indice) {
    if (indice < 0 || indice >= triple_count) return 0;

    if (strcmp(triples[indice].op, "BLE") != 0) return 0;

    // Obtener el salto que hace BLE (la etiqueta)
    int salto;
    if (sscanf(triples[indice].arg1, "[%d]", &salto) != 1) return 0;

    // Buscar el índice del terceto con esa etiqueta
    // Suponemos que la etiqueta tiene índice igual al salto (o buscar en triples por index == salto)
    int i = 0;
    for (i; i < triple_count; i++) {
        if (triples[i].index == salto) {
            // Si el terceto i es un WRITE, entonces este BLE es parte de un OR
            if (strcmp(triples[i].op, "WRITE") == 0) {
                return 1;
            }
        }
    }

    return 0;
}

void generarEtiqueta(FILE* asm_file, Pila* pilaEtiquetas, ListaTriples* listaOperandos, int* etiquetasImpresas)
{
    if (pilaVacia(pilaEtiquetas)) return;

    int etiq = desapilar(pilaEtiquetas);

    if (etiquetasImpresas[etiq]) return;
    etiquetasImpresas[etiq] = 1;

    fprintf(asm_file, "etiq%d:\n", etiq);
}

void generarEtiquetaBucle(FILE* asm_file, int index)
{
    fprintf(asm_file, "etiq%d:\n", index);

    return;
}

void generarOperacion(FILE* asm_file, ListaTriples* listaOperandos, int indice)
{

    int op1;
    int op2; 

    sscanf(triples[indice].arg1, "[%d]", &op1);
    sscanf(triples[indice].arg2, "[%d]", &op2);

    Triple* arg1 = buscarTriplePorIndice(listaOperandos, op1);

    if(arg1 != NULL) 
        fprintf(asm_file, "    fld _%s\n", arg1->op);

    Triple* arg2 = buscarTriplePorIndice(listaOperandos, op2);

    if(arg2 != NULL)
        fprintf(asm_file, "    fld _%s\n", arg2->op);

    if(strcmp(triples[indice].op, "+") == 0)
    {
        fprintf(asm_file, "    fadd \n");
        fprintf(asm_file, "    ffree 1 \n");
    }

    if(strcmp(triples[indice].op, "-") == 0)
    {
        fprintf(asm_file, "    fsub \n");
        fprintf(asm_file, "    ffree 1 \n");
    }

    if(strcmp(triples[indice].op, "*") == 0)
    {
        fprintf(asm_file, "    fmul \n");
        fprintf(asm_file, "    ffree 1 \n");
    }

    if(strcmp(triples[indice].op, "/") == 0)
    {
        fprintf(asm_file, "    fdiv \n");
        fprintf(asm_file, "    ffree 1 \n");
    }

    return;
}

void obtenerSaltosBucles(ListaEntero* listaBucles)
{
    int i;

    for (i = 0; i < triple_count; i ++)
    {
        if(strcmp(triples[i].op, "BI") == 0)
        {
            int salto;

            sscanf(triples[i].arg1, "[%d]", &salto);

            if (salto < triples[i].index)
            {
                EnteroInsertarAlFinal(listaBucles, salto);
            }
        } 
    }
}


void generarCodigo(FILE* asm_file)
{
    int i, sig;
    int etiquetasImpresas[1000] = {0};
    Pila* pilaSaltos;
    Pila* pilaEtiquetas;
    Pila* pilaEtiquetasBucle;
    ListaTriples listaOperandos;
    ListaEntero listaBucles;
    Pila* pilaEtiquetasPendientes;
    pilaEtiquetasPendientes = crearPila();

    pilaSaltos = crearPila();
    pilaEtiquetas = crearPila();
    pilaEtiquetasBucle = crearPila();
    EnteroCrearLista(&listaBucles);
    inicializarLista(&listaOperandos);

    obtenerSaltosBucles(&listaBucles);

    for (i = 0; i < triple_count; i++)
    {   
      if (esDestinoEtiquetaDeSalto(triples[i].index) && !etiquetasImpresas[triples[i].index]) {
    fprintf(asm_file, "etiq%d:\n", triples[i].index);
    etiquetasImpresas[triples[i].index] = 1;
}

        if (EnteroExisteValor(&listaBucles, triples[i].index))
        {
            generarEtiquetaBucle(asm_file, etiquetas);
            apilar(pilaEtiquetasBucle, etiquetas);
            etiquetas ++;
        }

        if(esEtiqueta(pilaSaltos, i))
            generarEtiqueta(asm_file, pilaEtiquetas, &listaOperandos,etiquetasImpresas);

        if(esOperador(i))
            generarOperacion(asm_file, &listaOperandos, i);

        if(esAsignacion(i))
            generarAsignacion(asm_file, &listaOperandos, i);

        if(esComparacion(i))
            generarComparacion(asm_file, &listaOperandos, i);

        if(esSalto(i))
            generarSalto(asm_file, pilaSaltos, pilaEtiquetas, pilaEtiquetasBucle, &listaOperandos, i, pilaEtiquetasPendientes);

        if(esREAD(i))
            generarREAD(asm_file, &listaOperandos, i);

        if(esWRITE(i))
            generarWRITE(asm_file, &listaOperandos, i);

        if(!esEtiqueta(pilaSaltos, i) && !esOperador(i) && !esAsignacion(i) && !esComparacion(i) && !esSalto(i) && !esREAD(i) && !esWRITE(i))
            insertarTriple(&listaOperandos, triples[i]);

    }

    while(!pilaVacia(pilaEtiquetas))
        generarEtiqueta(asm_file, pilaEtiquetas, &listaOperandos,etiquetasImpresas);
    
    destruirPila(pilaSaltos);
    destruirPila(pilaEtiquetas);
    destruirPila(pilaEtiquetasBucle);
    liberarLista(&listaOperandos);
    EnteroLiberarLista(&listaBucles);
    destruirPila(pilaEtiquetasPendientes);
}

void generate_assembler(const char* output_filename)
{
    int i;

    //Se abre el archivo con el Assembler en modo escritura
    FILE* asm_file = fopen(output_filename, "w");

    if (!asm_file)
        return;

    //Se imprimen la parte inicial del Assembler
    fprintf(asm_file, "include macros2.asm\ninclude number.asm\n\n.MODEL LARGE\n.386\n.STACK 200h\n\n");

    //Se imprimen las variables
    fprintf(asm_file, ".DATA\n");

    //Se colocan todas las variables y constantes del programa
    for (i = 0; i < symbol_count; i++)
    {
        char clean_name[MAX_LONG_ID];

        //Se reescribe el nombre del ID o CTE para guardarlo como variable en Assembler
        clean_identifier(clean_name, symbol_table[i].nombre);

        if (strcmp(symbol_table[i].tipoDato, "CTE_STRING") == 0)
            fprintf(asm_file, "    %s db '%s', '$'\n", clean_name, symbol_table[i].valor);
        else
            fprintf(asm_file, "    %s dd %s\n", clean_name,
            strcmp(symbol_table[i].valor, "-") == 0 ? "?" : symbol_table[i].valor);
    }

    //Se colocan todas las variables del compilador
    int temp = 0;
    int orden = 0;
    int pivot = 0;
    int aux = 0, contAux = 0;

    for (i = 0; i < triple_count; i++)
    {
        char str[MAX_LONG_ID];

        //Las variables del compilador son:
        //@auxN donde N es un número
        //@temp
        //@orden
        //@pivot

        if(strstr(triples[i].op, "@aux") != 0)
        {
            sscanf(triples[i].op, "@aux%d", &aux);
            if(aux >= contAux)
            {
                sprintf(str, "_aux%d", aux);
                fprintf(asm_file, "    %s dd ?\n", str);

                contAux ++;
            }
        }

        if(strcmp(triples[i].op, "@temp") == 0 && temp == 0)
        {
            sprintf(str, "_temp");
            fprintf(asm_file, "    %s dd ?\n", str);

            temp = 1;
        }

        if(strcmp(triples[i].op, "@orden") == 0 && orden == 0)
        {
            sprintf(str, "_orden");
            fprintf(asm_file, "    %s dd ?\n", str);

            orden = 1;
        }

        if(strcmp(triples[i].op, "@pivot") == 0 && pivot == 0)
        {
            sprintf(str, "_pivot");
            fprintf(asm_file, "    %s dd ?\n", str);

            pivot = 1;
        }
    }

    fprintf(asm_file, ".CODE\nextrn STRLEN:proc, COPIAR:proc, CONCAT:proc\n\nSTART:\n");
    fprintf(asm_file, "    mov AX, @DATA\n    mov DS, AX\n    mov ES, AX\n");

    generarCodigo(asm_file);

    fprintf(asm_file, "    mov ax, 4C00h\n    int 21h\nEND START\n");

    fclose(asm_file);
}

int generarAssembler(const char* symbol_file, const char* triple_file, const char* output_file)
{
    //Solo carga en un vector de máximo 1000 elementos, todos los registros de la Tabla de Símbolos
    if (load_symbol_table(symbol_file) != 0)
        return 1;

    //Solo carga en un vector de máximo MAX_TRIPLES elementos, todos los tercetos
    if (load_triples(triple_file) != 0)
        return 1;

    generate_assembler(output_file);

    return 0;
}

void inicializarLista(ListaTriples* lista) {
    lista->cabeza = NULL;
}

int insertarTriple(ListaTriples* lista, Triple t) {
    NodoLista* nuevo = (NodoLista*)malloc(sizeof(NodoLista));
    if (!nuevo) return 0; // fallo de memoria

    nuevo->triple = t;
    nuevo->sig = lista->cabeza;
    lista->cabeza = nuevo;

    return 1;
}

Triple* buscarTriplePorIndice(ListaTriples* lista, int index) {
    NodoLista* actual = lista->cabeza;
    while (actual != NULL) {
        if (actual->triple.index == index)
            return &(actual->triple);
        actual = actual->sig;
    }
    return NULL;
}

int eliminarTriplePorIndice(ListaTriples* lista, int index) {
    NodoLista* actual = lista->cabeza;
    NodoLista* anterior = NULL;

    while (actual != NULL) {
        if (actual->triple.index == index) {
            if (anterior == NULL) {
                lista->cabeza = actual->sig;
            } else {
                anterior->sig = actual->sig;
            }
            free(actual);
            return 1; // eliminado con éxito
        }
        anterior = actual;
        actual = actual->sig;
    }
    return 0; // no encontrado
}

void mostrarLista(ListaTriples lista) {
    NodoLista* actual = lista.cabeza;
    while (actual != NULL) {
        printf("[%d] (%s, %s, %s)\n", actual->triple.index,
               actual->triple.op, actual->triple.arg1, actual->triple.arg2);
        actual = actual->sig;
    }
}

void liberarLista(ListaTriples* lista) {
    NodoLista* actual = lista->cabeza;
    while (actual != NULL) {
        NodoLista* temp = actual;
        actual = actual->sig;
        free(temp);
    }
    lista->cabeza = NULL;
}

void EnteroCrearLista(ListaEntero* lista) {
    lista->cabeza = NULL;
    lista->tamanio = 0;
}

void EnteroInsertarAlFinal(ListaEntero* lista, int valor) {
    NodoEntero* nuevo = (NodoEntero*)malloc(sizeof(NodoEntero));
    nuevo->dato = valor;
    nuevo->siguiente = NULL;

    if (lista->cabeza == NULL) {
        lista->cabeza = nuevo;
    } else {
        NodoEntero* actual = lista->cabeza;
        while (actual->siguiente != NULL)
            actual = actual->siguiente;
        actual->siguiente = nuevo;
    }

    lista->tamanio++;
}

void EnteroEliminarValor(ListaEntero* lista, int valor) {
    NodoEntero* actual = lista->cabeza;
    NodoEntero* anterior = NULL;

    while (actual != NULL && actual->dato != valor) {
        anterior = actual;
        actual = actual->siguiente;
    }

    if (actual == NULL) return;

    if (anterior == NULL) {
        lista->cabeza = actual->siguiente;
    } else {
        anterior->siguiente = actual->siguiente;
    }

    free(actual);
    lista->tamanio--;
}

int EnteroObtenerElemento(ListaEntero* lista, int indice) {
    if (indice < 0 || indice >= lista->tamanio) return -1;

    NodoEntero* actual = lista->cabeza;
    int i = 0;
    for (i; i < indice; i++)
        actual = actual->siguiente;

    return actual->dato;
}

int EnteroObtenerTamanio(ListaEntero* lista) {
    return lista->tamanio;
}

void EnteroMostrarLista(ListaEntero* lista) {
    NodoEntero* actual = lista->cabeza;
    printf("[");
    while (actual != NULL) {
        printf("%d", actual->dato);
        if (actual->siguiente != NULL) printf(", ");
        actual = actual->siguiente;
    }
    printf("]\n");
}

void EnteroLiberarLista(ListaEntero* lista) {
    NodoEntero* actual = lista->cabeza;
    while (actual != NULL) {
        NodoEntero* siguiente = actual->siguiente;
        free(actual);
        actual = siguiente;
    }
    lista->cabeza = NULL;
    lista->tamanio = 0;
}

int EnteroExisteValor(ListaEntero* lista, int valor) {
    NodoEntero* actual = lista->cabeza;

    while (actual != NULL) {
        if (actual->dato == valor)
            return 1; // Verdadero: el valor existe
        actual = actual->siguiente;
    }

    return 0; // Falso: no se encontró el valor
}