/******************************************************************************/
/* Definitions */
/******************************************************************************/
%{ 
/* Included C/C++ Libraries */
#include  <cstdio>
#include  <cstdlib>
#include 	<cerrno>
#include 	<iostream>
#include 	<string>

/* Included Headers */
#include  "CLanguage.tab.hh"
#include  "CommandLineFlags.h"
#include  "SymbolTable.h"
#include  "TokenReductionsLogger.h"
#include 	"SymbolInfoUtil.h"

using namespace std;

/* Globals between flex and bison. These are declared in Globals.cpp. */
extern CommandLineFlags CL_FLAGS;
extern SymbolTable S_TABLE;
extern TokenReductionsLogger TR_LOGGER;
extern bool INSERT_MODE;
extern bool IN_SWITCH;
extern int LINE;
extern int COLUMN;
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
"!!" {
	S_TABLE.Print();
}

"!!!" {
	Harris();
}

"auto"	{
	TR_LOGGER.PushToken("AUTO");
	TR_LOGGER.PushSourceWord(yytext);
	yylval = *(new list<SymbolInfo>());
	yylval.push_back(*(new SymbolInfo));
	yylval.front().storage_class_specifier = SymbolTypes::AUTO;
	COLUMN += yyleng;
	return AUTO;
}

"break"	{
	TR_LOGGER.PushToken("BREAK");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return BREAK;
}

"case"	{
	TR_LOGGER.PushToken("CASE");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return CASE;
}

"char"	{
	TR_LOGGER.PushToken("CHAR");
	TR_LOGGER.PushSourceWord(yytext);
	yylval = *(new list<SymbolInfo>());
	yylval.push_back(*(new SymbolInfo));
	yylval.front().type_specifier_list.push_back(SymbolTypes::CHAR);
	COLUMN += yyleng;
	return CHAR;
}

"const"	{
	TR_LOGGER.PushToken("CONST");
	TR_LOGGER.PushSourceWord(yytext);
	yylval = *(new list<SymbolInfo>());
	yylval.push_back(*(new SymbolInfo));
	yylval.front().type_qualifier_list.push_back(SymbolTypes::CONST);
	COLUMN += yyleng;
	return CONST;
}

"continue"	{
	TR_LOGGER.PushToken("CONTINUE");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return CONTINUE;
}

"default"	{
	TR_LOGGER.PushToken("DEFAULT");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return DEFAULT;
}

"do"	{
	TR_LOGGER.PushToken("DO");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return DO;
}

"double"	{
	TR_LOGGER.PushToken("DOUBLE");
	TR_LOGGER.PushSourceWord(yytext);
	yylval = *(new list<SymbolInfo>());
	yylval.push_back(*(new SymbolInfo));
	yylval.front().type_specifier_list.push_back(SymbolTypes::DOUBLE);
	COLUMN += yyleng;
	return DOUBLE;
}

"else"	{
	TR_LOGGER.PushToken("ELSE");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return ELSE;
}

"enum"	{
	TR_LOGGER.PushToken("ENUM");
	TR_LOGGER.PushSourceWord(yytext);
	yylval = *(new list<SymbolInfo>());
	yylval.push_back(*(new SymbolInfo));
	yylval.front().type_specifier_list.push_back(SymbolTypes::ENUM);
	COLUMN += yyleng;
	return ENUM;
}

"extern"	{
	TR_LOGGER.PushToken("EXTERN");
	TR_LOGGER.PushSourceWord(yytext);
	yylval = *(new list<SymbolInfo>());
	yylval.push_back(*(new SymbolInfo));
	yylval.front().storage_class_specifier = SymbolTypes::EXTERN;
	COLUMN += yyleng;
	return EXTERN;
}

"float"	{
	TR_LOGGER.PushToken("FLOAT");
	TR_LOGGER.PushSourceWord(yytext);
	yylval = *(new list<SymbolInfo>());
	yylval.push_back(*(new SymbolInfo));
	yylval.front().type_specifier_list.push_back(SymbolTypes::FLOAT);
	COLUMN += yyleng;
	return FLOAT;
}

"for"	{
	TR_LOGGER.PushToken("FOR");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return FOR;
}

"goto"	{
	TR_LOGGER.PushToken("GOTO");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return GOTO;
}

"if"	{
	TR_LOGGER.PushToken("IF");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return IF;
}

"int"	{
	TR_LOGGER.PushToken("INT");
	TR_LOGGER.PushSourceWord(yytext);
	yylval = *(new list<SymbolInfo>());
	yylval.push_back(*(new SymbolInfo));
	yylval.front().type_specifier_list.push_back(SymbolTypes::INT);
	COLUMN += yyleng;
	return INT;
}

"long"	{
	TR_LOGGER.PushToken("LONG");
	TR_LOGGER.PushSourceWord(yytext);
	yylval = *(new list<SymbolInfo>());
	yylval.push_back(*(new SymbolInfo));
	yylval.front().type_specifier_list.push_back(SymbolTypes::LONG);
	COLUMN += yyleng;
	return LONG;
}

"register"	{
	TR_LOGGER.PushToken("REGISTER");
	TR_LOGGER.PushSourceWord(yytext);
	yylval = *(new list<SymbolInfo>());
	yylval.push_back(*(new SymbolInfo));
	yylval.front().storage_class_specifier = SymbolTypes::REGISTER;
	COLUMN += yyleng;
	return REGISTER;
}

"return"	{
	TR_LOGGER.PushToken("RETURN");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return RETURN;
}

"short"	{
	TR_LOGGER.PushToken("SHORT");
	TR_LOGGER.PushSourceWord(yytext);
	yylval = *(new list<SymbolInfo>());
	yylval.push_back(*(new SymbolInfo));
	yylval.front().type_specifier_list.push_back(SymbolTypes::SHORT);
	COLUMN += yyleng;
	return SHORT;
}

"signed"	{
	TR_LOGGER.PushToken("SIGNED");
	TR_LOGGER.PushSourceWord(yytext);
	yylval = *(new list<SymbolInfo>());
	yylval.push_back(*(new SymbolInfo));
	yylval.front().type_specifier_list.push_back(SymbolTypes::SIGNED);
	COLUMN += yyleng;
	return SIGNED;
}

"sizeof"	{
	TR_LOGGER.PushToken("SIZEOF");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return SIZEOF;
}

"static"	{
	TR_LOGGER.PushToken("STATIC");
	TR_LOGGER.PushSourceWord(yytext);
	yylval = *(new list<SymbolInfo>());
	yylval.push_back(*(new SymbolInfo));
	yylval.front().storage_class_specifier = SymbolTypes::STATIC;
	COLUMN += yyleng;
	return STATIC;
}

"struct"	{
	TR_LOGGER.PushToken("STRUCT");
	TR_LOGGER.PushSourceWord(yytext);
	yylval = *(new list<SymbolInfo>());
	yylval.push_back(*(new SymbolInfo));
	yylval.front().type_specifier_list.push_back(SymbolTypes::STRUCT);
	COLUMN += yyleng;
	return STRUCT;
}

"switch"	{
	TR_LOGGER.PushToken("SWITCH");
	IN_SWITCH = true;
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return SWITCH;
}

"typedef"	{
	TR_LOGGER.PushToken("TYPEDEF");
	TR_LOGGER.PushSourceWord(yytext);
	yylval = *(new list<SymbolInfo>());
	yylval.push_back(*(new SymbolInfo));
	yylval.front().storage_class_specifier = SymbolTypes::TYPEDEF;
	COLUMN += yyleng;
	return TYPEDEF;
}

"union"	{
	TR_LOGGER.PushToken("UNION");
	TR_LOGGER.PushSourceWord(yytext);
	yylval = *(new list<SymbolInfo>());
	yylval.push_back(*(new SymbolInfo));
	yylval.front().type_specifier_list.push_back(SymbolTypes::UNION);
	COLUMN += yyleng;
	return UNION;
}

"unsigned"	{
	TR_LOGGER.PushToken("UNSIGNED");
	TR_LOGGER.PushSourceWord(yytext);
	yylval = *(new list<SymbolInfo>());
	yylval.push_back(*(new SymbolInfo));
	yylval.front().type_specifier_list.push_back(SymbolTypes::UNSIGNED);
	COLUMN += yyleng;
	return UNSIGNED;
}

"void"	{
	TR_LOGGER.PushToken("VOID");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return VOID;
}

"volatile"	{
	TR_LOGGER.PushToken("VOLATILE");
	TR_LOGGER.PushSourceWord(yytext);
	yylval = *(new list<SymbolInfo>());
	yylval.push_back(*(new SymbolInfo));
	yylval.front().type_qualifier_list.push_back(SymbolTypes::VOLATILE);
	COLUMN += yyleng;
	return VOLATILE;
}

"while"	{
	TR_LOGGER.PushToken("WHILE");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return WHILE;
}

%{
/* Identifiers */
%}

[A-Za-z][A-Za-z0-9_]* {
	// Log source word
	TR_LOGGER.PushSourceWord(yytext);
	// Increment COLUMN counter
	COLUMN += yyleng;

	// Get most recent symbol info.
	if(S_TABLE.Has(yytext) && 
		 S_TABLE.GetMostRecentSymbolInfo(yytext)->storage_class_specifier == SymbolTypes::TYPEDEF) {
		// If it is a typedef log and return typedef.
		yylval.push_back(*(new SymbolInfo));
		yylval.front().type_specifier_list.front() = SymbolTypes::TYPEDEF_NAME;
		yylval.front().typedef_name = string(yytext);
		TR_LOGGER.PushToken("TYPEDEF_NAME");
		return TYPEDEF_NAME;
	}
	// Check insert mode.
	if (INSERT_MODE) {
		if (CL_FLAGS.GetDebugType() == TOKENS_AND_REDUCTIONS_AND_SYMBOL_TABLE) {
			cout << "In insert mode." << endl;
		}
		if (S_TABLE.HasInScope(yytext)) {
			 if(S_TABLE.GetMostRecentSymbolInfo(yytext)->is_function &&
				!S_TABLE.GetMostRecentSymbolInfo(yytext)->function_defined) {
				yylval = *(new list<SymbolInfo>);
				yylval.push_front(*S_TABLE.GetMostRecentSymbolInfo(yytext));
				return IDENTIFIER;
			 }

			// If the identifier is in the scope. There is an error. Log and return.
			TR_LOGGER.Error("Identifier already declared in scope.", 
				LINE, COLUMN - yyleng);
			TR_LOGGER.PushToken("IDENTIFIER");
			return IDENTIFIER;
		} else if (S_TABLE.HasShadowing(yytext)) {	
			// If identifier is shadowed output warning.
			TR_LOGGER.Warning("Identifier is shadowing another identifier.", 
				LINE, COLUMN - yyleng);
		}

		// Create info to be inserted into the symbol table
		SymbolInfo insert_info;
		insert_info.identifier_name = string(yytext);

		// Insert into table
		S_TABLE.InsertSymbol(yytext, insert_info);
		yylval = *(new list<SymbolInfo>);
		yylval.push_front(insert_info);

		// Log and return
		TR_LOGGER.PushToken("IDENTIFIER");
		return IDENTIFIER;

	} else { // Lookup mode.
		if (CL_FLAGS.GetDebugType() == TOKENS_AND_REDUCTIONS_AND_SYMBOL_TABLE) {
			cout << "In lookup mode." << endl;
		}
		if(S_TABLE.Has(yytext)) { // The info can be accessed
			yylval = *(new list<SymbolInfo>);
			yylval.push_front(*(S_TABLE.GetMostRecentSymbolInfo(yytext)));
			TR_LOGGER.PushToken("IDENTIFIER");
			return IDENTIFIER;
		} else {
			TR_LOGGER.Error("Identifier not declared in scope.", 
				LINE, COLUMN - yyleng);
			TR_LOGGER.PushToken("IDENTIFIER");
			return IDENTIFIER;
		}
	}
}

%{
/* Constant Values */
%}
[1-9][0-9]*{int_suffix}? { // Regular Integer
	// Log token and source word.
	TR_LOGGER.PushToken("INTEGER_CONSTANT");
	TR_LOGGER.PushSourceWord(yytext);
	
	// Check Overflow
	char** end_ptr;
	int base = 10;
	unsigned long long input = std::strtoull(yytext, end_ptr, base);
	if(errno == ERANGE) {
		TR_LOGGER.Error("Integer Constant Overflow", LINE, COLUMN);
	} else {
		yylval = *(new list<SymbolInfo>);
		yylval.push_back(*(new SymbolInfo));
		yylval.front().data_is_valid = true;
		yylval.front().type_specifier_list 
			= *(new list<SymbolTypes::SymbolType>());
		yylval.front().type_specifier_list.push_back(SymbolTypes::UNSIGNED);
		yylval.front().type_specifier_list.push_back(SymbolTypes::LONG);
		yylval.front().type_specifier_list.push_back(SymbolTypes::LONG);
		yylval.front().type_specifier_list.push_back(SymbolTypes::INT);
		yylval.front().data_value.unsigned_long_long_val = input;
	}

	// Increment COLUMN counter and return
	COLUMN += yyleng;
	return INTEGER_CONSTANT;
}

[0][0-7]*{int_suffix}? { // Octal Integer
	// Log token and source word.
	TR_LOGGER.PushToken("INTEGER_CONSTANT");
	TR_LOGGER.PushSourceWord(yytext);

	// Check Overflow
	char** end_ptr;
	int base = 8;
	unsigned long long input = std::strtoull(yytext, end_ptr, base);
	if(errno == ERANGE) {
		TR_LOGGER.Error("Integer Constant Overflow", LINE, COLUMN);
	} else {
		yylval = *(new list<SymbolInfo>);
		yylval.push_back(*(new SymbolInfo));
		yylval.front().data_value.unsigned_long_long_val = input;
		yylval.front().data_is_valid = true;
		yylval.front().type_specifier_list 
			= *(new list<SymbolTypes::SymbolType>());
		yylval.front().type_specifier_list.push_back(SymbolTypes::UNSIGNED);
		yylval.front().type_specifier_list.push_back(SymbolTypes::LONG);
		yylval.front().type_specifier_list.push_back(SymbolTypes::LONG);
		yylval.front().type_specifier_list.push_back(SymbolTypes::INT);
	}

	// Increment COLUMN counter and return
	COLUMN += yyleng;
	return INTEGER_CONSTANT;
}

[0][xX][0-9A-Fa-f]+{int_suffix}? { // Hexidecimal Integer
	// Log token and source word.
	TR_LOGGER.PushToken("INTEGER_CONSTANT");
	TR_LOGGER.PushSourceWord(yytext);

	// Check Overflow
	char** end_ptr;
	int base = 16;
	unsigned long long input = std::strtoull(yytext, end_ptr, base);
	if(errno == ERANGE) {
		TR_LOGGER.Error("Integer Constant Overflow", LINE, COLUMN);
	} else {
		yylval = *(new list<SymbolInfo>);
		yylval.push_back(*(new SymbolInfo));
		
		yylval.front().data_value.unsigned_long_long_val = input;
		yylval.front().data_is_valid = true;
		yylval.front().type_specifier_list 
			= *(new list<SymbolTypes::SymbolType>());
		yylval.front().type_specifier_list.push_back(SymbolTypes::UNSIGNED);
		yylval.front().type_specifier_list.push_back(SymbolTypes::LONG);
		yylval.front().type_specifier_list.push_back(SymbolTypes::LONG);
		yylval.front().type_specifier_list.push_back(SymbolTypes::INT);

	}

	// Increment COLUMN counter and return
	COLUMN += yyleng;
	return INTEGER_CONSTANT;
}

[0-9]+"."[0-9]*([eE]["+"|"-"]?[0-9]+)?[flFL]? |
[0-9]+"."?([eE]["+"|"-"]?[0-9]+)?[flFL]?  |
"."[0-9]+([eE]["+"|"-"]?[0-9]+)?[flFL]? {
	// Log token and source word
	TR_LOGGER.PushToken("FLOATING_CONSTANT");
	TR_LOGGER.PushSourceWord(yytext);

	// Check Overflow
	char** end_ptr;
	double input = std::strtod(yytext, end_ptr);
	if(errno == ERANGE) {
		TR_LOGGER.Error("Floating Point Constant Overflow", LINE, COLUMN);
	} else {
		yylval = *(new list<SymbolInfo>);
		yylval.push_back(*(new SymbolInfo));
		
		yylval.front().data_value.double_val = input;
		yylval.front().data_is_valid = true;
		yylval.front().type_specifier_list 
			= *(new list<SymbolTypes::SymbolType>());
		yylval.front().type_specifier_list.push_back(SymbolTypes::LONG);
		yylval.front().type_specifier_list.push_back(SymbolTypes::DOUBLE);
	}

	// Increment COLUMN counter and return
	COLUMN += yyleng;
	return FLOATING_CONSTANT;
}

\'\\?[^\']\' {
	// Log token and source word
	TR_LOGGER.PushToken("CHARACTER_CONSTANT");
	TR_LOGGER.PushSourceWord(yytext);

	// Assign lval
	yylval.push_back(*(new SymbolInfo));
	yylval.front().data_value.char_val = *yytext;

	// Increment COLUMN counter and return
	COLUMN += yyleng;
	return CHARACTER_CONSTANT;
}

