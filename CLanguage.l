/******************************************************************************/
/* Definitions */
/******************************************************************************/
%{
/* Included C/C++ Libraries */
#include  <stdio.h>
#include  <stdlib.h>

/* Included Headers */
#include  "CLanguage.tab.hh"
#include  "CommandLineFlags.h"
#include  "SymbolTable.h"
#include 	"SymbolType.h"
#include  "TokenReductionsLogger.h"

/* Define YYSTYPE */
#define YYSTYPE SymbolInfo

/* Globals between flex and bison. These are declared in Globals.cpp. */
extern CommandLineFlags CL_FLAGS;
extern SymbolTable S_TABLE;
extern TokenReductionsLogger TR_LOGGER;

/* Global variables for flex. */
int column = 1;
int line = 1;
%}

/* Explicitely Declared States */
%X COMMENTS

/* Useful Regexs */
long_suffix [lL]([lL]?)
int_suffix  ([uU]{long_suffix}?|{long_suffix}[uU]?)

/******************************************************************************/
/* Rules and Actions */
/******************************************************************************/
%%

%{
/* Reserved Words */
%}
"auto"	{
	TR_LOGGER.PushToken("AUTO");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return AUTO;
}

"break"	{
	TR_LOGGER.PushToken("BREAK");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return BREAK;
}

"case"	{
	TR_LOGGER.PushToken("CASE");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return CASE;
}

"char"	{
	TR_LOGGER.PushToken("CHAR");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return CHAR;
}

"const"	{
	TR_LOGGER.PushToken("CONST");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return CONST;
}

"continue"	{
	TR_LOGGER.PushToken("CONTINUE");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return CONTINUE;
}

"default"	{
	TR_LOGGER.PushToken("DEFAULT");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return DEFAULT;
}

"do"	{
	TR_LOGGER.PushToken("DO");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return DO;
}

"double"	{
	TR_LOGGER.PushToken("DOUBLE");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return DOUBLE;
}

"else"	{
	TR_LOGGER.PushToken("ELSE");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return ELSE;
}

"enum"	{
	TR_LOGGER.PushToken("ENUM");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return ENUM;
}

"extern"	{
	TR_LOGGER.PushToken("EXTERN");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return EXTERN;
}

"float"	{
	TR_LOGGER.PushToken("FLOAT");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return FLOAT;
}

"for"	{
	TR_LOGGER.PushToken("FOR");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return FOR;
}

"goto"	{
	TR_LOGGER.PushToken("GOTO");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return GOTO;
}

"if"	{
	TR_LOGGER.PushToken("IF");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return IF;
}

"int"	{
	TR_LOGGER.PushToken("INT");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return INT;
}

"long"	{
	TR_LOGGER.PushToken("LONG");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return LONG;
}

"register"	{
	TR_LOGGER.PushToken("REGISTER");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return REGISTER;
}

"return"	{
	TR_LOGGER.PushToken("RETURN");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return RETURN;
}

"short"	{
	TR_LOGGER.PushToken("SHORT");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return SHORT;
}

"signed"	{
	TR_LOGGER.PushToken("SIGNED");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return SIGNED;
}

"sizeof"	{
	TR_LOGGER.PushToken("SIZEOF");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return SIZEOF;
}

"static"	{
	TR_LOGGER.PushToken("STATIC");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return STATIC;
}

"struct"	{
	TR_LOGGER.PushToken("STRUCT");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return STRUCT;
}

"switch"	{
	TR_LOGGER.PushToken("SWITCH");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return SWITCH;
}

"typedef"	{
	TR_LOGGER.PushToken("TYPEDEF");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return TYPEDEF;
}

"union"	{
	TR_LOGGER.PushToken("UNION");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return UNION;
}

"unsigned"	{
	TR_LOGGER.PushToken("UNSIGNED");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return UNSIGNED;
}

"void"	{
	TR_LOGGER.PushToken("VOID");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return VOID;
}

"volatile"	{
	TR_LOGGER.PushToken("VOLATILE");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return VOLATILE;
}

