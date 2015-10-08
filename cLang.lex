/*Ernest, Cristian, and Quinn's Lexical Analysis of C */
%{
#include	<stdio.h>
#include	"y.tab.h"

%}
/* make yyval a union */
/* make a line counter variable */
/* igonore comments */
%%

/* reserved words in C */


/**********************************/
Debugging

"HARRIS!S"	{
	
			}

""HARRIS!P"	{
	
			}

"HARRIS!A"	{
	
			}

"HARRIS!S"	{
	
			}
"

/**************************************/



"auto"		{
			 printf("auto \n");
			 return AUTO_TOK;
			}
"break"		{
			 printf("break \n");
			 return BREAK_TOK;
			}
"case"		{
			 printf("case \n");
			 return CASE_TOK;	
			}
"char"		{
			 printf("char \n");
			 return CHAR_TOK;	
			}
"const"		{
			 printf("const \n");
			 return CONST_TOK;	
			}
"continue"	{
			 printf("continue \n");
			 return CONTINUE_TOK;	
			}
"default"	{
			 printf("default \n");
			 return DEFAULT_TOK;	
			}
"do"		{
			 printf("do \n");
			 return DO_TOK;	
			}
"double"	{
			 printf("double \n");
			 return DOUBLE_TOK;	
			}
"else"		{
			 printf("else \n");
			 return ELSE_TOK;	
			}
"enum"		{
			 printf("enum \n");
			 return ENUM_TOK;	
			}
"extern"	{
			 printf("extern \n");
			 return EXTERN_TOK;	
			}
"float"		{
			 printf("float \n");
			 return FLOAT_TOK;	
			}
"for"		{
			 printf("for \n");
			 return FOR_TOK;	
			}
"goto"		{
			 printf("goto \n");
			 return GOTO_TOK;	
			}
"if"		{
			 printf("if \n");
			 return IF_TOK;	
			}
"int"		{
			 printf("int \n");
			 return INT_TOK;	
			}
"long"		{
			 printf("long \n");
			 return LONG_TOK;	
			}
"register"	{
			 printf("register \n");
			 return REGISTER_TOK;	
			}
"return"	{
			 printf("return \n");
			 return AUTO_TOK;	
			}
"short"		{
			 printf("short \n");
			 return SHORT_TOK;	
			}	
"signed"	{
			 printf("signed \n");
			 return SIGNED_TOK;	
			}
"sizeof"	{
			 printf("sizeof \n");
			 return SIZEOF_TOK;	
			}
"static"	{
			 printf("static \n");
			 return STATIC_TOK;	
			}
"struct"	{
			 printf("struct \n");
			 return STRUCT_TOK;	
			}
"switch"	{
			 printf("switch \n");
			 return SWITCH_TOK;	
			}
"typedef"	{
			 printf("typedef \n");
			 return TYPEDEF_TOK;	
			}
"union"		{
			 printf("union \n");
			 return UNION_TOK;	
			}
"unsigned"	{
			 printf("unisgned \n");
			 return UNSIGNED_TOK;	
			}
"void"		{
			 printf("void \n");
			 return VOID_TOK;	
			}
"volatile"	{
			 printf("volatile \n");
			 return VOLATILE_TOK;	
			}
"while"		{
			 printf("while \n");
			 return WHILE_TOK;	
			}
/* End of Reserved words in C */
/* integers */
[1-9][0-9]*	{
			 return INT;
			 yyval = aoti(yytext);
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
