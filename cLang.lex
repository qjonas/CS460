/*Ernest, Cristian, and Quinn's Lexical Analysis of C */
%{
#include	<stdio.h>
#include	"y.tab.h"
int column = 1;
int line = 1;
%}


/* make yyval a union */
/* make a line counter variable */
/* igonore comments */
%%




/**********************************/
/* Debugging 				      */

/* Dump Current level of Symbol Table */
"HARRIS!S"	{
	
			}

""HARRIS!P"	{
	
			}

"HARRIS!A"	{
	
			}

"HARRIS!S"	{
	
			}
"HARRIS!"	{
	
			}

/* END OF DEBUGGING               */
/**********************************/


/**********************************/
/*Reserved Words                  */
"auto"		{
			 column += yylen;
			 printf("auto \n");
			 return AUTO_TOK;
			}
"break"		{
			 column += yylen;
			 printf("break \n");
			 return BREAK_TOK;
			}
"case"		{
			 column += yylen;
			 printf("case \n");
			 return CASE_TOK;	
			}
"char"		{
			 column += yylen;
			 printf("char \n");
			 return CHAR_TOK;	
			}
"const"		{
			 column += yylen;
			 printf("const \n");
			 return CONST_TOK;	
			}
"continue"	{
			 column += yylen;
			 printf("continue \n");
			 return CONTINUE_TOK;	
			}
"default"	{
			 column += yylen;
			 printf("default \n");
			 return DEFAULT_TOK;	
			}
"do"		{
			 column += yylen;
			 printf("do \n");
			 return DO_TOK;	
			}
"double"	{
			 column += yylen;
			 printf("double \n");
			 return DOUBLE_TOK;	
			}
"else"		{
			 column += yylen;
			 printf("else \n");
			 return ELSE_TOK;	
			}
"enum"		{
			 column += yylen;
			 printf("enum \n");
			 return ENUM_TOK;	
			}
"extern"	{
			 column += yylen;
			 printf("extern \n");
			 return EXTERN_TOK;	
			}
"float"		{
			 column += yylen;
			 printf("float \n");
			 return FLOAT_TOK;	
			}
"for"		{
			 column += yylen;
			 printf("for \n");
			 return FOR_TOK;	
			}
"goto"		{
			 column += yylen;
			 printf("goto \n");
			 return GOTO_TOK;	
			}
"if"		{
			 column += yylen;
			 printf("if \n");
			 return IF_TOK;	
			}
"int"		{
			 column += yylen;
			 printf("int \n");
			 return INT_TOK;	
			}
"long"		{
			 column += yylen;
			 printf("long \n");
			 return LONG_TOK;	
			}
"register"	{
			 column += yylen;
			 printf("register \n");
			 return REGISTER_TOK;	
			}
"return"	{
			 column += yylen;
			 printf("return \n");
			 return AUTO_TOK;	
			}
"short"		{
			 column += yylen;
			 printf("short \n");
			 return SHORT_TOK;	
			}	
"signed"	{
			 column += yylen;
			 printf("signed \n");
			 return SIGNED_TOK;	
			}
"sizeof"	{
			 column += yylen;
			 printf("sizeof \n");
			 return SIZEOF_TOK;	
			}
"static"	{
			 column += yylen;
			 printf("static \n");
			 return STATIC_TOK;	
			}
"struct"	{
			 column += yylen;
			 printf("struct \n");
			 return STRUCT_TOK;	
			}
"switch"	{
			 column += yylen;
			 printf("switch \n");
			 return SWITCH_TOK;	
			}
"typedef"	{
			 column += yylen;
			 printf("typedef \n");
			 return TYPEDEF_TOK;	
			}
"union"		{
			 column += yylen;
			 printf("union \n");
			 return UNION_TOK;	
			}
"unsigned"	{
			 column += yylen;
			 printf("unisgned \n");
			 return UNSIGNED_TOK;	
			}
"void"		{
			 column += yylen;
			 printf("void \n");
			 return VOID_TOK;	
			}
"volatile"	{
			 column += yylen;
			 printf("volatile \n");
			 return VOLATILE_TOK;	
			}
"while"		{
			 column += yylen;
			 printf("while \n");
			 return WHILE_TOK;	
			}

/* End of Reserved words in C     */
/**********************************/
/* integers */
[1-9][0-9]*	{
			 checkOverFlow();
			 column += yylen;
			 yyval = aoti(yytext);
			 return INT;
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

/*****************************************************************************/
/*                                                                           */
/*FUNCTION: checkOverFlow() */
/*PURPOSE:	Checks if the number has an overflow warning */
/**/
/*                                                                           */
/*****************************************************************************/

/*****************************************************************************/
/*                                                                           */
/*FUNCTION: checkIdLen() */
/*PURPOSE:	check if current ID name is over 31 characters */
/**/
/*                                                                           */
/*****************************************************************************/
