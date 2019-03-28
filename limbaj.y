%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "lfac_header.h"
extern FILE* yyin;
extern char* yytext;
extern int yylineno;
extern int* dimensions=(int*)malloc(sizeof(int)*20);
extern int local_dimension_counter=0;
extern char function_parameters[10][10];
extern int nr_param_fct_local=0;
extern int local_dimension_counter_aux=0;
extern int* dimensions_aux=(int*)malloc(sizeof(int)*20);
%}
%token ID TYPE BEGIN END ASSIGN NR INT_NR REAL_NR COMPLEX_LOGICAL_OPERATOR OR AND ELSE THEN PRINT
%start progr
%left '+'
%left '*'
%left '-'
%left '/'
%left '%'
%left "<<"
%left ">>"
%left "<="
%left ">="
%left "=="
%%
progr: declaredii bloc {printf("program corect sintactic\n");}
     ;

declaredii :  declaredie ';'
           | declaredii declaredie ';'
           ;

dimensions : '[' NR ']' {dimensions[local_dimension_counter]=$2; local_dimension_counter++;}
           | dimensions '[' NR ']' {dimensions[local_dimension_counter]=$3; local_dimension_counter++;}
           ;

dimensions_aux : '[' NR ']' {dimensions_aux[local_dimension_counter_aux]=$2; local_dimension_counter_aux++;}
               | dimensions_aux '[' NR ']' {dimensions_aux[local_dimension_counter]=$3; local_dimension_counter_aux++;}
               ;
declaredie : TYPE ID ';' {if (declared($2)==-1){decl_without_init($1,$2);} else {    char text[100]="the variable ";strcat(text,$2);strcat(text," was already declared");yyerror(text);} }          
           | TYPE ID '=' ID ';' {  switch(declared_with_init($1,$2,$4)) { case 1:{ char text[100]="the variable"; strcat(text,$4);strcat(text,"was not delcared or initialized yet");yyerror(text); break;} case 2:{ char text[100]="the variable"; strcat(text,$2); strcat(text,"was already declared");yyerror(text); break; }    default: {break;}  }   }
           | TYPE ID '=' ID {local_dimension_counter=0;} dimensions ';' {  switch(decl_x_dim($1,$2,$4,dimensions,local_dimension_counter)) { case 1: { char text[100]="the variable";strcat(text,$4); strcat(text,"was not delcared or initialized yet");yyerror(text); break; } case 2:{ char text[100]="the variable";strcat(text,$2); strcat(text,"was already declared"); yyerror(text); break; } case 3: { char text[100]="the variable";strcat(text,$4);strcat(text,"doesn't have that many dimensions");yyerror(test); break; } case 4: { char text[100]="the variable";strcat(text,$4); strcat(text,"have at least one of his dimensions too high set");yyerror(test); break; }  default: {break;}  }}
           | TYPE ID {local_dimension_counter=0;} dimensions ';' { switch(decl_with_init_from_x_dim($1,$2,dimensions,local_dimension_counter)){case 2:{ char text[100]="the variable";strcat(text,$2);strcat(text,"was already declared");yyerror(text); break; } default: {break;}  }}
           | TYPE ID '(' {nr_param_fct_local=0; }lista_param ')' ';' { switch(f_is_declared($1,$2,function_parameters,nr_param_fct_local)){case 1:{char text[100]="the function";strcat(text,$2);strcat(text,"was already declared");yyerror(text); break;} default: {break;}}}
           | TYPE ID '(' ')' ';' { switch(f_is_declared($1,$2,NULL,0)){case 1:{char text[100]="the function";strcat(text,$2);strcat(text,"was already declared");yyerror(text); break;} default: {break;}}}
           ;
lista_param : param
            | lista_param ','  param
            ;

param : TYPE ID {strcpy(function_parameters[nr_param_fct_local],$1); nr_param_fct_local++;}
      ;

/* bloc */
bloc : BEGIN list END
     ;

/* lista instructiuni */
list :  statement ';'
     | list statement ';'
     | declaredie ';'
     | list declaredie ';'
     ;

/* instructiune */
statement : assignment
          | statement assignment
          | for
          | for statement
          | while 
          | while statement
          | if
          | if statement
          | print
          | print statement
          ;