\"[^\"]*\" {
	// Log token and source word
	TR_LOGGER.PushToken("STRING_LITERAL");
	TR_LOGGER.PushSourceWord(yytext);

	// Assign lval
	yylval.push_back(*(new SymbolInfo));
	yylval.front().data_value.string_val = new std::string(yytext);

	// Increment COLUMN counter and return
	COLUMN += yyleng;
	return STRING_LITERAL;
}

%{
/* Operator Symbols */
%}

"->" {
	TR_LOGGER.PushToken("PTR_OP");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return PTR_OP;
}

"++" {
	TR_LOGGER.PushToken("INC_OP");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return INC_OP;
}

"--" {
	TR_LOGGER.PushToken("DEC_OP");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return DEC_OP;
}

"<<" {
	TR_LOGGER.PushToken("LEFT_OP");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return LEFT_OP;
}

">>" {
	TR_LOGGER.PushToken("RIGHT_OP");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return RIGHT_OP;
}

"<=" {
	TR_LOGGER.PushToken("LE_OP");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return LE_OP;
}

">=" {
	TR_LOGGER.PushToken("GE_OP");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return GE_OP;
}

"==" {
	TR_LOGGER.PushToken("EQ_OP");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return EQ_OP;
}

"!=" {
	TR_LOGGER.PushToken("NE_OP");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return EQ_OP;
}

