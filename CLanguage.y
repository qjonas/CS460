/******************************************************************************/
/* Definitions */
/******************************************************************************/
%{
/* Included C/C++ Libraries */
#include  "CommandLineFlags.h"
#include  "SymbolTable.h"
#include  "TokenReductionsLogger.h"
%}

%code requires {
	#include 	"SymbolType.h"
	#define YYSTYPE SymbolInfo*
}

%{
/* Globals between flex and bison. These are declared in Globals.cpp. */
extern CommandLineFlags CL_FLAGS;
extern SymbolTable S_TABLE;
extern TokenReductionsLogger TR_LOGGER;

/* Functions from Flex */
extern int yylex();
void yyerror(const char * err);
%}


/* Token Declarations */
/* Reserved Words */
%token AUTO
%token BREAK
%token CASE
%token CHAR
%token CONST
%token CONTINUE
%token DEFAULT
%token DO
%token DOUBLE
%token ELSE
%token ENUM
%token EXTERN
%token FLOAT
%token FOR
%token GOTO
%token IF
%token INT
%token LONG
%token REGISTER
%token RETURN
%token SHORT
%token SIGNED
%token SIZEOF
%token STATIC
%token STRUCT
%token SWITCH
%token TYPEDEF
%token UNION
%token UNSIGNED
%token VOID
%token VOLATILE
%token WHILE

/* Identifiers */
%token IDENTIFIER
%token TYPEDEF_NAME

/* Constant Values */
%token INTEGER_CONSTANT
%token FLOATING_CONSTANT
%token CHARACTER_CONSTANT
%token ENUMERATION_CONSTANT
%token STRING_LITERAL

/* Operator Symbols */
%token PTR_OP
%token INC_OP
%token DEC_OP
%token LEFT_OP
%token RIGHT_OP
%token LE_OP
%token GE_OP
%token EQ_OP
%token NE_OP
%token AND_OP
%token OR_OP
%token MUL_ASSIGN
%token DIV_ASSIGN
%token MOD_ASSIGN
%token ADD_ASSIGN
%token SUB_ASSIGN
%token LEFT_ASSIGN
%token RIGHT_ASSIGN
%token AND_ASSIGN
%token XOR_ASSIGN
%token OR_ASSIGN

/* Punctiation */
%token ELLIPSIS
%token SEMI
%token OPEN_CURLY
%token CLOSE_CURLY
%token COMMA
%token EQUALS_SIGN
%token COLON
%token OPEN_PAREN	
%token CLOSE_PAREN
%token OPEN_SQUARE
%token CLOSE_SQUARE
%token ASTERISK
%token AMPERSAND
%token QUESTION
%token PIPE
%token CARAT
%token LESSER
%token GREATER
%token PLUS
%token MINUS
%token PERCENT
%token FORWARD_SLASH
%token TILDE
%token BANG
%token DOT

/* Start Symbol */
%start translation_unit

/******************************************************************************/
/* Grammar and Actions */
/******************************************************************************/
%%

translation_unit
	: external_declaration {
		TR_LOGGER.PushReduction("external_declaration -> translation_unit");
	}
	| translation_unit external_declaration {
		TR_LOGGER.PushReduction(
			"translation_unit external_declaration -> translation_unit");
	}
	;

external_declaration
	: function_definition {
		TR_LOGGER.PushReduction("function_definition -> external_declaration");
	}
	| declaration {
		TR_LOGGER.PushReduction("declaration -> external_declaration");
	}
	;

function_definition
	:	declarator compound_statement {
		TR_LOGGER.PushReduction(
			"declarator compound_statement -> function_definition");
	}
	|	declarator declaration_list compound_statement {
			TR_LOGGER.PushReduction(
			"declarator declaration_list compound_statement "
			"-> function_definition");
		}
	| declaration_specifiers declarator compound_statement {
		TR_LOGGER.PushReduction(
			"declaration_specifiers declarator compound_statement "
			"-> function_definition");
	}
	| declaration_specifiers declarator declaration_list compound_statement {
		TR_LOGGER.PushReduction(
			"declaration_specifiers declarator declaration_list compound_statement "
			"-> function_definition");
	}
	;

declaration
	: declaration_specifiers SEMI {
		TR_LOGGER.PushReduction("declaration_specifiers SEMI -> declaration");
	}
	| declaration_specifiers init_declarator_list SEMI {	
		TR_LOGGER.PushReduction(
			"declaration_specifiers init declarator_list SEMI -> declaration");
	}
	;

declaration_list
	: {insertMode = true;} declaration { insertMode = false;
		TR_LOGGER.PushReduction("declaration -> declaration_list");
	}
	| declaration_list declaration {
		TR_LOGGER.PushReduction("delcaration_list declaration -> declaration_list");
	}
	;

