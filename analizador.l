%{
#include <stdio.h>

typedef struct Simbolo {
    int posicion;
    char *nombre;
    int tipo;
    struct Simbolo *siguiente;
} Simbolo;
// crea la tabla de simbolos que se inicializa en null 
Simbolo *crear_tabla_simbolos();
// Agregar simbolo a la tabla de simbolos
Simbolo *agrega_simbolo(Simbolo *tabla, char *nombre);
// Buscar simbolo en la tabla
Simbolo *buscar_simbolo(Simbolo *tabla, char *nombre);
// Imprime la tabla de simbolos en formato de token
void imprimr_tabla_simbolos(Simbolo *tabla);


//

Simbolo *crear_tabla_simbolos(){
    return NULL;
}

Simbolo *agrega_simbolo(Simbolo *tabla, char *nombre){
    // Crea el nuevo simbolo
    Simbolo *nuevoSimbolo = (Simbolo *)malloc(sizeof(Simbolo));
    // Le asigna el nombre
    nuevoSimbolo->nombre = strdup(nombre);
    // Le asigna el tipo de -1
    nuevoSimbolo->tipo = -1;
    // Inserta al inicio de la lista
    nuevoSimbolo->siguiente = tabla; 
    return nuevoSimbolo;
}

Simbolo *buscar_simbolo(Simbolo *tabla, char *nombre){
    Simbolo *actual = tabla;

    while(actual != NULL){
        if(strcmp(actual->nombre, nombre) == 0) {
            return actual; // se encontro el simbolo
        } 
        actual = actual->siguiente;
    }
    return NULL; // no se encontro 
}

void imprimr_tabla_simbolos(Simbolo *tabla) {
    Simbolo *actual = tabla;
    while(actual != NULL) {
        printf("Posicion: %d, Nombre: %s, Tipo: %d\n", actual->posicion, actual->nombre, actual->tipo);

    }
}

%}

digito      [0-9]

letra       [a-zA-ZñÑ]

comentario   \[{letra}+\]

palRes Bool|Cade|Continuar|Devo|Ent|Flas|Flota|Global

simbEsp "<"|">"|"<<"|">>"|"#"|"!#"|"*"|"|"|"°"

opArim sum|rest|mult|div|mod|inc|dec|exp|dive

opRel "h"|"m"|"e"|"c"|"he"|"me"

opAsign "->"|"+->"|"-->"|"*->"|"/->"|"%->"|">>->"|"<<->"|"^->"|"&->"

identificador @({letra}|{digito})+_

cadena --.+--

ent [+-]?(0|[1-9]{digito}*)[pg]?

real ({ent}?ʼ{digito}+|{ent}[rR])

%%

{palRes}       { printf("%s es una palabra reservada\n", yytext); }
{opArim}       { printf("%s es un operador aritmetico\n", yytext); }
{opAsign}      { printf("%s es un operador de asignacion\n", yytext); }
{simbEsp}      { printf("%s es un simbolo especial\n", yytext); }
{opRel}        { printf("%s es un operador relacional\n", yytext); }
{cadena}       { printf("%s es una cadena\n", yytext); }
{comentario}   { printf("%s es un comentario\n", yytext); }
{identificador} { printf("%s es una identificador\n", yytext); }
{real}          { printf("%s es un real\n", yytext); }
{ent}           { printf("%s es un entero\n", yytext); }

[ \t\n]+       ; // Ignorar espacios, tabulaciones y saltos de línea
.              { printf("%s no es reconocido\n", yytext); }


%%

int main() {
    yylex();  // Ejecutar el analizador léxico
    return 0;
}