"&&" {
	TR_LOGGER.PushToken("AND_OP");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return AND_OP;
}

"||" {
	TR_LOGGER.PushToken("OR_OP");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return OR_OP;
}

"*=" {
	TR_LOGGER.PushToken("MUL_ASSIGN");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return AND_OP;
}

"/=" {
	TR_LOGGER.PushToken("DIV_ASSIGN");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return DIV_ASSIGN;
}

"%=" {
	TR_LOGGER.PushToken("MOD_ASSIGN");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return MOD_ASSIGN;
}

"+=" {
	TR_LOGGER.PushToken("ADD_ASSIGN");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return ADD_ASSIGN;
}

"-=" {
	TR_LOGGER.PushToken("SUB_ASSIGN");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return SUB_ASSIGN;
}

"<<=" {
	TR_LOGGER.PushToken("LEFT_ASSIGN");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return LEFT_ASSIGN;
}

">>=" {
	TR_LOGGER.PushToken("RIGHT_ASSIGN");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return RIGHT_ASSIGN;
}

"&=" {
	TR_LOGGER.PushToken("AND_ASSIGN");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return AND_ASSIGN;
}

"^=" {
	TR_LOGGER.PushToken("XOR_ASSIGN");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return XOR_ASSIGN;
}

"|=" {
	TR_LOGGER.PushToken("OR_ASSIGN");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return OR_ASSIGN;
}

