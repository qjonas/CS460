/*****************************************************************************/
/* Definitions */
/*****************************************************************************/
%{
	// Included files
	#include <stdio.h>
	#include <stdlib.h>

	// Function Declarations
	int yyparse();
	void yyerror(const char * err);
	int yylex();
%}

// SSTYPE union
%union {
	int int_val;
}

// Start symbol
%start line

// Tokens
%token PLUS
%token MINUS
%token MULT
%token DIV
%token OPEN
%token CLOSE
%token SEMI
%token ERROR
%token <int_val> INTEGER

// LHS that needd types
%type <int_val> calculation expression term factor

%%
/*****************************************************************************/
/* Grammar */
/*****************************************************************************/
line		:					{	printf("line -> \n"); }
			|	calculation line{	printf("line -> calculation line\n"); }
			;

calculation	:	expression SEMI	{
									printf("calculation -> expression SEMI\n");	
									printf("%d\n", $1);
								}
			;

expression	:	term { 	
					printf("expression -> term\n");
					$$ = $1; 
				}
			|	expression PLUS term { 
					printf("expression -> expression PLUS term\n");
					$$ = $1 + $3; 
				}
			|	expression MINUS term { 
				printf("expression -> expression MINUS term\n");
				$$ = $1 - $3; 
				}
			;

term		:	factor { 
					printf("term -> factor\n");
					$$ = $1; 
				}
			|	term MULT factor { 
					printf("term -> term MULT factor\n");
					$$ = $1 * $3; 
				}
			|	term DIV factor { 
					printf("term -> term DIV factor\n");
					$$ = $1 / $3; 
				}
			|	term ERROR {
					printf("term -> term ERROR\n");
					exit(0);
				}
			;

factor		: 	INTEGER { 
					printf("factor -> INTEGER\n");
					$$ = $1; 
				}
			| 	OPEN expression CLOSE { 
					printf("factor -> OPEN expression CLOSE\n");
					$$ = $2; 
				}
			| 	ERROR {
					printf("factor -> ERROR\n");
					exit(0);}
			;

%%
/*****************************************************************************/
/* User written code */
/*****************************************************************************/
int main() {
	return yyparse();
}

void yyerror(const char * err) {
	printf("%s\n", err);
}