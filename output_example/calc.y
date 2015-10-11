/*****************************************************************************/
/* Definitions */
/*****************************************************************************/
%{
	// Included files
	#include <stdio.h>
	#include <stdlib.h>
	#include "../TokenReductionsLogger.h"

	// Function Declarations
	int yyparse();
	void yyerror(const char * err);
	int yylex();

	extern TokenReductionsLogger TR_LOGGER;

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
line		:	 {	
					TR_LOGGER.PushReduction("line-> ");
				}
			|	calculation line {	
					TR_LOGGER.PushReduction("line-> calculation line");
				}
			;

calculation	:	expression SEMI	{
					TR_LOGGER.PushReduction("calculation -> expression SEMI");	
					printf("Answer: %d\n", $1);
				}
			;

expression	:	term { 	
					TR_LOGGER.PushReduction("expression -> term");
					$$ = $1; 
				}
			|	expression PLUS term { 
					TR_LOGGER.PushReduction("expression -> expression PLUS term");
					$$ = $1 + $3; 
				}
			|	expression MINUS term { 
				TR_LOGGER.PushReduction("expression -> expression MINUS term");
				$$ = $1 - $3; 
				}
			;

term		:	factor { 
					TR_LOGGER.PushReduction("term -> factor");
					$$ = $1; 
				}
			|	term MULT factor { 
					TR_LOGGER.PushReduction("term -> term MULT factor");
					$$ = $1 * $3; 
				}
			|	term DIV factor { 
					TR_LOGGER.PushReduction("term -> term DIV factor");
					$$ = $1 / $3; 
				}
			|	term ERROR {
					TR_LOGGER.PushReduction("term -> term ERROR");
					exit(0);
				}
			;

factor		: 	INTEGER { 
					TR_LOGGER.PushReduction("factor -> INTEGER");
					$$ = $1; 
				}
			| 	OPEN expression CLOSE { 
					TR_LOGGER.PushReduction("factor -> OPEN expression CLOSE");
					$$ = $2; 
				}
			| 	ERROR {
					TR_LOGGER.PushReduction("factor -> ERROR");
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