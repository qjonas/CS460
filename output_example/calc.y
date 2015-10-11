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
line		:					{	printf("\tline -> \n"); }
			|	calculation line{	printf("\tline -> calculation line\n"); }
			;

calculation	:	expression SEMI	{
									printf("\tcalculation -> expression SEMI\n");	
									printf("Answer: %d\n", $1);
								}
			;

expression	:	term { 	
					printf("\texpression -> term\n");
					$$ = $1; 
				}
			|	expression PLUS term { 
					printf("\texpression -> expression PLUS term\n");
					$$ = $1 + $3; 
				}
			|	expression MINUS term { 
				printf("\texpression -> expression MINUS term\n");
				$$ = $1 - $3; 
				}
			;

term		:	factor { 
					printf("\tterm -> factor\n");
					$$ = $1; 
				}
			|	term MULT factor { 
					printf("\tterm -> term MULT factor\n");
					$$ = $1 * $3; 
				}
			|	term DIV factor { 
					printf("\tterm -> term DIV factor\n");
					$$ = $1 / $3; 
				}
			|	term ERROR {
					printf("\tterm -> term ERROR\n");
					exit(0);
				}
			;

factor		: 	INTEGER { 
					printf("\tfactor -> INTEGER\n");
					$$ = $1; 
				}
			| 	OPEN expression CLOSE { 
					printf("\tfactor -> OPEN expression CLOSE\n");
					$$ = $2; 
				}
			| 	ERROR {
					printf("\tfactor -> ERROR\n");
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