declaration_specifiers
	: storage_class_specifier {
		TR_LOGGER.PushReduction(
			"storage_class_specifier -> declaration_specifiers");
	}
	| storage_class_specifier declaration_specifiers {
		TR_LOGGER.PushReduction(
			"storage_class_specifier declaration_specifiers "
			"-> declaration_specifiers");
	}
	| type_specifier {
		TR_LOGGER.PushReduction("type_specifier -> declaration_specifiers");
	}
	| type_specifier declaration_specifiers {
		TR_LOGGER.PushReduction(
			"type_specifier declaration_specifiers -> declaration_specifiers");
	}
	| type_qualifier {
		TR_LOGGER.PushReduction(
			"type_qualifier -> declaration_specifiers");
	}
	| type_qualifier declaration_specifiers {
		TR_LOGGER.PushReduction(
			"type_qualifier declaration_specifiers -> declaration_specifiers");
	}
	;

storage_class_specifier
	: AUTO {
		TR_LOGGER.PushReduction("AUTO -> storage_class_specifier");
	}
	| REGISTER {
		TR_LOGGER.PushReduction("REGISTER -> storage_class_specifier");
	}
	| STATIC {
		TR_LOGGER.PushReduction("STATIC -> storage_class_specifier");
	}
	| EXTERN {
		TR_LOGGER.PushReduction("EXTERN -> storage_class_specifier");
	}
	| TYPEDEF {
		TR_LOGGER.PushReduction("TYPEDEF -> storage_class_specifier");
	}
	;

type_specifier
	: VOID {
		TR_LOGGER.PushReduction("VOID -> type_specifier");
	}
	| CHAR {
		TR_LOGGER.PushReduction("CHAR -> type_specifier");
	}
	| SHORT {
		TR_LOGGER.PushReduction("SHORT -> type_specifier");
	}
	| INT  {
		TR_LOGGER.PushReduction("INT -> type_specifier");
	}
	| LONG {
		TR_LOGGER.PushReduction("LONG -> type_specifier");
	}
	| FLOAT {
		TR_LOGGER.PushReduction("FLOAT -> type_specifier");
	}
	| DOUBLE  {
		TR_LOGGER.PushReduction("DOUBLE -> type_specifier");
	}
	| SIGNED  {
		TR_LOGGER.PushReduction("SIGNED -> type_specifier");
	}
	| UNSIGNED {
		TR_LOGGER.PushReduction("UNSIGNED -> type_specifier");
	}
	| struct_or_union_specifier {
		TR_LOGGER.PushReduction("struct_or_union_specifier -> type_specifier");
	}
	| enum_specifier {
		TR_LOGGER.PushReduction("enum_specifier -> type_specifier");
	}
	| TYPEDEF_NAME {
		TR_LOGGER.PushReduction("TYPEDEF_NAME -> type_specifier");
	}
	;

type_qualifier
	: CONST  {
		TR_LOGGER.PushReduction("CONST -> type_qualifier");
	}
	| VOLATILE {
		TR_LOGGER.PushReduction("VOLATILE -> type_qualifier");
	}
	;

struct_or_union_specifier
	: struct_or_union identifier OPEN_CURLY struct_declaration_list CLOSE_CURLY {
		TR_LOGGER.PushReduction("struct_or_union identifier OPEN_CURLY "
														"struct_declaration_list CLOSE_CURLY "
														"-> struct_or_union_specifier");
	}
	| struct_or_union OPEN_CURLY struct_declaration_list CLOSE_CURLY {
		TR_LOGGER.PushReduction("struct_or_union OPEN_CURLY "
														"struct_declaration_list CLOSE_CURLY "
														"-> struct_or_union_specifier");
	}
	| struct_or_union identifier {
		TR_LOGGER.PushReduction(
			"struct_or_union identifier -> struct_or_union_specifier");
	}
	;

struct_or_union
	: STRUCT {
		TR_LOGGER.PushReduction("STRUCT -> struct_or_union");
	}
	| UNION {
		TR_LOGGER.PushReduction("UNION -> struct_or_union");
	}
	;

struct_declaration_list
	: struct_declaration {
		TR_LOGGER.PushReduction("struct_declaration -> struct_declaration_list");
	}
	| struct_declaration_list struct_declaration {
		TR_LOGGER.PushReduction(
			"struct_declaration_list struct_declaration -> struct_declaration_list");
	}
	;

init_declarator_list
	: init_declarator {
		TR_LOGGER.PushReduction("init_declarator -> init_declarator_list");
	}
	| init_declarator_list COMMA init_declarator {
		TR_LOGGER.PushReduction(
			"init_declarator_list COMMA init_declarator -> init_declarator_list");
	}
	;

init_declarator
	: declarator {
		TR_LOGGER.PushReduction("declarator -> init_declarator");
	}
	| declarator EQUALS_SIGN initializer {
		TR_LOGGER.PushReduction(
			"declarator EQUALS_SIGN initializer -> init_declarator");
	}
	;

struct_declaration
	: specifier_qualifier_list struct_declarator_list SEMI {
		TR_LOGGER.PushReduction(
			"specifier_qualifier_list struct_declarator_list SEMI "
			"-> struct_declaration");
	}
	;

