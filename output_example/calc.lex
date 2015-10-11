%{
///////////////////////////////////////////////////////////////////////////////
// Definitions 
///////////////////////////////////////////////////////////////////////////////
#include <stdlib.h>		// atoi
#include "calc.tab.h"	// Token Definitions
#include <vector>		
#include <string>
#include <iostream>

using namespace std;

vector<string> source_words;
%}

%%
%{
///////////////////////////////////////////////////////////////////////////////
// Tokens and Actions
///////////////////////////////////////////////////////////////////////////////
%}
[ \t]+  {source_words.push_back(string(yytext));}					// Whitespace
\+      {

			printf("Token : PLUS\n");
			source_words.push_back(string("+"));
			return PLUS; 
		}			// Plus Sign
\-      { 
			printf("Token : MINUS\n");
			source_words.push_back(string("-"));
			return MINUS; 
		}			// Minus Sign
\*      { 
			printf("Token : MULT\n");
			source_words.push_back(string("*"));
			return MULT; 
		}			// Multiplication Sign
\/      { 
			printf("Token : DIV\n");
			source_words.push_back(string("/"));
			return DIV; 
		}				// Division Sign
\(      { 
			printf("Token : OPEN\n");
			source_words.push_back(string("("));
			return OPEN; 
		}			// Open Parenthesis
\)      { 
			printf("Token : CLOSE\n");
			source_words.push_back(string(")"));
			return CLOSE; 
		}			// Close Parenthesis
\;      { 
			printf("Token : SEMI\n");
			source_words.push_back(string(";"));
			return SEMI; 
		}			// Semicolon
[0-9]+  {   						// Numbers
          	printf("Token : INTEGER\n");
          	yylval.int_val = atoi(yytext);	
          	source_words.push_back(string(yytext));
          	return INTEGER;
        }
\n 		{
	printf("Source: ");
	for(string word : source_words) {
		cout << word;
	}
	cout << endl;
	source_words.clear();
}
.		{ 
			printf("Token : ERROR\n");
			return ERROR; 
		}			// Any other char should return an error
%%
///////////////////////////////////////////////////////////////////////////////
// User Written Code
///////////////////////////////////////////////////////////////////////////////

// User Written Code is unneeded for this application.