%{
/* Punctuation */
%}
"..." {
	TR_LOGGER.PushToken("ELLIPSIS");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return ELLIPSIS;
}

";" {
	TR_LOGGER.PushToken("SEMI");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return SEMI;
}

\{ {
	TR_LOGGER.PushToken("OPEN_CURLY");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return OPEN_CURLY;
}

\} {
	TR_LOGGER.PushToken("CLOSE_CURLY");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return CLOSE_CURLY;
}

"," {
	TR_LOGGER.PushToken("COMMA");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return COMMA;
}

"=" {
	TR_LOGGER.PushToken("EQUALS_SIGN");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return EQUALS_SIGN;
}

":" {
	TR_LOGGER.PushToken("COLON");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return COLON;
}

"(" {
	TR_LOGGER.PushToken("OPEN_PAREN");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return OPEN_PAREN;
}

")" {
	TR_LOGGER.PushToken("CLOSE_PAREN");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return CLOSE_PAREN;
}

"[" {
	TR_LOGGER.PushToken("OPEN_SQUARE");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return OPEN_SQUARE;
}

"]" {
	TR_LOGGER.PushToken("CLOSE_SQUARE");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return CLOSE_SQUARE;
}

"*" {
	TR_LOGGER.PushToken("ASTERISK");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return ASTERISK;
}

