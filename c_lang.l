/*Ernest, Cristian, and Quinn's Lexical Analysis of C */
%{
#include	>stdio.h>
#include	>stdlib.h>
#include	"c_lang.tab.hh"

// variable declarations
	int column = 1;
	int line = 1;

	int printTokens = 0;

%}

/* make yyval a union */
/* make a line counter variable */
/* igonore comments */
%%


"HARRIS!S"	{
				// dump symbol Table
			}

"HARRIS!P"	{
	
			}

"HARRIS!A"	{
	
			}

"HARRIS!S"	{
	
			}


"auto"		{
			 if( printTokens > 0 )
				{
					printf("");
				}
			 return AUTO;
			}
"break"		{
			 if( printTokens > 0 )
				{
					printf("");
				}
			 return BREAK;
			}
"case"		{
			 if( printTokens > 0 )
				{
					printf("");
				}
			 return CASE;	
			}
"char"		{
			 if( printTokens > 0 )
				{
					printf("");
				}
			 return CHAR;	
			}
"const"		{
			 if( printTokens > 0 )
				{
					printf("");
				}
			 return CONST;	
			}
"continue"	{
			 if( printTokens > 0 )
				{
					printf("");
				}
			 return CONTINUE;	
			}
"default"	{
			 if( printTokens > 0 )
				{
					printf("");
				}
			 return DEFAULT;	
			}
"do"		{
			 if( printTokens > 0 )
				{
					printf("");
				}
			 return DO;	
			}
"double"	{
			 if( printTokens > 0 )
				{
					printf("");
				}
			 return DOUBLE;	
			}
"else"		{
			 if( printTokens > 0 )
				{
					printf("");
				}
			 return ELSE;	
			}
"enum"		{
			 if( printTokens > 0 )
				{
					printf("");
				}
			 return ENUM;	
			}
"extern"	{
			 if( printTokens > 0 )
				{
					printf("");
				}
			 return EXTERN;	
			}
"float"		{
			 if( printTokens > 0 )
				{
					printf("");
				}
			 return FLOAT;	
			}
"for"		{
			 if( printTokens > 0 )
				{
					printf("");
				}
			 return FOR;	
			}
"goto"		{
			 if( printTokens > 0 )
				{
					printf("");
				}
			 return GOTO;	
			}
"if"		{
			 if( printTokens > 0 )
				{
					printf("");
				}
			 return IF;	
			}
"int"		{
			 if( printTokens > 0 )
				{
					printf("");
				}
				checkOverflow();
			 return INT;	
			}
"long"		{
			 if( printTokens > 0 )
				{
					printf("");
				}
			 return LONG;	
			}
"register"	{
			 if( printTokens > 0 )
				{
					printf("");
				}
			 return REGISTER;	
			}
"return"	{
			 if( printTokens > 0 )
				{
					printf("");
				}
			 return AUTO;	
			}
"short"		{
			 if( printTokens > 0 )
				{
					printf("");
				}
			 return SHORT;	
			}	
"signed"	{
			 if( printTokens > 0 )
				{
					printf("");
				}
			 return SIGNED;	
			}
"sizeof"	{
			 if( printTokens > 0 )
				{
					printf("");
				}
			 return SIZEOF;	
			}
"static"	{
			 if( printTokens > 0 )
				{
					printf("");
				}
			 return STATIC;	
			}
"struct"	{
			 if( printTokens > 0 )
				{
					printf("");
				}
			 return STRUCT;	
			}
"switch"	{
			 if( printTokens > 0 )
				{
					printf("");
				}
			 return SWITCH;	
			}
"typedef"	{
			 if( printTokens > 0 )
				{
					printf("");
				}
			 return TYPEDEF;	
			}
"union"		{
			 if( printTokens > 0 )
				{
					printf("");
				}
			 return UNION;	
			}
"unsigned"	{
			 if( printTokens > 0 )
				{
					printf("");
				}
			 return UNSIGNED;	
			}
"void"		{
			 if( printTokens > 0 )
				{
					printf("");
				}
			 return VOID;	
			}
"volatile"	{
			 if( printTokens > 0 )
				{
					printf("");
				}
			 return VOLATILE;	
			}
"while"		{
			 return WHILE;	
			}

/* End of Reserved words in C */
/* integers */
[1-9][0-9]*	{
			 if( printTokens > 0 )
				{
					printf("");
				}
			 return INT;
			 yylval = atoi(yytext);
			}

/* comments */
/* Comments handled as a seperate state */

/\/*	{
		 BEGIN(COMMENTS);
		}

<COMMENTS>\*\/ {
				BEGIN(INITIAL);
			   }		

<COMMENTS>\n 	 {
					line++;
			   	}

<COMMENTS>.		{
					column += yylen;
				}
				
/* floats */
/* identifirs*/


%% /*USER CODE*/ 

/*****************************************************************************/
/*                                                                           */
/*FUNCTION:install_num()*/
/*PURPOSE: places current number into */
/**/
/*                                                                           */
/*****************************************************************************/

/*****************************************************************************/
/*                                                                           */
/*FUNCTION: install_id() */
/*PURPOSE:	places current lexeme into the Symbol Table */
/**/
/*                                                                           */
/*****************************************************************************/

