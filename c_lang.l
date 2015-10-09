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
					printf("AUTO");
				}
			 column += yyleng;
			 return AUTO;
			}
"break"		{
			 if( printTokens > 0 )
				{
					printf("BREAK");
				}
			 column += yyleng;
			 return BREAK;
			}
"case"		{
			 if( printTokens > 0 )
				{
					printf("CASE");
				}
			 column += yyleng;
			 return CASE;	
			}
"char"		{
			 if( printTokens > 0 )
				{
					printf("CHAR");
				}
			 column += yyleng;
			 return CHAR;	
			}
"const"		{
			 if( printTokens > 0 )
				{
					printf("CONST");
				}
			 column += yyleng;
			 return CONST;	
			}
"continue"	{
			 if( printTokens > 0 )
				{
					printf("CONTINUE");
				}
			 column += yyleng;
			 return CONTINUE;	
			}
"default"	{
			 if( printTokens > 0 )
				{
					printf("DEFAULT");
				}
			 column += yyleng;
			 return DEFAULT;	
			}
"do"		{
			 if( printTokens > 0 )
				{
					printf("DO");
				}
			 column += yyleng;
			 return DO;	
			}
"double"	{
			 if( printTokens > 0 )
				{
					printf("DOUBLE");
				}
			 column += yyleng;
			 return DOUBLE;	
			}
"else"		{
			 if( printTokens > 0 )
				{
					printf("ELSE");
				}
			 column += yyleng;
			 return ELSE;	
			}
"enum"		{
			 if( printTokens > 0 )
				{
					printf("ENUM");
				}
			 column += yyleng;
			 return ENUM;	
			}
"extern"	{
			 if( printTokens > 0 )
				{
					printf("EXTERN");
				}
			 column += yyleng;
			 return EXTERN;	
			}
"float"		{
			 if( printTokens > 0 )
				{
					printf("FLOAT");
				}
			 column += yyleng;
			 return FLOAT;	
			}
"for"		{
			 if( printTokens > 0 )
				{
					printf("FLOAT");
				}
			 column += yyleng;
			 return FOR;	
			}
"goto"		{
			 if( printTokens > 0 )
				{
					printf("GOTO");
				}
			 column += yyleng;
			 return GOTO;	
			}
"if"		{
			 if( printTokens > 0 )
				{
					printf("IF");
				}
			 column += yyleng;
			 return IF;	
			}
"int"		{
			 if( printTokens > 0 )
				{
					printf("INT");
				}
			 column += yyleng;
			 return INT;	
			}
"long"		{
			 if( printTokens > 0 )
				{
					printf("LONG");
				}
			 column += yyleng;
			 return LONG;	
			}
"register"	{
			 if( printTokens > 0 )
				{
					printf("REGISTER");
				}
			 column += yyleng;
			 return REGISTER;	
			}
"return"	{
			 if( printTokens > 0 )
				{
					printf("RETURN");
				}
			 column += yyleng;
			 return AUTO;	
			}
"short"		{
			 if( printTokens > 0 )
				{
					printf("SHORT");
				}
			 column += yyleng;
			 return SHORT;	
			}	
"signed"	{
			 if( printTokens > 0 )
				{
					printf("SIGNED");
				}
			 column += yyleng;
			 return SIGNED;	
			}
"sizeof"	{
			 if( printTokens > 0 )
				{
					printf("SIZEOF");
				}
			 column += yyleng;
			 return SIZEOF;	
			}
"static"	{
			 if( printTokens > 0 )
				{
					printf("STATIC");
				}
			 column += yyleng;
			 return STATIC;	
			}
"struct"	{
			 if( printTokens > 0 )
				{
					printf("STRUCT");
				}
			 column += yyleng;
			 return STRUCT;	
			}
"switch"	{
			 if( printTokens > 0 )
				{
					printf("SWITCH");
				}
			 column += yyleng;
			 return SWITCH;	
			}
"typedef"	{
			 if( printTokens > 0 )
				{
					printf("TYPEDEF");
				}
			 column += yyleng;
			 return TYPEDEF;	
			}
"union"		{
			 if( printTokens > 0 )
				{
					printf("UNION");
				}
			 column += yyleng;
			 return UNION;	
			}
"unsigned"	{
			 if( printTokens > 0 )
				{
					printf("UNSIGNED");
				}
			 column += yyleng;
			 return UNSIGNED;	
			}