"&" {
	TR_LOGGER.PushToken("AMPERSAND");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return AMPERSAND;
}

"?" {
	TR_LOGGER.PushToken("QUESTION");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return QUESTION;
}

"|" {
	TR_LOGGER.PushToken("PIPE");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return PIPE;
}

"^" {
	TR_LOGGER.PushToken("CARAT");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return CARAT;
}

"<" {
	TR_LOGGER.PushToken("LESSER");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return LESSER;
}

">" {
	TR_LOGGER.PushToken("GREATER");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return GREATER;
}

"+" {
	TR_LOGGER.PushToken("PLUS");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return PLUS;
}

"-" {
	TR_LOGGER.PushToken("MINUS");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return MINUS;
}

"%" {
	TR_LOGGER.PushToken("PERCENT");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return PERCENT;
}

"/" {
	TR_LOGGER.PushToken("FORWARD_SLASH");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return FORWARD_SLASH;
}

"~" {
	TR_LOGGER.PushToken("TILDE");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return TILDE;
}

"!" {
	TR_LOGGER.PushToken("BANG");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return BANG;
}

"." {
	TR_LOGGER.PushToken("DOT");
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	return DOT;
}

%{
/* Comments */
%}

\/\* {
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	BEGIN (COMMENTS);
}

<COMMENTS>"*/" {
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
	BEGIN (INITIAL);
}   

<COMMENTS>\n {
	TR_LOGGER.PushSourceWord(yytext);
	TR_LOGGER.LogSourceLine();
	TR_LOGGER.LogTokenReductions();
	LINE++;
	COLUMN = 1;
}

<COMMENTS>.* {
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
}

\/\/[^"\n"]* {
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
}

%{
/* Whitespace */
%}

[ \t]* {
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
}

"\n" {
	TR_LOGGER.LogSourceLine();
	TR_LOGGER.LogTokenReductions();
	LINE++;
	COLUMN = 1;
}

. {
	TR_LOGGER.PushSourceWord(yytext);
	COLUMN += yyleng;
}

%%
/******************************************************************************/
/* User Written Code */
/******************************************************************************/

