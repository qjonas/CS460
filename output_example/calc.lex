%{
///////////////////////////////////////////////////////////////////////////////
// Definitions 
///////////////////////////////////////////////////////////////////////////////
#include <stdlib.h>		// atoi
#include "calc.tab.h"	// Token Definitions
%}

%%
%{
///////////////////////////////////////////////////////////////////////////////
// Tokens and Actions
///////////////////////////////////////////////////////////////////////////////
%}
[ \t]+  ;     						// Whitespace
\+      { 
			printf("Token: PLUS\n");
			return PLUS; 
		}			// Plus Sign
\-      { 
			printf("Token: MINUS\n");
			return MINUS; 
		}			// Minus Sign
\*      { 
			printf("Token: MULT\n");
			return MULT; 
		}			// Multiplication Sign
\/      { 
			printf("Token: DIV\n");
			return DIV; 
		}				// Division Sign
\(      { 
			printf("Token: OPEN\n");
			return OPEN; 
		}			// Open Parenthesis
\)      { 
			printf("Token: CLOSE\n");
			return CLOSE; 
		}			// Close Parenthesis
\;      { 
			printf("Token: SEMI\n");
			return SEMI; 
		}			// Semicolon
[0-9]+  {   						// Numbers
          	printf("Token: INTEGER\n");
          	yylval.int_val = atoi(yytext);	
          	return INTEGER;
        }
.		{ 
			printf("Token: ERROR\n");
			return ERROR; 
		}			// Any other char should return an error
%%
///////////////////////////////////////////////////////////////////////////////
// User Written Code
///////////////////////////////////////////////////////////////////////////////

// User Written Code is unneeded for this application.