"void"		{
			 if( printTokens > 0 )
				{
					printf("VOID");
				}
			 column += yyleng;
			 return VOID;	
			}
"volatile"	{
			 if( printTokens > 0 )
				{
					printf("VOLATILE");
				}
			 column += yyleng;
			 return VOLATILE;	
			}
"while"		{
			 if( printTokens > 0 )
				{
					printf("VWHILE");
				}
			 column += yyleng;
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

			 column += yyleng;
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
			 if( printTokens > 0 )
				{
					printf("STRING_LITERAL");
				}
			column += yyleng;
			return STRING_LITERAL;
			}
 
"->"		{
			 if( printTokens > 0 )
				{
					printf("PTR_OP");
				}
			column += yyleng;
			return PTR_OP;
			}
 
"++"		{
			 if( printTokens > 0 )
				{
					printf("INC_OP");
				}
			column += yyleng;
			return INC_OP;
			}

"--"		{
			 if( printTokens > 0 )
				{
					printf("DEC_OP");
				}
			column += yyleng;
			return DEC_OP;
			}
 
"<<"		{
			 if( printTokens > 0 )
				{
					printf("LEFT_OP");
				}
			column += yyleng;
			return LEFT_OP;
			}

">>"		{
			 if( printTokens > 0 )
				{
					printf("RIGHT_OP");
				}
			column += yyleng;
			return RIGHT_OP;
			}
 
"<="		{
			 if( printTokens > 0 )
				{
					printf("LE_OP");
				}
			column += yyleng;
			return LE_OP;
			}

">="		{
			 if( printTokens > 0 )
				{
					printf("GE_OP");
				}
			column += yyleng;
			return GE_OP;
			}

"=="		{
			 if( printTokens > 0 )
				{
					printf("EQ_OP");
				}
			column += yyleng;
			return EQ_OP;
			}

"!="		{
			 if( printTokens > 0 )
				{
					printf("NE_OP");
				}
			column += yyleng;
			return NE_OP;
			}

"&&"		{
			 if( printTokens > 0 )
				{
					printf("AND_OP");
				}
			column += yyleng;
			return AND_OP;
			}

"||"		{
			 if( printTokens > 0 )
				{
					printf("OR_OP");
				}
			column += yyleng;
			return OR_OP;
			}
 
"*=" 		{
			 if( printTokens > 0 )
				{
					printf("MUL_ASSIGN");
				}
			column += yyleng;
			return MUL_ASSIGN;
			}

"/="		{
			 if( printTokens > 0 )
				{
					printf("DIV_ASSIGN");
				}
			column += yyleng;
			return DIV_ASSIGN;
			}

"%="		{
			 if( printTokens > 0 )
				{
					printf("MOD_ASSIGN");
				}
			column += yyleng;
			return MOD_ASSIGN;
			}

"+="		{
			 if( printTokens > 0 )
				{
					printf("ADD_ASSIGN");
				}
			column += yyleng;
			return ADD_ASSIGN;
			}
"-="		{
			 if( printTokens > 0 )
				{
					printf("SUB_ASSIGN");
				}
			column += yyleng;
			return SUB_ASSIGN;
			}
 
"<<="		{
			 if( printTokens > 0 )
				{
					printf("LEFT_ASSIGN");
				}
			column += yyleng;
			return LEFT_ASSIGN;
			}

">>="		{
			 if( printTokens > 0 )
				{
					printf("RIGHT_ASSIGN");
				}
			column += yyleng;
			return RIGHT_ASSIGN;
			}

"&="		{
			 if( printTokens > 0 )
				{
					printf("AND_ASSIGN");
				}
			column += yyleng;
			return AND_ASSIGN;
			}

"^="		{
			 if( printTokens > 0 )
				{
					printf("XOR_ASSIGN");
				}
			column += yyleng;
			return XOR_ASSIGN;
			}

"|="		{
			 if( printTokens > 0 )
				{
					printf("OR_ASSIGN");
				}
			column += yyleng;
			return OR_ASSIGN;
			}
 
/* TYPEDEF_NAME*/

"..."		{
			 if( printTokens > 0 )
				{
					printf("ELIPSIS");
				}
			column += yyleng;
			return ELIPSIS;
			}
/*RANGE*/

