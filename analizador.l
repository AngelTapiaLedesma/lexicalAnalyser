%{
#include <stdio.h>

// Datos

typedef struct Literal {
    int posicion;
    char *literal;
    struct Literal *siguiente;
} Literal;

typedef struct Simbolo {
    int posicion;
    char *nombre;
    int tipo;
    struct Simbolo *siguiente;
} Simbolo;

// Prototipos

int buscar_catalogo(char *catalogo[], char *literal, int tamano);
char *token_palRes();

Simbolo *crear_tabla_simbolos();
Simbolo *agrega_simbolo(Simbolo *tabla, char *nombre);
Simbolo *buscar_simbolo(Simbolo *tabla, char *nombre);
void imprimr_tabla_simbolos(Simbolo *tabla);

Literal *crear_tabla();
Literal *agrega_literal(Literal *tabla, char *literal);
Literal *buscar_literal(Literal *tabla, char *literal);
void imprimr_tabla(Literal *tabla);

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

// Funciones para la tabla de simbolos
Simbolo *agrega_simbolo(Simbolo *tabla, char *nombre) {
    Simbolo *nuevoSimbolo = (Simbolo *)malloc(sizeof(Simbolo));
    nuevoSimbolo->nombre = strdup(nombre);
    nuevoSimbolo->tipo = -1;
    nuevoSimbolo->siguiente = NULL;

    if (tabla == NULL) {
        return nuevoSimbolo;
    }

    Simbolo *actual = tabla;
    while (actual->siguiente != NULL) {
        actual = actual->siguiente;
    }

    actual->siguiente = nuevoSimbolo;
    return tabla;
}

Simbolo *buscar_simbolo(Simbolo *tabla, char *nombre) {
    Simbolo *actual = tabla;

    while (actual != NULL) {
        if (strcmp(actual->nombre, nombre) == 0) {
            return actual;
        }
        actual = actual->siguiente;
    }
    return NULL;
}

void imprimir_tabla_simbolos(Simbolo *tabla) {
    Simbolo *actual = tabla;

    if (actual == NULL) {
        printf("La tabla de símbolos está vacía.\n");
        return;
    }

    printf("Tabla de símbolos:\n");
    while (actual != NULL) {
        printf("Nombre: %s, Tipo: %d\n", actual->nombre, actual->tipo);
        actual = actual->siguiente;
    }
}


// Tabla de cadenas y reales

// Funciones adaptadass

Literal *crear_tabla() {
    return NULL;
}

Literal *agrega_literal(Literal *tabla, char *literal) {
    Literal *nuevaLiteral = (Literal *)malloc(sizeof(Literal));
    nuevaLiteral->literal = strdup(literal);

    int posicion = 1;
    Literal *actual = tabla;
    while (actual != NULL) {
        posicion++;
        actual = actual->siguiente;
    }
    nuevaLiteral->posicion = posicion;

    nuevaLiteral->siguiente = tabla;
    return nuevaLiteral;
}

Literal *buscar_literal(Literal *tabla, char *literal) {
    Literal *actual = tabla;

    while (actual != NULL) {
        if (strcmp(actual->literal, literal) == 0) {
            return actual;
        }
        actual = actual->siguiente;
    }
    return NULL;
}

void imprimir_tabla(Literal *tabla) {
    Literal *actual = tabla;

    if (actual == NULL) {
        printf("La tabla de literales está vacía.\n");
        return;
    }

    printf("Tabla de literales:\n");
    while (actual != NULL) {
        printf("Posición: %d, Literal: %s\n", actual->posicion, actual->literal);
        actual = actual->siguiente;
    }
}

int buscar_catalogo(char *catalogo[], char *literal, int tamano) {
    for(int i = 0;i<tamano;i++){
        if(strcmp(catalogo[i], literal) == 0){
            return i;
        }
    }
}

// generador de tokens estáticas
char *token(int pos, char *yytext, char *catalogo[], int tamano){
    int valor = 0;
    valor = buscar_catalogo(catalogo,yytext,tamano);
    printf("(%i,%i)",pos,valor);
    return "Caracter";
}




%}
%option noyywrap

digito      [0-9]

letra       [a-zA-ZñÑ]

comentario   \[.+\]

palRes Bool|Cade|Continuar|Devo|Ent|Fals|Flota|Global|Haz|Mientras|Nulo|Para|Parar|Si|Sino|Ver

simbEsp "<"|">"|"<<"|">>"|"#"|"#!"|"*"|"|"|"°"

opArim sum|rest|mult|div|mod|inc|dec|exp|dive

opRel "h"|"m"|"e"|"c"|"he"|"me"

opAsign "->"|"+->"|"-->"|"*->"|"/->"|"%->"|">>->"|"<<->"|"^->"|"&->"

identificador @({letra}|{digito})+_

cadena --.+--

ent [+-]?(0|[1-9]{digito}*)[pg]?

real (({ent}?'{digito}+)|({ent}[rR]))

%%

{palRes}       { token(0, yytext, palRes, 16); printf(" %s es una palabra reservada\n", yytext);}
{opArim}       {token(3, yytext, opArim, 9); printf(" %s es un operador aritmetico\n", yytext); }
{opAsign}      {token(5, yytext, opAsign, 10); printf(" %s es un operador de asignacion\n", yytext); }
{simbEsp}      {token(1, yytext, simbEsp, 9); printf(" %s es un simbolo especial\n", yytext); }
{opRel}        {token(4, yytext, opRel, 6); printf(" %s es un operador relacional\n", yytext); }
{cadena}       { printf("%s es una cadena\n", yytext); }
{comentario}   { printf("%s es un comentario\n", yytext); }
{identificador} { printf("%s es una identificador\n", yytext); } // dinámico
{real}          { printf("%s es un real\n", yytext); }
{ent}           { printf("%s es un entero\n", yytext); }

[ \t\n\r]+ ; // Ignorar espacios, tabulaciones y saltos de      línea
.              { printf("%s no es reconocido\n", yytext); }


%%

int main(int argc, char **argv) {
    // Verificar si se proporcionó un archivo de entrada
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r"); // Abrir el archivo en modo lectura
        if (!file) {
            perror("Error al abrir el archivo");
            return 1;
        }
        yyin = file; // Redirigir la entrada de yylex al archivo
    } else {
        printf("Uso: %s <archivo_de_entrada>\n", argv[0]);
        return 1;
    }

    // Creación de las tablas dinámicas
    Simbolo *tabla_simbolos = crear_tabla_simbolos();
    Literal *tabla_cadenas = crear_tabla();
    Literal *tabla_reales = crear_tabla();

    yylex();  // Ejecutar el analizador léxico

    // Cerrar el archivo después de usarlo
    fclose(yyin);

    return 0;
}