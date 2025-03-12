%{
#include <stdio.h>
%}

digito      [0-9]

letra       [a-zA-ZñÑ]

comentario   \[{letra}+\]

palRes Bool|Cade|Continuar|Devo|Ent|Flas|Flota|Global

opArim sum|rest|mult|div|mod|inc|dec|exp|dive

opAsign "->"|"+->"|"-->"|"*->"|"/->"|"%->"|">>->"|"<<->"|"^->"|"&->"

simbEsp "<"|">"|"<<"|">>"|"#"|"!#"|"*"|"|"|"°"

opRel "h"|"m"|"e"|"c"|"he"|"me"

identificador @{letra}+({letra}|{digito})*_

cadena --.+--

ent [+-]?(0|[1-9]+{digito}*)

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


%

int main() {
    yylex();  // Ejecutar el analizador léxico
    return 0;
}