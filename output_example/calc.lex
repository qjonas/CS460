%{
///////////////////////////////////////////////////////////////////////////////
// Definitions 
///////////////////////////////////////////////////////////////////////////////
#include <stdlib.h>		// atoi
#include "calc.tab.h"	// Token Definitions
#include <vector>		
#include <string>
#include <iostream>
#include "../TokenReductionsLogger.h"

using namespace std;

extern TokenReductionsLogger TR_LOGGER;

%}

%%
%{
///////////////////////////////////////////////////////////////////////////////
// Tokens and Actions
///////////////////////////////////////////////////////////////////////////////
%}
[ \t]+  {
	TR_LOGGER.PushSourceWord(string(yytext));
}

\+ { 
	TR_LOGGER.PushSourceWord(string(yytext));
	TR_LOGGER.PushToken("PLUS");
	return PLUS; 
}			

\- { 
	TR_LOGGER.PushSourceWord(string(yytext));
	TR_LOGGER.PushToken("MINUS");
	return MINUS; 
}

\* { 
	TR_LOGGER.PushSourceWord(string(yytext));
	TR_LOGGER.PushToken("MULT");
	return MULT; 
}		

\/ { 
	TR_LOGGER.PushSourceWord(string(yytext));
	TR_LOGGER.PushToken("DIV");
	return DIV; 
}				

\( {
	TR_LOGGER.PushSourceWord(string(yytext)); 
	TR_LOGGER.PushToken("OPEN");
	return OPEN; 
}
\) { 
	TR_LOGGER.PushSourceWord(string(yytext));
	TR_LOGGER.PushToken("CLOSE");
	return CLOSE; 
}			

\; {
	TR_LOGGER.PushSourceWord(string(yytext)); 
	TR_LOGGER.PushToken("SEMI");
	return SEMI; 
}

[0-9]+ {
	TR_LOGGER.PushSourceWord(string(yytext));
	TR_LOGGER.PushToken("INTEGER");
	yylval.int_val = atoi(yytext);	
	return INTEGER;
}

\n {
	TR_LOGGER.LogSourceLine();
	TR_LOGGER.LogTokenReductions();
}
. { 
	TR_LOGGER.PushSourceWord(string(yytext));
	TR_LOGGER.PushToken("ERROR");
	return ERROR; 
}
%%
///////////////////////////////////////////////////////////////////////////////
// User Written Code
///////////////////////////////////////////////////////////////////////////////

// User Written Code is unneeded for this application.