"while"	{
	TR_LOGGER.PushToken("WHILE");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return WHILE;
}

%{
/* Identifiers */
%}

[A-Za-z][A-Za-z0-9_]* {
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;

	// TODO: Set lval
	// TODO: Check if the identifier is a typedef
	/*
	SymbolInfo info = *(S_TABLE.SearchSymbol(yytext));
	switch (info.data_type) {
		case TYPEDEF:
			TR_LOGGER.PushToken("IDENTIFIER");
			return TYPDEF_NAME;
		default:
			TR_LOGGER.PushToken("IDENTIFIER");
			return IDENTIFIER;
	} 
	*/
	TR_LOGGER.PushToken("IDENTIFIER");
	return IDENTIFIER;
}

%{
/* Constant Values */
%}
[1-9][0-9]*{int_suffix}? { // Regular Integer
	// TODO: Set lval
	// TODO: Overflow checking
	TR_LOGGER.PushToken("INTEGER_CONSTANT");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return INTEGER_CONSTANT;
}

[0][0-7]*{int_suffix}? { // Octal Integer
	// TODO: Set lval
	// TODO: Overflow checking
	TR_LOGGER.PushToken("INTEGER_CONSTANT");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return INTEGER_CONSTANT;
}

[0][xX][0-9A-Fa-f]+{int_suffix}? { // Octal Integer
	// TODO: Set lval
	// TODO: Overflow checking
	TR_LOGGER.PushToken("INTEGER_CONSTANT");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return INTEGER_CONSTANT;
}

[0-9]+"."[0-9]*([eE]["+"|"-"]?[0-9]+)?[flFL]? |
[0-9]+"."?([eE]["+"|"-"]?[0-9]+)?[flFL]?  |
"."[0-9]+([eE]["+"|"-"]?[0-9]+)?[flFL]? {
	// TODO: Set lval
	// TODO: Overflow checking
	TR_LOGGER.PushToken("FLOATING_CONSTANT");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return FLOATING_CONSTANT;
}

\'\\?[^\']\' {
	// TODO: Set lval
	TR_LOGGER.PushToken("CHARACTER_CONSTANT");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return CHARACTER_CONSTANT;
}

\"[^\"]*\" {
	// TODO: Set lval
	TR_LOGGER.PushToken("STRING_LITERAL");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return STRING_LITERAL;
}

%{
/* Operator Symbols */
%}

"->" {
	TR_LOGGER.PushToken("PTR_OP");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return PTR_OP;
}

"++" {
	TR_LOGGER.PushToken("INC_OP");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return INC_OP;
}

"--" {
	TR_LOGGER.PushToken("DEC_OP");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return DEC_OP;
}

"<<" {
	TR_LOGGER.PushToken("LEFT_OP");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return LEFT_OP;
}

">>" {
	TR_LOGGER.PushToken("RIGHT_OP");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return RIGHT_OP;
}

"<=" {
	TR_LOGGER.PushToken("LE_OP");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return LE_OP;
}

">=" {
	TR_LOGGER.PushToken("GE_OP");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return GE_OP;
}

"==" {
	TR_LOGGER.PushToken("EQ_OP");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return EQ_OP;
}

"!=" {
	TR_LOGGER.PushToken("NE_OP");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return EQ_OP;
}

"&&" {
	TR_LOGGER.PushToken("AND_OP");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return AND_OP;
}

"||" {
	TR_LOGGER.PushToken("OR_OP");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return OR_OP;
}

"*=" {
	TR_LOGGER.PushToken("MUL_ASSIGN");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return AND_OP;
}

"/=" {
	TR_LOGGER.PushToken("DIV_ASSIGN");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return DIV_ASSIGN;
}

"%=" {
	TR_LOGGER.PushToken("MOD_ASSIGN");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return MOD_ASSIGN;
}

"+=" {
	TR_LOGGER.PushToken("ADD_ASSIGN");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return ADD_ASSIGN;
}

"-=" {
	TR_LOGGER.PushToken("SUB_ASSIGN");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return SUB_ASSIGN;
}

