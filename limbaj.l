%{-
#include <stdio.h>
#include "y.tab.h"
%}

%%
"int"|"float"|"char"|"string" 	 {yylval = strdup(yytext);return TYPE;}

"begin_progr"	 {return BEGIN;}

"end_progr"	 {return END;}

@[_a-zA-Z][_a-zA-Z0-9]* {yylval = strdup(yytext);return ID;}

-?0|([1-9][0-9]*) {yylval = atoi(yytext); return INT_NR;}

-?(0|[1-9][0-9]*)","[0-9]* {yylval = atoi(yytext); return REAL_NR;}

[0-9]+ {yylval = atoi(yytext); return NR;}

\'.\' {yylval = strdup(yytext);return CHAR;}

\".*\" {yylval = strdup(yytext);return STRING;}

"<=" | "==" | ">=" | "<<" | ">>" {yylval=strdup(yytext);return COMPLEX_LOGICAL_OPERATOR;}

":="	 {yylval = strdup(yytext);return ASSIGN;}

"OR" {yylval= strdup(yytext); return OR;}

"AND" {yylval= strdup(yytext); return AND;}

"else" {yylval= strdup(yytext); return ELSE;}

"then" {yylval = strdup(yytext); return THEN;}
"for" {yylval=strdup(yytext); return FOR;}
"while" {yylval=strdup(yytext); return WHILE;}
"if" {yylval=strdup(yytext); return IF} 
"print" {yylval=strdup(yytext); return PRINT;}
max {return MAX;}
min {return MIN;}
module {return MOD;}
gcd {return GCD;}
lcm {return LCM;}

[ \t] ;
\n 	{yylineno++;}
. {return yytext[0];}

