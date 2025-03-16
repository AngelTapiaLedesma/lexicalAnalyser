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
char *token(int pos, char *yytext, char *catalogo[], int tamano);

void imprimir_tabla_simbolos(Simbolo *tabla);
Simbolo *crear_tabla_simbolos();
Simbolo *agrega_simbolo(Simbolo *tabla, char *nombre);
int buscar_simbolo(Simbolo *tabla, char *nombre);

Literal *crear_tabla();
Literal *agrega_literal(Literal *tabla, char *literal);
int buscar_literal(Literal *tabla, char *literal);
void imprimir_tabla(Literal *tabla);

// Creación de las tablas dinámicas
Simbolo *tabla_simbolos = NULL;
Literal *tabla_cadenas = NULL;
Literal *tabla_reales = NULL;
Literal *tabla_enteros = NULL;

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
    //imprimir_tabla_simbolos(tabla);
    int res = buscar_simbolo(tabla,nombre);
    //printf("%d\n",res);
    if( res == -1){ // Checa si el elemento NO existe, para crearlo
        Simbolo *nuevoSimbolo = (Simbolo *)malloc(sizeof(Simbolo));
        nuevoSimbolo->nombre = strdup(nombre);
        nuevoSimbolo->tipo = -1;
        nuevoSimbolo->siguiente = NULL;

        if (tabla == NULL) {
            return nuevoSimbolo;
        }
        Simbolo *actual = tabla; // temporal que almacena el inicio de la tabla
        while (actual->siguiente != NULL) {
            actual = actual->siguiente;
        }
        actual->siguiente = nuevoSimbolo; // se inserta al final de la tabla
    }
    return tabla; // Si existe, regresa la tabla, si no existe lo crea y también regresa la tabla
}

int buscar_simbolo(Simbolo *tabla, char *nombre) {
    Simbolo *actual = tabla;
    int valor = 0;
    while (actual != NULL) {
        if (strcmp(actual->nombre, nombre) == 0) {
            return valor; // Retornamos el valor 
        }
        actual = actual->siguiente;
        valor++;
    }
    return -1;
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

Literal *agrega_literal(Literal *tabla, char *literal) {
    //imprimir_tabla_simbolos(tabla);
    int res = buscar_literal(tabla,literal);
    //printf("%d\n",res);
    if( res == -1){ // Checa si el elemento NO existe, para crearlo
        Literal *NuevaLiteral = (Literal *)malloc(sizeof(Literal));
        NuevaLiteral->literal = strdup(literal);
        NuevaLiteral->siguiente = NULL;

        if (tabla == NULL) {
            return NuevaLiteral;
        }

        Literal *actual = tabla; // temporal que almacena el inicio de la tabla
        while (actual->siguiente != NULL) {
            actual = actual->siguiente;
        }

        actual->siguiente = NuevaLiteral; // se inserta al final de la tabla
    }
    return tabla; // Si existe, regresa la tabla, si no existe lo crea y también regresa la tabla
}

int buscar_literal(Literal *tabla, char *literal) {
    Literal *actual = tabla;
    int valor = 0;
    while (actual != NULL) {
        if (strcmp(actual->literal, literal) == 0) {
            return valor; // Retornamos el valor 
        }
        actual = actual->siguiente;
        valor++;
    }
    return -1;
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

// tokens dinámicos
char *token_simbolos(int pos, char *nombre, Simbolo **tabla) {
    *tabla = agrega_simbolo(*tabla, nombre);
    int valor = buscar_simbolo(*tabla, nombre);
    printf("(%i,%i)", pos, valor);
    return "Caracter";
}

char *token_literales(int pos, char *nombre, Literal **tabla) {
    *tabla = agrega_literal(*tabla, nombre);
    int valor = buscar_literal(*tabla, nombre);
    printf("(%i,%i)", pos, valor);
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

{palRes}       {token(0, yytext, palRes, 16); printf(" %s es una palabra reservada\n", yytext);}
{opArim}       {token(3, yytext, opArim, 9); printf(" %s es un operador aritmetico\n", yytext); }
{opAsign}      {token(5, yytext, opAsign, 10); printf(" %s es un operador de asignacion\n", yytext); }
{simbEsp}      {token(1, yytext, simbEsp, 9); printf(" %s es un simbolo especial\n", yytext); }
{opRel}        {token(4, yytext, opRel, 6); printf(" %s es un operador relacional\n", yytext); }
{cadena}       {token_literales(8, yytext, &tabla_cadenas);printf("%s es una cadena\n", yytext); }
{comentario}   {printf("%s es un comentario\n", yytext); }
{identificador} {token_simbolos(2, yytext, &tabla_simbolos); printf("%s es una identificador\n", yytext); }
{real}          {token_literales(8, yytext, &tabla_reales); printf("%s es un real\n", yytext); }
{ent}           {token_literales(8, yytext, &tabla_enteros);printf("%s es un entero\n", yytext); }
[ \t\n\r]+ ; // Ignorar espacios, tabulaciones y saltos de      línea
.              {printf("%s no es reconocido\n", yytext); }
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
    yylex();  // Ejecutar el analizador léxico
    // Cerrar el archivo después de usarlo
    fclose(yyin);
    return 0;
}