specifier_qualifier_list
	: type_specifier {
		TR_LOGGER.PushReduction("type_specifier -> specifier_qualifier_list");
	}
	| type_specifier specifier_qualifier_list {
		TR_LOGGER.PushReduction(
			"type_specifier specifier_qualifier_list -> specifier_qualifier_list");
	}
	| type_qualifier {
		TR_LOGGER.PushReduction("type_qualifier -> specifier_qualifier_list");
	}
	| type_qualifier specifier_qualifier_list {
		TR_LOGGER.PushReduction(
			"type_qualifier specifier_qualifier_list -> specifier_qualifier_list");
	}
	;

struct_declarator_list
	: struct_declarator {
		TR_LOGGER.PushReduction("struct_declarator -> specifier_declarator_list");
	}
	| struct_declarator_list COMMA struct_declarator {
		TR_LOGGER.PushReduction(
			"struct_declarator_list COMMA struct_declarator "
			"-> specifier_declarator_list");
	}
	;

struct_declarator
	: declarator {
		TR_LOGGER.PushReduction("declarator -> struct_declarator");
	}
	| COLON constant_expression {
		TR_LOGGER.PushReduction("COLON constant_expression -> struct_declarator");
	}
	| declarator COLON constant_expression {
		TR_LOGGER.PushReduction(
			"declarator COlON constant_expression -> struct_declarator");
	}
	;

enum_specifier
	: ENUM OPEN_CURLY enumerator_list CLOSE_CURLY {
		TR_LOGGER.PushReduction(
			"ENUM OPEN_CURLY enumerator_list CLOSE_CURLY -> enum_specifier");
	}
	| ENUM identifier OPEN_CURLY enumerator_list CLOSE_CURLY {
		TR_LOGGER.PushReduction(
			"ENUM identifier OPEN_CURLY enumerator_list CLOSE_CURLY "
			"-> enum_specifier");
	}
	| ENUM identifier  {
		TR_LOGGER.PushReduction(
			"ENUM identifier -> enum_specifier");
	}
	;

enumerator_list
	: enumerator {
		TR_LOGGER.PushReduction("enumerator -> enumerator_list");
	}
	| enumerator_list COMMA enumerator  {
		TR_LOGGER.PushReduction(
			"enumerator_list COMMA enumerator -> enumerator_list");
	}
	;

enumerator
	: identifier {
		TR_LOGGER.PushReduction("identifier -> enumerator");
	}
	| identifier EQUALS_SIGN constant_expression {
		TR_LOGGER.PushReduction(
			"identifier EQUALS_SIGN constant_expression -> enumerator");
	}
	;

declarator
	: direct_declarator {
		TR_LOGGER.PushReduction("direct_declarator -> declarator");
	}
	| pointer direct_declarator {
		TR_LOGGER.PushReduction("pointer_direct_declarator -> declarator");
	}
	;

direct_declarator
	: identifier {
		TR_LOGGER.PushReduction("identifier -> direct_declarator");
	}
	| OPEN_PAREN declarator CLOSE_PAREN {
		TR_LOGGER.PushReduction(
			"OPEN_PAREN declarator CLOSE_PAREN -> direct_declarator");
	}
	| direct_declarator OPEN_SQUARE CLOSE_SQUARE {
		TR_LOGGER.PushReduction(
			"direct_declarator OPEN_SQUARE CLOSE_SQUARE -> direct_declarator");
	}
	| direct_declarator OPEN_SQUARE constant_expression CLOSE_SQUARE {
		TR_LOGGER.PushReduction(
			"direct_declarator OPEN_SQUARE constant_expression CLOSE_SQUARE "
			"-> direct_declarator");
	}
	| direct_declarator OPEN_PAREN CLOSE_PAREN {
		TR_LOGGER.PushReduction(
			"direct_declarator OPEN_PAREN CLOSE_PAREN -> direct_declarator");
	}
	| direct_declarator OPEN_PAREN parameter_type_list CLOSE_PAREN  {
		TR_LOGGER.PushReduction(
			"direct_declarator OPEN_PAREN parameter_type_list CLOSE_PAREN "
			"-> direct_declarator");
	}
	| direct_declarator OPEN_PAREN identifier_list CLOSE_PAREN {
		TR_LOGGER.PushReduction(
			"direct_declarator OPEN_PAREN identifier_list CLOSE_PAREN "
			"-> direct_declarator");
	}
	;

pointer
	: ASTERISK {
		TR_LOGGER.PushReduction("ASTERISK -> pointer");
	}
	| ASTERISK type_qualifier_list {
		TR_LOGGER.PushReduction("ASTERISK type_qualifier_list -> pointer");
	}
	| ASTERISK pointer {
		TR_LOGGER.PushReduction("ASTERISK pointer -> pointer");
	}
	| ASTERISK type_qualifier_list pointer {
		TR_LOGGER.PushReduction("ASTERISK type_qualifier_list pointer -> pointer");
	}
	;

