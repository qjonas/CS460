/*Ernest, Cristian, and Quinn's Lexical Analysis of C */
%{
#include	<stdio.h>
#include	<stdlib.h>
#include	"c_lang.tab.hh"
#include 	"SymbolTable.h"

// variable declarations
	int column = 1;
	int line = 1;

	int printTokens = 0;

%}
%X COMMENTS
long_suffix	[lL]([lL]?)
int_suffix	([uU]{long_suffix}?|{long_suffix}[uU]?)

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
				//checkOverflow();
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

%{
/* End of Reserved words in C */
/* integers */
%}


//int
[1-9][0-9]*{int_suffix}?	|
//octal
[0][0-7]*{int_suffix}?	|
//hex
[0][xX][0-9A-Fa-f]+{int_suffix}?
		{
			 if( printTokens > 0 )
				{
					printf("");
				}
			 return INTEGER_CONSTANT;
			 yylval = atoi(yytext);
			}

[A-Za-z][A-Za-z0-9_]*
		{
			return IDENTIFIER;
			}

[0-9]+"."[0-9]*([eE]["+"|"-"]?[0-9]+)?[flFL]?	|
[0-9]+"."?([eE]["+"|"-"]?[0-9]+)?[flFL]?	|
"."[0-9]+([eE]["+"|"-"]?[0-9]+)?[flFL]? 
		{
			return FLOATING_CONSTANT;
			}
 
\'\\?[^\']\'	{
			return CHARACTER_CONSTANT;
			}
 /*ENUMERATION_CONSTANT*/ 
\"[^\"]*\" 	{
			return STRING_LITERAL;
			}
 
"->"		{
			return PTR_OP;
			}
 
"++"		{
			return INC_OP;
			}

"--"		{
			return DEC_OP;
			}
 
"<<"		{
			return LEFT_OP;
			}

">>"		{
			return RIGHT_OP;
			}
 
"<="		{
			return LE_OP;
			}

">="		{
			return GE_OP;
			}

"=="		{
			return EQ_OP;
			}

"!="		{
			return NE_OP;
			}

"&&"		{
			return AND_OP;
			}

"||"		{
			return OR_OP;
			}
 
"*=" 		{
			return MUL_ASSIGN;
			}

"/="		{
			return DIV_ASSIGN;
			}

"%="		{
			return MOD_ASSIGN;
			}

"+="		{
			return ADD_ASSIGN;
			}
"-="		{
			return SUB_ASSIGN;
			}
 
"<<="		{
			return LEFT_ASSIGN;
			}

">>="		{
			return RIGHT_ASSIGN;
			}

"&="		{
			return AND_ASSIGN;
			}

"^="		{
			return XOR_ASSIGN;
			}

"|="		{
			return OR_ASSIGN;
			}
 
/* TYPEDEF_NAME*/

"..."		{
			return ELIPSIS;
			}
/*RANGE*/

";"		{
			return SEMI;
			}

"{"		{
			return OPEN_CURLY;
			}

"}"		{
			return CLOSE_CURLY;
			}

","		{
			return COMMA;
			}

"="		{
			return EQUALS_SIGN;
			}

":"		{
			return COLON;
			}

"("		{
			return OPEN_PAREN;
			} 
")"		{
			return CLOSE_PAREN;
			}

"["		{
			return OPEN_SQUARE;
			}

"]"		{
			return CLOSE_SQUARE;
			}

"*"		{
			return ASTERISK;
			}

"&"		{
			return AMPERSAND;
			}

"?"		{
			return QUESTION;
			}

"|"		{
			return PIPE;
			}

"^"		{
			return CARAT;
			}

"<"		{
			return LESSER;
			}

">"		{
			return GREATER;
			}

"+"		{
			return PLUS;
			}

"-"		{
			return MINUS;
			}

"%"		{
			return PERCENT;
			}

"/"		{
			return FORWARD_SLASH;
			} 

"~"		{
			return TILDE;
			}

"!"		{
			return BANG;
			} 

"."		{
			return DOT;
			}

%{
/* comments */
/* Comments handled as a seperate state */
%}


\/\/*	{
		 BEGIN (COMMENTS);
		}

<COMMENTS>\/"*"\/ {
				BEGIN (INITIAL);
			   }		

<COMMENTS>\n 	 {
					line++;
			   	}

<COMMENTS>.		{
					column += yyleng;
				}
				
%{				
/* floats */
/* identifirs*/
%}

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

