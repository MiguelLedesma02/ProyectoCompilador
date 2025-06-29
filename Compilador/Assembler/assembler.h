#include "../Lista/Lista.h"
#include "../Tercetos/Tercetos.h"

void generarDataAsm(FILE* f, tLista* listaSimbolos);
void generarCodigoDesdeTercetos(FILE* f);
void generarAsignacion(FILE* f, Terceto* t, int indiceTerceto);
void generarOperacionAritmetica(FILE* f, Terceto* t, int indiceTerceto);
void generarComparacion(FILE* f, Terceto* t);
void generarSaltoCondicional(FILE* f, Terceto* t, int indiceTerceto);
void generarSaltoIncondicional(FILE* f, Terceto* t);
void generarWhile(FILE* f, Terceto* t, int indiceTerceto);
void generarIf(FILE* f, Terceto* t, int indiceTerceto);
void generarElse(FILE* f, Terceto* t, int indiceTerceto);
void generarWrite(FILE* f, Terceto* t);
void generarRead(FILE* f, Terceto* t);