{//Here should be added errors in case of undeclared or unitialized variables}
assignment: ID ASSIGN ID {give_value($1,NULL,0,$3,NULL,0);$$=get_value($1);}
          | ID ASSIGN NR {give_value($1,NULL,0,$3,NULL,0);$$=get_value($1);}
          | ID ASSIGN ID {local_dimension_counter=0;} dimensions {give_value($1,NULL,0,$3,dimensions,local_dimension_counter);$$=get_value($1,NULL,0);}
          | ID dimensions {local_dimension_counter=0;} ASSIGN ID {local_dimension_counter_aux=0;} dimensions_aux {give_value($1,dimensions,local_dimension_counter,$4,dimensions_aux,local_dimension_counter_aux); $$=get_value($1,dimensions_aux.local_dimension_counter_aux);}
          | ID ASSIGN ID '(' param_list ')' {give_value($1,NULL,0,$3,NULL,0); $$=get_value($1);}
          | ID {local_dimension_counter=0;} dimensions ASSIGN ID '(' param_list ')' {give_value($1,dimensions,local_dimension_counter,$4,NULL,0);$$=get_value($1,dimensions,local_dimension_counter);}
          | ID {local_dimension_counter=0;} dimensions ASSIGN INT_NR {give_value($1,dimensions,local_dimension_counter,$4,NULL,0);$$=get_value($1,dimensions,local_dimension_counter);}
          | ID ASSIGN REAL_NR {give_value($1,NULL,0,$3,NULL,0);$$=get_value($1,NULL,0);}
          | ID {local_dimension_counter=0;} dimensions ASSIGN REAL_NR {give_value($1,dimensions,local_dimension_counter,$4,NULL,0);$$=get_value($1,dimensions,local_dimension_counter);}
          | ID ASSIGN CHAR {give_value($1,NULL,0,$3,NULL,0);$$=get_value($1,NULL,0);}
          | ID {local_dimension_counter=0;} dimensions ASSIGN CHAR {give_value($1,dimensions,local_dimension_counter,$4,NULL,0);$$=get_value($1,dimensions,local_dimension_counter);}
          | ID ASSIGN STRING
          | ID {local_dimension_counter=0;} dimensions ASSIGN STRING 
          | ID ASSIGN expresion {give_value($1,NULL,0,$3,NULL,0);$$=get_value($1,NULL,0);}
          ;

{//Here should be added errors in case of undeclared or unitialized variables}
expresion : expresion '+' expresion {void* x=addition($1,$3); $$=*x;}
          | expresion '-' expresion {void* x=substraction($1,$3); $$=*x;}
          | expresion '*' expresion {void* x=multiplication($1,$3); $$=*x;}
          | expresion '/' expresion {void* x=division($1,$3); $$=*x;}
          | NR {$$=$1;}
          | ID {$$=give_value($1,NULL,0);}
          | function {$$=$1;}
          | ID {local_dimension_counter=0;} dimensions {$$=get_value($1,dimensions,local_dimension_counter);}
          ;

function : MAX '(' expresion ',' expresion ')' {$$=max($3,$5);}
         | MIN '(' expresion ',' expresion ')' {$$=min($3,$5);}
         | MOD '(' expresion ')' {$$=module($3);}
         | GCD '(' expresion ',' expresion ')' {$$=gcd($3,$5);}
         | LCM '(' expresion ',' expresion ')' {$$=lcm($3,$5);}
         ;

param_list : NR
           | ID
           | param_list ',' NR
           | param_list ',' ID
           ;


while : WHILE '(' if_condition ')' INCEPUT element SFARSIT
      ;

for : FOR '(' assignment ',' if_condition ',' assignment ')' '{' statement '}'
    ;


if  : IF '(' if_condition ')' THEN '{' statement '}' ELSE '{' statement '}'
    | IF '(' if_condition ')' THEN '{' statement '}'
    ;

if_condition : expresion COMPLEX_LOGICAL_OPERATOR expresion if_condition {}
             | expresion if_condition {}
             | AND if_condition
             | OR if_condition
             | '(' if_condition ')'
             ;
print : PRINT '(' expresion ')' ';' {print(aux);}
      ;
%%
int yyerror(char * s){
printf("eroare: %s la linia:%d\n",s,yylineno);
}
int main(int argc, char** argv){
yyin=fopen(argv[1],"r");
yyparse();
}