";"		{
		 if( printTokens > 0 )
			{
				printf("SEMI");
			}
		 column += yyleng;
		 return SEMI;
		}

"{"		{
		 if( printTokens > 0 )
				{
					printf("OPEN_CURLY");
				}
			column += yyleng;
			return OPEN_CURLY;
		}

"}"		{
			 if( printTokens > 0 )
				{
					printf("CLOSE_CURLY");
				}
			column += yyleng;
			return CLOSE_CURLY;
		}

","		{
			 if( printTokens > 0 )
				{
					printf("COMMA");
				}
			column += yyleng;
			return COMMA;
		}

"="		{
		 if( printTokens > 0)
		 {
		 	printf("EQUALS_SIGN");
		 }
		    column += yyleng;
			return EQUALS_SIGN;
		}

":"		{
		 if( printTokens > 0)
		 {
		 	printf("COLON");
		 }
		    column += yyleng;
			return COLON;
		}

"("		{
		 if( printTokens > 0)
		 {
		 	printf("OPEN_PAREN");
		 }
		    column += yyleng;
			return OPEN_PAREN;
		} 

")"		{
		 if( printTokens > 0)
		 {
		 	printf("CLOSE_PAREN");
		 }
		    column += yyleng;
			return CLOSE_PAREN;
		}

"["		{
		 if( printTokens > 0)
		 {
		 	printf("");
		 }
		    column += yyleng;
			return OPEN_SQUARE;
		}

"]"		{
		 if( printTokens > 0)
		 {
		 	printf("CLOSE_SQUARE");
		 }
		    column += yyleng;
			return CLOSE_SQUARE;
		}

"*"		{
		 if( printTokens > 0)
		 {
		 	printf("ASTERISK");
		 }
		    column += yyleng;
			return ASTERISK;
		}

"&"		{
			 if( printTokens > 0 )
				{
					printf("AMPERSAND");
				}
			column += yyleng;
			return AMPERSAND;
		}

"?"		{
			 if( printTokens > 0 )
				{
					printf("QUESTION");
				}
			column += yyleng;
			return QUESTION;
		}

"|"		{
			 if( printTokens > 0 )
				{
					printf("PIPE");
				}
			column += yyleng;
			return PIPE;
		}

"^"		{
		 if( printTokens > 0)
		 {
		 	printf("CARAT");
		 }
		    column += yyleng;
			return CARAT;
		}

"<"		{
		 if( printTokens > 0)
		 {
		 	printf("LESSER");
		 }
		    column += yyleng;
			return LESSER;
		}

">"		{
		 if( printTokens > 0)
		 {
		 	printf("GREATER");
		 }
		    column += yyleng;
			return GREATER;
		}

"+"		{
		 if( printTokens > 0)
		 {
		 	printf("PLUS");
		 }
		    column += yyleng;
			return PLUS;
		}

"-"		{
		 if( printTokens > 0)
		 {
		 	printf("");
		 }
		    column += yyleng;
			return MINUS;
		}

"%"		{
		 if( printTokens > 0)
		 {
		 	printf("PERCENT");
		 }
		    column += yyleng;
			return PERCENT;
		}

"/"		{
		 if( printTokens > 0)
		 {
		 	printf("");
		 }
		    column += yyleng;
			return FORWARD_SLASH;
		} 

"~"		{
		 if( printTokens > 0)
		 {
		 	printf("TILDE");
		 }
		    column += yyleng;
			return TILDE;
		}

"!"		{
		 if( printTokens > 0)
		 {
		 	printf("BANG");
		 }
	     column += yyleng;
			return BANG;
		} 

"."		{
		 if( printTokens > 0)
		 {
		 	printf("DOT");
		 }
	     column += yyleng;
			return DOT;
		}

%{
/* comments */
/* Comments handled as a seperate state */
%}


\/\/*	{
		 if(printTokens > 0)
		 {
	     pritnf("Comment begins");
	 	 }
	     column += yyleng;
		 BEGIN (COMMENTS);
		}

<COMMENTS>\/"*"\/ 	{
						if(printTokens > 0)
						{
						printf("Comment Ended");
		    			column += yyleng;
						BEGIN (INITIAL);
						}
			   		}		

<COMMENTS>\n 		{
					line++;
					column = 1;
			   		}

<COMMENTS>.		{
					column += yyleng;
				}

/* Single Line Comments */
"//"[^"\n"]		{
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