type_qualifier_list
	: type_qualifier {
		TR_LOGGER.PushReduction("type_qualifier -> type_qualifier_list");
	}
	| type_qualifier_list type_qualifier {
		TR_LOGGER.PushReduction(
			"type_qualifier_list type_qualifier -> type_qualifier_list");
	}
	;

parameter_type_list
	: parameter_list {
		TR_LOGGER.PushReduction("parameter_list -> parameter_type_list");
	}
	| parameter_list COMMA ELLIPSIS {
		TR_LOGGER.PushReduction(
			"parameter_list COMMA ELLIPSIS -> parameter_type_list");
	}
	;

parameter_list
	: parameter_declaration {
		TR_LOGGER.PushReduction("parameter_declaration -> parameter_list");
	}
	| parameter_list COMMA parameter_declaration {
		TR_LOGGER.PushReduction(
			"parameter_list COMMA parameter_declaration -> parameter_list");
	}
	;

parameter_declaration
	: declaration_specifiers declarator {
		TR_LOGGER.PushReduction(
			"declaration_specifiers declarator -> parameter_declaration");
	}
	| declaration_specifiers  {
		TR_LOGGER.PushReduction("declaration_specifiers -> parameter_declaration");
	}
	| declaration_specifiers abstract_declarator {
		TR_LOGGER.PushReduction(
			"declaration_specifiers abstract_declarator -> parameter_declaration");
	}
	;

identifier_list
	: identifier {
		TR_LOGGER.PushReduction("identifier -> identifier_list");
	}
	| identifier_list COMMA identifier {
		TR_LOGGER.PushReduction(
			"identifier_list COMMA identifier -> identifier_list");
	}
	;

initializer
	: assignment_expression {
		TR_LOGGER.PushReduction("assignment_expression -> initializer");
	}
	| OPEN_CURLY initializer_list CLOSE_CURLY  {
		TR_LOGGER.PushReduction(
			"OPEN_CURLY initializer_list CLOSE_CURLY -> initializer");
	}
	| OPEN_CURLY initializer_list COMMA CLOSE_CURLY {
		TR_LOGGER.PushReduction(
			"OPEN_CURLY initializer_list COMMA CLOSE_CURLY -> initializer");
	}
	;

initializer_list
	: initializer {
		TR_LOGGER.PushReduction("initializer -> initializer_list");
	}
	| initializer_list COMMA initializer {
		TR_LOGGER.PushReduction(
			"initializer_list COMMA initializer -> initializer_list");
	}
	;

type_name
	: specifier_qualifier_list {
		TR_LOGGER.PushReduction("specifier_qualifier_list -> type_name");
	}
	| specifier_qualifier_list abstract_declarator {
		TR_LOGGER.PushReduction(
			"specifier_qualifier_list abstract_declarator -> type_name");
	}
	;

abstract_declarator
	: pointer  {
		TR_LOGGER.PushReduction("pointer -> abstract_declarator");
	}
	| direct_abstract_declarator  {
		TR_LOGGER.PushReduction(
			"direct_abstract_declarator -> abstract_declarator");
	}
	| pointer direct_abstract_declarator {
		TR_LOGGER.PushReduction(
			"pointer direct_abstract_declarator -> abstract_declarator");
	}
	;

direct_abstract_declarator
	: OPEN_PAREN abstract_declarator CLOSE_PAREN {
		TR_LOGGER.PushReduction(
			"OPEN_PAREN abstract_declarator CLOSE_PAREN "
			"-> direct_abstract_declarator");
	}
	| OPEN_SQUARE CLOSE_SQUARE {
		TR_LOGGER.PushReduction(
			"OPEN_SQUARE CLOSE_SQUARE -> direct_abstract_declarator");
	}
	| OPEN_SQUARE constant_expression CLOSE_SQUARE {
		TR_LOGGER.PushReduction(
			"OPEN_SQUARE constant_expression CLOSE_SQUARE "
			"-> direct_abstract_declarator");
	}
	| direct_abstract_declarator OPEN_SQUARE CLOSE_SQUARE {
		TR_LOGGER.PushReduction(
			"direct_abstract_declarator OPEN_SQUARE CLOSE_SQUARE "
			"-> direct_abstract_declarator");
	}
	| direct_abstract_declarator OPEN_SQUARE constant_expression CLOSE_SQUARE {
		TR_LOGGER.PushReduction(
			"direct_abstract_declarator OPEN_SQUARE constant_expression CLOSE_SQUARE"
			"-> direct_abstract_declarator");
	}
	| OPEN_PAREN CLOSE_PAREN {
		TR_LOGGER.PushReduction(
			"OPEN_PAREN CLOSE_PAREN -> direct_abstract_declarator");
	}
	| OPEN_PAREN parameter_type_list CLOSE_PAREN {
		TR_LOGGER.PushReduction(
			"OPEN_PAREN parameter_type_list CLOSE_PAREN "
			"-> direct_abstract_declarator");
	}
	| direct_abstract_declarator OPEN_PAREN CLOSE_PAREN {
		TR_LOGGER.PushReduction(
			"direct_abstract_declarator OPEN_PAREN CLOSE_PAREN "
			"-> direct_abstract_declarator");
	}
	| direct_abstract_declarator OPEN_PAREN parameter_type_list CLOSE_PAREN {
		TR_LOGGER.PushReduction(
			"direct_abstract_declarator OPEN_PAREN parameter_type_list CLOSE_PAREN "
			"-> direct_abstract_declarator");
	}
	;

