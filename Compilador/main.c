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
FILE *ptemp = NULL;

Pila* Epila;
Pila* Tpila;

Pila* ETDpila;
Pila* TTDpila;

Pila* ANDPila;
Pila* ORPila;
Pila* AUXPila;

Pila* Bpila;
Pila* Vpila;


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

    if(abrirArchivo(&ptemp, "temp.txt", "wt") == 1)
        return 1;

    Epila = crearPila();
    Tpila = crearPila();

    ETDpila = crearPila();
    TTDpila = crearPila();

    ANDPila = crearPila();
    ORPila = crearPila();
    AUXPila = crearPila();

    Bpila = crearPila();
    Vpila = crearPila();

    printf("INICIO DE LA COMPILACION\n");
    printf("\n. . .\n");
    
    yyparse();
    
    printf("\nFIN DE LA COMPILACION\n");
    printf("\n");
    printf("Se creo el archivo: %s con todos los tokens.\n", argv[2]);
    printf("Se creo el archivo: %s con todas las reglas.\n", argv[3]);
    printf("Se creo el archivo: %s con todos los tercetos.\n", argv[4]);
    printf("Se creo el archivo: %s con todos los IDs y CTEs.\n", nombreArchivo);
    printf("\n");

    fclose(yyin);
    fclose(plexer);
    remove("temp.txt");

    destruirPila(Epila);
    destruirPila(Tpila);

    destruirPila(ETDpila);
    destruirPila(TTDpila); 

    destruirPila(ANDPila);
    destruirPila(ORPila);
    destruirPila(AUXPila);

    destruirPila(Bpila);
    destruirPila(Vpila);

    return 0;
}