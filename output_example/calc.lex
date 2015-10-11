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

vector<string> source_words;
%}

%%
%{
///////////////////////////////////////////////////////////////////////////////
// Tokens and Actions
///////////////////////////////////////////////////////////////////////////////
%}
[ \t]+  {
	TokenReductionsLogger::GetInstance().PushSourceWord(string(yytext));
}

\+ { 
	TokenReductionsLogger::GetInstance().PushSourceWord(string(yytext));
	TokenReductionsLogger::GetInstance().PushToken("PLUS");
	return PLUS; 
}			

\- { 
	TokenReductionsLogger::GetInstance().PushSourceWord(string(yytext));
	TokenReductionsLogger::GetInstance().PushToken("MINUS");
	return MINUS; 
}

\* { 
	TokenReductionsLogger::GetInstance().PushSourceWord(string(yytext));
	TokenReductionsLogger::GetInstance().PushToken("MULT");
	return MULT; 
}		

\/ { 
	TokenReductionsLogger::GetInstance().PushSourceWord(string(yytext));
	TokenReductionsLogger::GetInstance().PushToken("DIV");
	return DIV; 
}				

\( {
	TokenReductionsLogger::GetInstance().PushSourceWord(string(yytext)); 
	TokenReductionsLogger::GetInstance().PushToken("OPEN");
	return OPEN; 
}
\) { 
	TokenReductionsLogger::GetInstance().PushSourceWord(string(yytext));
	TokenReductionsLogger::GetInstance().PushToken("CLOSE");
	return CLOSE; 
}			

\; {
	TokenReductionsLogger::GetInstance().PushSourceWord(string(yytext)); 
	TokenReductionsLogger::GetInstance().PushToken("SEMI");
	return SEMI; 
}

[0-9]+ {
	TokenReductionsLogger::GetInstance().PushSourceWord(string(yytext));
	TokenReductionsLogger::GetInstance().PushToken("INTEGER");
	yylval.int_val = atoi(yytext);	
	return INTEGER;
}

\n {
	TokenReductionsLogger::GetInstance().LogSourceLine();
	TokenReductionsLogger::GetInstance().LogTokenReductions();
}
. { 
	TokenReductionsLogger::GetInstance().PushSourceWord(string(yytext));
	TokenReductionsLogger::GetInstance().PushToken("ERROR");
	return ERROR; 
}
%%
///////////////////////////////////////////////////////////////////////////////
// User Written Code
///////////////////////////////////////////////////////////////////////////////

// User Written Code is unneeded for this application.