statement
	: labeled_statement {
		TR_LOGGER.PushReduction("labeled_statement -> statement");
	}
	| compound_statement {
		TR_LOGGER.PushReduction("compound_statement -> statement");
	}
	| expression_statement {
		TR_LOGGER.PushReduction("expression_statement -> statement");
	}
	| selection_statement {
		TR_LOGGER.PushReduction("selection_statement -> statement");
	}
	| iteration_statement {
		TR_LOGGER.PushReduction("iteration_statement -> statement");
	}
	| jump_statement {
		TR_LOGGER.PushReduction("jump_statement -> statement");
	}
	;

labeled_statement
	: identifier COLON statement {
		TR_LOGGER.PushReduction("identifier COLON statement -> labeled_statement");
	}
	| CASE constant_expression COLON statement {
		TR_LOGGER.PushReduction(
			"CASE constant_expression COLON statement -> labeled_statement");
	}
	| DEFAULT COLON statement {
		TR_LOGGER.PushReduction("DEFAULT COlON statement -> labeled_statement");
	}
	;

expression_statement
	: SEMI {
		TR_LOGGER.PushReduction("SEMI -> expression_statement");
	}
	| expression SEMI {
		TR_LOGGER.PushReduction("expression SEMI -> expression_statement");
	}
	;

compound_statement
	: OPEN_CURLY CLOSE_CURLY {
		TR_LOGGER.PushReduction("OPEN_CURLY CLOSE_CURLY -> expression_statement");
	}
	| OPEN_CURLY statement_list CLOSE_CURLY {
		TR_LOGGER.PushReduction(
			"OPEN_CURLY statement_list CLOSE_CURLY -> expression_statement");
	}
	| OPEN_CURLY declaration_list CLOSE_CURLY {
		// TODO: Deal with new scope on SymbolTable.
		TR_LOGGER.PushReduction(
			"OPEN_CURLY declaration_list CLOSE_CURLY -> expression_statement");
	}
	| OPEN_CURLY declaration_list statement_list CLOSE_CURLY {
		// TODO: Deal with new scope on SymbolTable.
		TR_LOGGER.PushReduction(
			"OPEN_CURLY declaration_list statement_list CLOSE_CURLY "
			"-> expression_statement");
	}
	;

statement_list
	: statement {
		TR_LOGGER.PushReduction("statement -> statement_list");
	}
	| statement_list statement {
		TR_LOGGER.PushReduction("statement_list statement -> statement_list");
	}
	;

selection_statement
	: IF OPEN_PAREN expression CLOSE_PAREN statement {
		TR_LOGGER.PushReduction(
			"IF OPEN_PAREN expression CLOSE_PAREN statement_list "
			"-> selection_statement");
	}
	| IF OPEN_PAREN expression CLOSE_PAREN statement ELSE statement {
		TR_LOGGER.PushReduction(
			"IF OPEN_PAREN expression CLOSE_PAREN statement ELSE statement "
			"-> selection_statement");
	}
	| SWITCH OPEN_PAREN expression CLOSE_PAREN statement {
		TR_LOGGER.PushReduction(
			"SWITCH OPEN_PAREN expression CLOSE_PAREN statement "
			"-> selection_statement");
	}
	;

