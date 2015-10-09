/*Ernest, Cristian, and Quinn's Lexical Analysis of C */
%{
#include	<stdio.h>
#include	<stdlib.h>
#include	"c_lang.tab.hh"

%}
/* make yyval a union */
/* make a line counter variable */
/* igonore comments */
%%


"HARRIS!S"	{
	
			}

"HARRIS!P"	{
	
			}

"HARRIS!A"	{
	
			}

"HARRIS!S"	{
	
			}


"auto"		{
			 return AUTO;
			}
"break"		{
			 return BREAK;
			}
"case"		{
			 return CASE;	
			}
"char"		{
			 return CHAR;	
			}
"const"		{
			 return CONST;	
			}
"continue"	{
			 return CONTINUE;	
			}
"default"	{
			 return DEFAULT;	
			}
"do"		{
			 return DO;	
			}
"double"	{
			 return DOUBLE;	
			}
"else"		{
			 return ELSE;	
			}
"enum"		{
			 return ENUM;	
			}
"extern"	{
			 return EXTERN;	
			}
"float"		{
			 return FLOAT;	
			}
"for"		{
			 return FOR;	
			}
"goto"		{
			 return GOTO;	
			}
"if"		{
			 return IF;	
			}
"int"		{
			 return INT;	
			}
"long"		{
			 return LONG;	
			}
"register"	{
			 return REGISTER;	
			}
"return"	{
			 return AUTO;	
			}
"short"		{
			 return SHORT;	
			}	
"signed"	{
			 return SIGNED;	
			}
"sizeof"	{
			 return SIZEOF;	
			}
"static"	{
			 return STATIC;	
			}
"struct"	{
			 return STRUCT;	
			}
"switch"	{
			 return SWITCH;	
			}
"typedef"	{
			 return TYPEDEF;	
			}
"union"		{
			 return UNION;	
			}
"unsigned"	{
			 return UNSIGNED;	
			}
"void"		{
			 return VOID;	
			}
"volatile"	{
			 return VOLATILE;	
			}
"while"		{
			 return WHILE;	
			}
%{
/* End of Reserved words in C */
/* integers */
%}
[1-9][0-9]*	{
			 return INT;
			 yylval = atoi(yytext);
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

