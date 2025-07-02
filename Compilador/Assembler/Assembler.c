#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../Utilitarios/Utilitarios.h"

#define MAX_LINE 256
#define MAX_TRIPLES 1000

// Estructura para los tercetos
typedef struct {
    char op[MAX_LONG_ID];
    char arg1[MAX_LONG_STR];
    char arg2[MAX_LONG_STR];
    int index;
} Triple;

entrada_ts symbol_table[1000];
int symbol_count = 0;
Triple triples[MAX_TRIPLES];
int triple_count = 0;

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
        strcpy(dest, "__");
        strncat(dest, temp, MAX_LONG_ID - 3);
    }
    //Si es un indentificador, se le agrega solo guión bajo
    else
    {
        strcpy(dest, "_");
        strncat(dest, temp, MAX_LONG_ID - 2);
    }
}

const char* resolve_reference(const char* arg) {
    static char buffer[MAX_LONG_STR];
    if (arg[0] == '[' && arg[strlen(arg)-1] == ']') {
        int ref_index;
        if (sscanf(arg, "[%d]", &ref_index) == 1 && ref_index >= 0 && ref_index < triple_count) {
            sprintf(buffer, "_temp%d", ref_index);
            return buffer;
        }
    }
    if (strcmp(arg, "_") == 0 || strlen(arg) == 0) {
        return "";
    }
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

    //TODO: Esto está mal. No se tiene que crear una variable por terceto
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

    for (i = 0; i < triple_count; i++)
    {
        char op1[MAX_LONG_ID], op2[MAX_LONG_ID];
        const char* raw1 = resolve_reference(triples[i].arg1);
        const char* raw2 = resolve_reference(triples[i].arg2);

        if (strlen(raw1) > 0) clean_identifier(op1, raw1);
        else strcpy(op1, "");
        if (strlen(raw2) > 0) clean_identifier(op2, raw2);
        else strcpy(op2, "");

        if (strcmp(triples[i].op, "+") == 0 || strcmp(triples[i].op, "-") == 0 ||
            strcmp(triples[i].op, "*") == 0 || strcmp(triples[i].op, "/") == 0) {
            fprintf(asm_file, "    fld %s\n", op1);
            if (strcmp(triples[i].op, "+") == 0) fprintf(asm_file, "    fadd %s\n", op2);
            else if (strcmp(triples[i].op, "-") == 0) fprintf(asm_file, "    fsub %s\n", op2);
            else if (strcmp(triples[i].op, "*") == 0) fprintf(asm_file, "    fmul %s\n", op2);
            else fprintf(asm_file, "    fdiv %s\n", op2);
            char temp[MAX_LONG_ID];
            sprintf(temp, "_temp%d", i);
            fprintf(asm_file, "    fstp %s\n", temp);
        } else if (strcmp(triples[i].op, ":=") == 0) {
            fprintf(asm_file, "    fld %s\n", op1);
            fprintf(asm_file, "    fstp %s\n", op2);
        } else if (strcmp(triples[i].op, "WRITE") == 0) {
            fprintf(asm_file, "    displayString %s\n", op1);
            fprintf(asm_file, "    newLine 1\n");
        } else if (strcmp(triples[i].op, "READ") == 0) {
            fprintf(asm_file, "    GetFloat %s\n", op1);
        }
    }

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