iteration_statement
	: WHILE OPEN_PAREN expression CLOSE_PAREN statement {
		TR_LOGGER.PushReduction(
			"WHILE OPEN_PAREN expression CLOSE_PAREN statement "
			"-> iteration_statement");
	}
	| DO statement WHILE OPEN_PAREN expression CLOSE_PAREN SEMI {
		TR_LOGGER.PushReduction(
			"DO statement WHILE OPEN_PAREN expression CLOSE_PAREN SEMI "
			"-> iteration_statement");
	}
	| FOR OPEN_PAREN SEMI SEMI CLOSE_PAREN statement {
		TR_LOGGER.PushReduction(
			"FOR OPEN_PAREN SEMI SEMI CLOSE_PAREN statement -> iteration_statement");
	}
	| FOR OPEN_PAREN SEMI SEMI expression CLOSE_PAREN statement {
		TR_LOGGER.PushReduction(
			"FOR OPEN_PAREN SEMI SEMI expression CLOSE_PAREN statement "
			"-> iteration_statement");
	}
	| FOR OPEN_PAREN SEMI expression SEMI CLOSE_PAREN statement {
		TR_LOGGER.PushReduction(
			"FOR OPEN_PAREN SEMI expression SEMI CLOSE_PAREN statement "
			"-> iteration_statement");
	}
	| FOR OPEN_PAREN SEMI expression SEMI expression CLOSE_PAREN statement {
		TR_LOGGER.PushReduction(
			"FOR OPEN_PAREN SEMI expression SEMI expression CLOSE_PAREN statement "
			"-> iteration_statement");
	}
	| FOR OPEN_PAREN expression SEMI SEMI CLOSE_PAREN statement {
		TR_LOGGER.PushReduction(
			"FOR OPEN_PAREN expression SEMI SEMI CLOSE_PAREN statement "
			"-> iteration_statement");
	}
	| FOR OPEN_PAREN expression SEMI SEMI expression CLOSE_PAREN statement {
		TR_LOGGER.PushReduction(
			"FOR OPEN_PAREN expression SEMI SEMI expression CLOSE_PAREN statement "
			"-> iteration_statement");
	}
	| FOR OPEN_PAREN expression SEMI expression SEMI CLOSE_PAREN statement {
		TR_LOGGER.PushReduction(
			"FOR OPEN_PAREN expression SEMI expression SEMI CLOSE_PAREN statement "
			"-> iteration_statement");
	}
	| FOR OPEN_PAREN expression SEMI expression SEMI expression CLOSE_PAREN statement {
		TR_LOGGER.PushReduction(
			"FOR OPEN_PAREN expression SEMI expression SEMI expression CLOSE_PAREN statement "
			"-> iteration_statement");
	}
	;

jump_statement
	: GOTO identifier SEMI {
		TR_LOGGER.PushReduction("GOTO identifier SEMI -> jump_statement");
	}
	| CONTINUE SEMI {
		TR_LOGGER.PushReduction("CONTINUE SEMI -> jump_statement");
	}
	| BREAK SEMI {
		TR_LOGGER.PushReduction("BREAK SEMI -> jump_statement");
	}
	| RETURN SEMI {
		TR_LOGGER.PushReduction("RETURN SEMI -> jump_statement");
	}
	| RETURN expression SEMI {
		TR_LOGGER.PushReduction("RETURN expression SEMI -> jump_statement");
	}
	;

expression
	: assignment_expression {
		TR_LOGGER.PushReduction("assignment_expression -> expression");
	}
	| expression COMMA assignment_expression {
		TR_LOGGER.PushReduction(
			"expression COMMA assignment_expression -> expression");
	}
	;

assignment_expression
	: conditional_expression {
		TR_LOGGER.PushReduction("conditional_expression -> assignment_expression");
	}
	| unary_expression assignment_operator assignment_expression {
		TR_LOGGER.PushReduction(
			"unary_expression assignment_operator assignment_expression "
			"-> assignment_expression");
	}
	;

assignment_operator
	: EQUALS_SIGN {
		TR_LOGGER.PushReduction("EQUALS_SIGN -> assignment_operator");
	}
	| MUL_ASSIGN {
		TR_LOGGER.PushReduction("MUL_ASSIGN -> assignment_operator");
	}
	| DIV_ASSIGN {
		TR_LOGGER.PushReduction("DIV_ASSIGN -> assignment_operator");
	}
	| MOD_ASSIGN {
		TR_LOGGER.PushReduction("MOD_ASSIGN -> assignment_operator");
	}
	| ADD_ASSIGN {
		TR_LOGGER.PushReduction("ADD_ASSIGN -> assignment_operator");
	}
	| SUB_ASSIGN {
		TR_LOGGER.PushReduction("SUB_ASSIGN -> assignment_operator");
	}
	| LEFT_ASSIGN {
		TR_LOGGER.PushReduction("LEFT_ASSIGN -> assignment_operator");
	}
	| RIGHT_ASSIGN {
		TR_LOGGER.PushReduction("RIGHT_ASSIGN -> assignment_operator");
	}
	| AND_ASSIGN {
		TR_LOGGER.PushReduction("AND_ASSIGN -> assignment_operator");
	}
	| XOR_ASSIGN {
		TR_LOGGER.PushReduction("XOR_ASSIGN -> assignment_operator");
	}
	| OR_ASSIGN {
		TR_LOGGER.PushReduction("OR_ASSIGN -> assignment_operator");
	}
	;

conditional_expression
	: logical_or_expression {
		TR_LOGGER.PushReduction("logical_or_expression -> conditional_expression");
	}
	| logical_or_expression QUESTION expression COLON conditional_expression {
		TR_LOGGER.PushReduction(
			"logical_or_expression QUESTION expression COLON conditional_expression "
			"-> conditional_expression");
	}
	;

constant_expression
	: conditional_expression {
		TR_LOGGER.PushReduction("conditional_expression -> constant_expression");
	}
	;

