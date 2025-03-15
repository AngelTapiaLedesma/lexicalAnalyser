%{
#include <stdio.h>


// Prototipos
int buscar_catalogo(char *catalogo[], char *literal, int tamano);
char *token_palRes();
// Catalogos

char *palRes[16] = {
    "Bool",
    "Cade",
    "Continuar",
    "Devo",
    "Ent",
    "Fals",
    "Flota",
    "Global",
    "Haz",
    "Mientras",
    "Nulo",
    "Para",
    "Parar",
    "Si",
    "Sino",
    "Ver"
};

char *opArim[9] = {
    "sum",
    "rest",
    "mult",
    "div",
    "mod",
    "inc",
    "dec",
    "exp",
    "dive"
};

char *opAsign[10] = {
    "->",
    "+->",
    "-->",
    "*->",
    "/->",
    "%->",
    ">>->",
    "<<->",
    "^->",
    "&->"
};

char *simbEsp[9] = {
    "<",
    ">",
    "<<",
    ">>",
    "#",
    "!#",
    "*",
    "|",
    "°"
};

char *opRel[6] = {
    "h",
    "m",
    "e",
    "c",
    "he",
    "me"
};

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

// Tabla de cadenas y reales
// Se usan las mismas funciones ya que las tablas tienen la misma estrcutura, la unica diferenia
//es que En el parametro tabla hay que pasar su respectivo parametro
typedef struct Literal {
    int posicion;
    char *literal;
    struct Literal *siguiente;
} Literal;
// crea la tabla de simbolos que se inicializa en null 
Literal *crear_tabla();
// Agregar simbolo a la tabla de simbolos
Literal *agrega_literal(Literal *tabla, char *literal);
// Buscar simbolo en la tabla
Literal *buscar_literal(Literal *tabla, char *literal);
// Imprime la tabla de simbolos en formato de token
void imprimr_tabla(Literal *tabla);

// Funciones adaptadass

Literal *crear_tabla(){
    return NULL;
}

Literal *agrega_literal(Literal *tabla, char *literal){
    // Crea el nuevo simbolo
    Literal *nuevaLiteral = (Literal *)malloc(sizeof(Literal));
    // Le asigna el nombre
    nuevaLiteral->literal = strdup(literal);
    // Inserta al inicio de la lista
    nuevaLiteral->siguiente = tabla; 
    return nuevaLiteral;
}

Literal *buscar_literal(Literal *tabla, char *literal){
    Literal *actual = tabla;

    while(actual != NULL){
        if(strcmp(actual->literal, literal) == 0) {
            return actual; // se encontro el simbolo
        } 
        actual = actual->siguiente;
    }
    return NULL; // no se encontro 
}

void imprimr_tabla(Literal *tabla) {
    Literal *actual = tabla;
    while(actual != NULL) {
        printf("Posicion: %d, Literal: %s\n", actual->posicion, actual->literal);
    }
}

int buscar_catalogo(char *catalogo[], char *literal, int tamano) {
    for(int i = 0;i<tamano;i++){
        if(strcmp(catalogo[i], literal) == 0){
            return i;
        }
    }
}

// generador de tokens
char *token_palRes(int pos, char *yytext, char *catalogo[], int tamano){
    int valor = 0;
    valor = buscar_catalogo(catalogo,yytext,tamano);
    printf("(%i,%i)",pos,valor);
    return "Caracter";
}




%}
%option noyywrap
digito      [0-9]

letra       [a-zA-ZñÑ]

comentario   \[{letra}+\]

palRes Bool|Cade|Continuar|Devo|Ent|Fals|Flota|Global|Haz|Mientras|Nulo|Para|Parar|Si|Sino|Ver

simbEsp "<"|">"|"<<"|">>"|"#"|"!#"|"*"|"|"|"°"

opArim sum|rest|mult|div|mod|inc|dec|exp|dive

opRel "h"|"m"|"e"|"c"|"he"|"me"

opAsign "->"|"+->"|"-->"|"*->"|"/->"|"%->"|">>->"|"<<->"|"^->"|"&->"

identificador @({letra}|{digito})+_

cadena --.+--

ent [+-]?(0|[1-9]{digito}*)[pg]?

real ({ent}?ʼ{digito}+|{ent}[rR])

%%

{palRes}       { printf("%s es una palabra reservada\n", yytext); token_palRes(0, yytext, palRes, 16);  }
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
    // Creacion de las tablas dinamicas
    Simbolo *tabla_simbolos = crear_tabla_simbolos();
    Literal *tabla_cadenas = crear_tabla();
    Literal *tabla_reales = crear_tabla();

    yylex();  // Ejecutar el analizador léxico
    return 0;
}