"<<=" {
	TR_LOGGER.PushToken("LEFT_ASSIGN");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return LEFT_ASSIGN;
}

">>=" {
	TR_LOGGER.PushToken("RIGHT_ASSIGN");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return RIGHT_ASSIGN;
}

"&=" {
	TR_LOGGER.PushToken("AND_ASSIGN");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return AND_ASSIGN;
}

"^=" {
	TR_LOGGER.PushToken("XOR_ASSIGN");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return XOR_ASSIGN;
}

"|=" {
	TR_LOGGER.PushToken("OR_ASSIGN");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return OR_ASSIGN;
}

%{
/* Punctuation */
%}
"..." {
	TR_LOGGER.PushToken("ELLIPSIS");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return ELLIPSIS;
}

";" {
	TR_LOGGER.PushToken("SEMI");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return SEMI;
}

"{" {
	TR_LOGGER.PushToken("OPEN_CURLY");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return OPEN_CURLY;
}

"}" {
	TR_LOGGER.PushToken("CLOSE_CURLY");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return CLOSE_CURLY;
}

"," {
	TR_LOGGER.PushToken("COMMA");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return COMMA;
}

"=" {
	TR_LOGGER.PushToken("EQUALS_SIGN");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return EQUALS_SIGN;
}

":" {
	TR_LOGGER.PushToken("COLON");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return COLON;
}

"(" {
	TR_LOGGER.PushToken("OPEN_PAREN");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return OPEN_PAREN;
}

")" {
	TR_LOGGER.PushToken("CLOSE_PAREN");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return CLOSE_PAREN;
}

"[" {
	TR_LOGGER.PushToken("OPEN_SQUARE");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return OPEN_SQUARE;
}

"]" {
	TR_LOGGER.PushToken("CLOSE_SQUARE");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return CLOSE_SQUARE;
}

"*" {
	TR_LOGGER.PushToken("ASTERISK");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return ASTERISK;
}

"&" {
	TR_LOGGER.PushToken("AMPERSAND");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return AMPERSAND;
}

"?" {
	TR_LOGGER.PushToken("QUESTION");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return QUESTION;
}

"|" {
	TR_LOGGER.PushToken("PIPE");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return PIPE;
}

"^" {
	TR_LOGGER.PushToken("CARAT");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return CARAT;
}

"<" {
	TR_LOGGER.PushToken("LESSER");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return LESSER;
}

">" {
	TR_LOGGER.PushToken("GREATER");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return GREATER;
}

"+" {
	TR_LOGGER.PushToken("PLUS");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return PLUS;
}

"-" {
	TR_LOGGER.PushToken("MINUS");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return MINUS;
}

"%" {
	TR_LOGGER.PushToken("PERCENT");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return PERCENT;
}

"/" {
	TR_LOGGER.PushToken("FORWARD_SLASH");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return FORWARD_SLASH;
}

"~" {
	TR_LOGGER.PushToken("TILDE");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return TILDE;
}

"!" {
	TR_LOGGER.PushToken("BANG");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return BANG;
}

"." {
	TR_LOGGER.PushToken("DOT");
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	return DOT;
}

%{
/* Comments */
%}
\/\/* {
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
	BEGIN (COMMENTS);
}

<COMMENTS>\/"*"\/ {
	TR_LOGGER.PushSourceWord(yytext);
	BEGIN (INITIAL);
}   

<COMMENTS>\n {
	TR_LOGGER.PushSourceWord(yytext);
	line++;
	column = 1;
}

<COMMENTS>. {
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
}

"//"[^"\n"] {
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
}

%{
/* Whitespace */
%}

[ \t]* {
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
}

"\n" {
	TR_LOGGER.LogSourceLine();
	TR_LOGGER.LogTokenReductions();
	line++;
	column = 1;
}

. {
	TR_LOGGER.PushSourceWord(yytext);
	column += yyleng;
}

%%
/******************************************************************************/
/* User Written Code */
/******************************************************************************/

