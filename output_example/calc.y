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
					TokenReductionsLogger::GetInstance().PushReduction("line-> ");
				}
			|	calculation line {	
					TokenReductionsLogger::GetInstance().PushReduction("line-> calculation line");
				}
			;

calculation	:	expression SEMI	{
					TokenReductionsLogger::GetInstance().PushReduction("calculation -> expression SEMI");	
					printf("Answer: %d\n", $1);
				}
			;

expression	:	term { 	
					TokenReductionsLogger::GetInstance().PushReduction("expression -> term");
					$$ = $1; 
				}
			|	expression PLUS term { 
					TokenReductionsLogger::GetInstance().PushReduction("expression -> expression PLUS term");
					$$ = $1 + $3; 
				}
			|	expression MINUS term { 
				TokenReductionsLogger::GetInstance().PushReduction("expression -> expression MINUS term");
				$$ = $1 - $3; 
				}
			;

term		:	factor { 
					TokenReductionsLogger::GetInstance().PushReduction("term -> factor");
					$$ = $1; 
				}
			|	term MULT factor { 
					TokenReductionsLogger::GetInstance().PushReduction("term -> term MULT factor");
					$$ = $1 * $3; 
				}
			|	term DIV factor { 
					TokenReductionsLogger::GetInstance().PushReduction("term -> term DIV factor");
					$$ = $1 / $3; 
				}
			|	term ERROR {
					TokenReductionsLogger::GetInstance().PushReduction("term -> term ERROR");
					exit(0);
				}
			;

factor		: 	INTEGER { 
					TokenReductionsLogger::GetInstance().PushReduction("factor -> INTEGER");
					$$ = $1; 
				}
			| 	OPEN expression CLOSE { 
					TokenReductionsLogger::GetInstance().PushReduction("factor -> OPEN expression CLOSE");
					$$ = $2; 
				}
			| 	ERROR {
					TokenReductionsLogger::GetInstance().PushReduction("factor -> ERROR");
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