logical_or_expression
	: logical_and_expression {
		TR_LOGGER.PushReduction("logical_and_expression -> logical_or_expression");
	}
	| logical_or_expression OR_OP logical_and_expression {
		TR_LOGGER.PushReduction(
			"logical_or_expression OR_OP logical_and_expression "
			"-> logical_or_expression");
	}
	;

logical_and_expression
	: inclusive_or_expression {
		TR_LOGGER.PushReduction(
			"inclusive_or_expression -> logical_and_expression");
	}
	| logical_and_expression AND_OP inclusive_or_expression {
		TR_LOGGER.PushReduction(
			"logical_and_expression AND_OP inclusive_or_expression "
			"-> logical_and_expression");
	}
	;

inclusive_or_expression
	: exclusive_or_expression {
		TR_LOGGER.PushReduction(
			"exclusive_or_expression -> inclusive_or_expression");
	}
	| inclusive_or_expression PIPE exclusive_or_expression {
		TR_LOGGER.PushReduction(
			"inclusive_or_expression PIPE exclusive_or_expression "
			"-> inclusive_or_expression");
	}
	;

exclusive_or_expression
	: and_expression {
		TR_LOGGER.PushReduction("exclusive_or_expression -> and_expression");
	}
	| exclusive_or_expression CARAT and_expression {
		TR_LOGGER.PushReduction(
			"exclusive_or_expression CARAT and_expression "
			"-> exclusive_or_expression");
	}
	;

and_expression
	: equality_expression {
		TR_LOGGER.PushReduction("equality_expression -> and_expression");
	}
	| and_expression AMPERSAND equality_expression {
		TR_LOGGER.PushReduction(
			"and_expression AMPERSAND equality_expression -> and_expression");
	}
	;

equality_expression
	: relational_expression {
		TR_LOGGER.PushReduction("relational_expression -> equality_expression");
	}
	| equality_expression EQ_OP relational_expression {
		TR_LOGGER.PushReduction(
			"equality_expression EQ_OP relational_expression -> equality_expression");
	}
	| equality_expression NE_OP relational_expression {
		TR_LOGGER.PushReduction(
			"equality_expression NE_OP relational_expression -> equality_expression");
	}
	;

relational_expression
	: shift_expression {
		TR_LOGGER.PushReduction("shift_expression -> relational_expression");
	}
	| relational_expression LESSER shift_expression {
		TR_LOGGER.PushReduction(
			"relational_expression LESSER shift_expression -> relational_expression");
	}
	| relational_expression GREATER shift_expression {
		TR_LOGGER.PushReduction(
			"relational_expression GREATER shift_expression "
			"-> relational_expression");
	}
	| relational_expression LE_OP shift_expression {
		TR_LOGGER.PushReduction(
			"relational_expression LE_OP shift_expression -> relational_expression");
	}
	| relational_expression GE_OP shift_expression {
		TR_LOGGER.PushReduction(
			"relational_expression GE_OP shift_expression -> relational_expression");
	}
	;

shift_expression
	: additive_expression {
		TR_LOGGER.PushReduction("additive_expression -> shift_expression");
	}
	| shift_expression LEFT_OP additive_expression {
		TR_LOGGER.PushReduction(
			"shift_expression LEFT_OP additive_expression -> shift_expression");
	}
	| shift_expression RIGHT_OP additive_expression {
		TR_LOGGER.PushReduction(
			"shift_expression RIGHT_OP additive_expression -> shift_expression");
	}
	;

additive_expression
	: multiplicative_expression {
		TR_LOGGER.PushReduction("multiplicative_expression -> additive_expression");
	}
	| additive_expression PLUS multiplicative_expression {
		TR_LOGGER.PushReduction(
			"additive_expression PLUS multiplicative_expression "
			"-> additive_expression");
	}
	| additive_expression MINUS multiplicative_expression {
		TR_LOGGER.PushReduction(
			"additive_expression MINUS multiplicative_expression "
			"-> additive_expression");
	}
	;

multiplicative_expression
	: cast_expression {
		TR_LOGGER.PushReduction("cast_expression -> multiplicative_expression");
	}
	| multiplicative_expression ASTERISK cast_expression {
		TR_LOGGER.PushReduction(
			"multiplicative_expression ASTERISK cast_expression "
			"-> multiplicative_expression");
	}
	| multiplicative_expression FORWARD_SLASH cast_expression {
		TR_LOGGER.PushReduction(
			"multiplicative_expression FORWARD_SLASH cast_expression "
			"-> multiplicative_expression");
	}
	| multiplicative_expression PERCENT cast_expression {
		TR_LOGGER.PushReduction(
			"multiplicative_expression PERCENT cast_expression "
			"-> multiplicative_expression");
	}
	;

cast_expression
	: unary_expression {
		TR_LOGGER.PushReduction("unary_expression -> cast_expression");
	}
	| OPEN_PAREN type_name CLOSE_PAREN cast_expression {
		TR_LOGGER.PushReduction(
			"OPEN_PAREN type_name CLOSE_PAREN cast_expression -> cast_expression");
	}
	;

