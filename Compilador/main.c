#include "Utilitarios/Utilitarios.h"
#include "Archivo/Archivo.h"
#include "Tercetos/Tercetos.h"
#include "Pila/Pila.h"

extern int yyparse();
extern FILE *yyin;

/*VARIABLES GLOBALES*/
FILE *plexer = NULL;
FILE *pparser = NULL;
FILE *ptercetos = NULL;
FILE *pst = NULL;

Pila* Epila;
Pila* Tpila;
Pila* Bpila;


int main (int argc, char* argv[])
{
    char nombreArchivo[] = "./Outputs/symbol_table.txt";

    if(abrirArchivo(&yyin, argv[1], "rt") == 1)
        return 1;

    if(abrirArchivo(&plexer, argv[2], "wt") == 1)
        return 1;

    if(abrirArchivo(&pparser, argv[3], "wt") == 1)
        return 1;
    
    if(abrirArchivo(&ptercetos, argv[4], "wt") == 1)
        return 1;
    
    if(abrirArchivo(&pst, nombreArchivo, "w+t") == 1)
        return 1;

    Epila = crearPila();
    Tpila = crearPila();
    Bpila = crearPila();

    printf("INICIO DE LA COMPILACION\n");
    printf("\n. . .\n");
    
    yyparse();
    
    imprimirTercetos();

    printf("\nFIN DE LA COMPILACION\n");
    printf("\n");
    printf("Se creo el archivo: %s con todos los tokens.\n", argv[2]);
    printf("Se creo el archivo: %s con todas las reglas.\n", argv[3]);
    printf("Se creo el archivo: %s con todos los tercetos.\n", argv[4]);
    printf("Se creo el archivo: %s con todos los IDs y CTEs.\n", nombreArchivo);
    printf("\n");

    fclose(yyin);
    fclose(plexer);
    fclose(pparser);
    fclose(ptercetos);
    fclose(pst);

    destruirPila(Epila);
    destruirPila(Tpila);
    destruirPila(Bpila);

    return 0;
}