unary_expression
	: postfix_expression {
		TR_LOGGER.PushReduction("postfix_expression -> unary_expression");
	}
	| INC_OP unary_expression {
		TR_LOGGER.PushReduction("INC_OP unary_expression -> unary_expression");
	}
	| DEC_OP unary_expression {
		TR_LOGGER.PushReduction("DEC_OP unary_expression -> unary_expression");
	}
	| unary_operator cast_expression {
		TR_LOGGER.PushReduction(
			"unary_operator cast_expression -> unary_expression");
	}
	| SIZEOF unary_expression {
		TR_LOGGER.PushReduction("SIZEOF unary_expression -> unary_expression");
	}
	| SIZEOF OPEN_PAREN type_name CLOSE_PAREN {
		TR_LOGGER.PushReduction(
			"SIZEOF OPEN_PAREN type_name CLOSE_PAREN -> unary_expression");
	}
	;

unary_operator
	: AMPERSAND {
		TR_LOGGER.PushReduction("AMPERSAND -> unary_operator");
	}
	| ASTERISK {
		TR_LOGGER.PushReduction("ASTERISK -> unary_operator");
	}
	| PLUS {
		TR_LOGGER.PushReduction("PLUS -> unary_operator");
	}
	| MINUS {
		TR_LOGGER.PushReduction("MINUS -> unary_operator");
	}
	| TILDE {
		TR_LOGGER.PushReduction("TILDE -> unary_operator");
	}
	| BANG {
		TR_LOGGER.PushReduction("BANG -> unary_operator");
	}
	;

postfix_expression
	: primary_expression {
		TR_LOGGER.PushReduction("primary_expression -> postfix_expression");
	}
	| postfix_expression OPEN_SQUARE expression CLOSE_SQUARE {
		TR_LOGGER.PushReduction(
			"postfix_expression OPEN_SQUARE expression CLOSE_SQUARE "
			"-> postfix_expression");
	}
	| postfix_expression OPEN_PAREN CLOSE_PAREN {
		TR_LOGGER.PushReduction(
			"postfix_expression OPEN_PAREN CLOSE_PAREN -> postfix_expression");
	}
	| postfix_expression OPEN_PAREN argument_expression_list CLOSE_PAREN {
		TR_LOGGER.PushReduction(
			"postfix_expression OPEN_PAREN argument_expression_list CLOSE_PAREN "
			"-> postfix_expression");
	}
	| postfix_expression DOT identifier {
		TR_LOGGER.PushReduction(
			"postfix_expression DOT identifier -> postfix_expression");
	}
	| postfix_expression PTR_OP identifier {
		TR_LOGGER.PushReduction(
			"postfix_expression PTR_OP identifier -> postfix_expression");
	}
	| postfix_expression INC_OP {
		TR_LOGGER.PushReduction(
			"postfix_expression INC_OP -> postfix_expression");
	}
	| postfix_expression DEC_OP {
		TR_LOGGER.PushReduction(
			"postfix_expression DEC_OP -> postfix_expression");
	}
	;

primary_expression
	: identifier {
		TR_LOGGER.PushReduction("identifier -> primary_expression");
	}
	| constant {
		TR_LOGGER.PushReduction("constant -> primary_expression");
	}
	| string {
		TR_LOGGER.PushReduction("string -> primary_expression");
	}
	| OPEN_PAREN expression CLOSE_PAREN {
		TR_LOGGER.PushReduction(
			"OPEN_PAREN expression CLOSE_PAREN -> primary_expression");
	}
	;

argument_expression_list
	: assignment_expression {
		TR_LOGGER.PushReduction(
			"assignment_expression -> argument_expression_list");
	}
	| argument_expression_list COMMA assignment_expression {
		TR_LOGGER.PushReduction(
			"argument_expression_list COMMA assignment_expression "
			"-> argument_expression_list");
	}
	;

constant
	: INTEGER_CONSTANT {
		TR_LOGGER.PushReduction("INTEGER_CONSTANT -> constant");
	}
	| CHARACTER_CONSTANT {
		TR_LOGGER.PushReduction("CHARACTER_CONSTANT -> constant");
	}
	| FLOATING_CONSTANT {
		TR_LOGGER.PushReduction("FLOATING_CONSTANT -> constant");
	}
	| ENUMERATION_CONSTANT {
		TR_LOGGER.PushReduction("ENUMERATION_CONSTANT -> constant");
	}
	;

string
	: STRING_LITERAL {
		TR_LOGGER.PushReduction("STRING_LITERAL -> string");
	}
	;

identifier
	: IDENTIFIER {
		TR_LOGGER.PushReduction("IDENTIFIER -> identifier");
	}
	;

%%
/******************************************************************************/
/* User Written Code */
/******************************************************************************/
int main() {
	return yyparse(); 
}

void yyerror(const char * err) {
	printf("%s\n", err);
}

