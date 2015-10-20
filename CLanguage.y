/******************************************************************************/
/* Definitions */
/******************************************************************************/

/******************************************************************************/
/* TODOs 
/* Get function definitions correctly modifying things already in  table 	
/* 
/******************************************************************************/

%{
/* Included C/C++ Libraries */
#include <iostream>
#include <list>

/* Included Header Files */
#include  "CommandLineFlags.h"
#include  "TokenReductionsLogger.h"
#include 	"SymbolInfoUtil.h"

using namespace std;
%}

%code requires {
	#include  "SymbolTable.h"
	#define YYSTYPE std::list<SymbolInfo>
}

%{
/* Globals between flex and bison. These are declared in Globals.cpp. */
extern CommandLineFlags CL_FLAGS;
extern SymbolTable S_TABLE;
extern TokenReductionsLogger TR_LOGGER;
extern bool INSERT_MODE;
extern int LINE;
extern int COLUMN;

/* Functions from Flex */
extern int yylex();
void yyerror(const char * err);
%}

/* Expect 1 S/R conflict from dangling else */
%expect 1

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
		// Log reduction.
		TR_LOGGER.PushReduction("declaration_specifiers SEMI -> declaration");
		// Do nothing
	}
	| declaration_specifiers init_declarator_list SEMI {
		// Log reduction.
		TR_LOGGER.PushReduction(
			"declaration_specifiers init_declarator_list SEMI -> declaration");
		// Give each identifier in the list the type from the 
		// declaration specifiers.
		SymbolInfo* temp = S_TABLE.GetMostRecentSymbolInfo($2.front().identifier_name);
		temp->type_specifier_list = $1.front().type_specifier_list;
		for(auto qualifier : $1.front().type_qualifier_list) {
			temp->type_qualifier_list.push_back(qualifier);
		}
		temp->storage_class_specifier = $1.front().storage_class_specifier;

		if(!(IsTypeQualifierValid(*temp))) {
			TR_LOGGER.Error("Qualifier not valid.", LINE, COLUMN);
		}
	}
	;

declaration_list
	: {INSERT_MODE = true;} declaration {INSERT_MODE = false;} {
		TR_LOGGER.PushReduction("declaration -> declaration_list");
	}
	| declaration_list {INSERT_MODE = true;} declaration {INSERT_MODE = false;} {
		TR_LOGGER.PushReduction("delcaration_list declaration -> declaration_list");
	}
	;

declaration_specifiers
	: storage_class_specifier {
		// Log Reduction
		TR_LOGGER.PushReduction(
			"storage_class_specifier -> declaration_specifiers");
		// Pass through symbol info
		$$ = $1;
	}
	| storage_class_specifier declaration_specifiers {
		// Log Reduction
		TR_LOGGER.PushReduction(
			"storage_class_specifier declaration_specifiers "
			"-> declaration_specifiers");

		// Check if there has not been a prior storage class specifier.
		if($2.front().storage_class_specifier != SymbolTypes::NONE) {
			// Error if there has been another storage class specifier.
			TR_LOGGER.Error("Cannot have more than one storage class specifier.",
											LINE, COLUMN);
		} else {
			// Assign the storage_class_specifier none has been declare before
			$2.front().storage_class_specifier = $1.front().storage_class_specifier;
		}
		// Pass through $2
		$$ = $2;
	}
	| type_specifier {
		// Log Reduction
		TR_LOGGER.PushReduction("type_specifier -> declaration_specifiers");

		// Pass through symbol info
		$$ = $1;
	}
	| type_specifier declaration_specifiers {
		TR_LOGGER.PushReduction(
			"type_specifier declaration_specifiers -> declaration_specifiers");
		// Add type specifier to declaration specifier
		$2.front().type_specifier_list.push_front($1.front().type_specifier_list.front());
		$$ = $2;

		// Check if the data type is valid
		if(!(IsDataTypeValid($2.front()))) {
			TR_LOGGER.Error("Data Type not valid.", LINE, COLUMN);
		}
	}
	| type_qualifier {
		// Log reduction
		TR_LOGGER.PushReduction(
			"type_qualifier -> declaration_specifiers");
		// Pass through SymbolInfo
		$$ = $1;
	}
	| type_qualifier declaration_specifiers {
		// Log reduction
		TR_LOGGER.PushReduction(
			"type_qualifier declaration_specifiers -> declaration_specifiers");

		// Push type qualifier to the front
		$2.front().type_qualifier_list.push_front($1.front().type_qualifier_list.front());

		// Assign $$ to $2
		$$ = $2;

		// Check if the Type qualifier is valid if not Error.
		if(!(IsTypeQualifierValid($2.front()))) {
			TR_LOGGER.Error("Repeated type qualifier.", LINE, COLUMN);
		}
	}
	;

storage_class_specifier
	: AUTO {
		$$ = $1;
		TR_LOGGER.PushReduction("AUTO -> storage_class_specifier");
	}
	| REGISTER {
		$$ = $1;
		TR_LOGGER.PushReduction("REGISTER -> storage_class_specifier");
	}
	| STATIC {
		$$ = $1;
		TR_LOGGER.PushReduction("STATIC -> storage_class_specifier");
	}
	| EXTERN {
		$$ = $1;
		TR_LOGGER.PushReduction("EXTERN -> storage_class_specifier");
	}
	| TYPEDEF {
		$$ = $1;
		TR_LOGGER.PushReduction("TYPEDEF -> storage_class_specifier");
	}
	;

type_specifier
	: VOID {
		$$ = $1;
		TR_LOGGER.PushReduction("VOID -> type_specifier");
	}
	| CHAR {
		$$ = $1;
		TR_LOGGER.PushReduction("CHAR -> type_specifier");
	}
	| SHORT {
		$$ = $1;
		TR_LOGGER.PushReduction("SHORT -> type_specifier");
	}
	| INT  {
		$$ = $1;
		TR_LOGGER.PushReduction("INT -> type_specifier");
	}
	| LONG {
		$$ = $1;
		TR_LOGGER.PushReduction("LONG -> type_specifier");
	}
	| FLOAT {
		$$ = $1;
		TR_LOGGER.PushReduction("FLOAT -> type_specifier");
	}
	| DOUBLE  {
		$$ = $1;
		TR_LOGGER.PushReduction("DOUBLE -> type_specifier");
	}
	| SIGNED  {
		$$ = $1;
		TR_LOGGER.PushReduction("SIGNED -> type_specifier");
	}
	| UNSIGNED {
		$$ = $1;
		TR_LOGGER.PushReduction("UNSIGNED -> type_specifier");
	}
	| struct_or_union_specifier {
		$$ = $1;
		TR_LOGGER.PushReduction("struct_or_union_specifier -> type_specifier");
	}
	| enum_specifier {
		$$ = $1;
		TR_LOGGER.PushReduction("enum_specifier -> type_specifier");
	}
	| TYPEDEF_NAME {
		$$ = $1;
		TR_LOGGER.PushReduction("TYPEDEF_NAME -> type_specifier");
	}
	;

type_qualifier
	: CONST  {
		$$ = $1;
		TR_LOGGER.PushReduction("CONST -> type_qualifier");
	}
	| VOLATILE {
		$$ = $1;
		TR_LOGGER.PushReduction("VOLATILE -> type_qualifier");
	}
	;

struct_or_union_specifier
	: struct_or_union identifier open_curly struct_declaration_list close_curly {
		// Log Reduction
		TR_LOGGER.PushReduction("struct_or_union identifier open_curly "
														"struct_declaration_list close_curly "
														"-> struct_or_union_specifier");
		// Copy the symbol table from the struct declaration list.



	}
	| struct_or_union open_curly struct_declaration_list close_curly {
		TR_LOGGER.PushReduction("struct_or_union open_curly "
														"struct_declaration_list close_curly "
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
		// Log Reduction
		TR_LOGGER.PushReduction("init_declarator -> init_declarator_list");
		// Pass through
		$$ = $1;
	}
	| init_declarator_list COMMA init_declarator {
		// Log Reduction
		TR_LOGGER.PushReduction(
			"init_declarator_list COMMA init_declarator -> init_declarator_list");

		// Add new declarator to the back and pass through
		$$ = $1;
	}
	;

init_declarator
	: declarator {
		// Log reduction
		TR_LOGGER.PushReduction("declarator -> init_declarator");
		// Pass through
		$$ = $1;
	}
	| declarator EQUALS_SIGN initializer {
		// Log reduction
		TR_LOGGER.PushReduction(
			"declarator EQUALS_SIGN initializer -> init_declarator");
		// Assign value of declarator to the initializer
		

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
	: ENUM open_curly enumerator_list close_curly {
		TR_LOGGER.PushReduction(
			"ENUM open_curly enumerator_list close_curly -> enum_specifier");
	}
	| ENUM identifier open_curly enumerator_list close_curly {
		TR_LOGGER.PushReduction(
			"ENUM identifier open_curly enumerator_list close_curly "
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
		// Log reduction
		TR_LOGGER.PushReduction("direct_declarator -> declarator");

		// Pass through
		$$ = $1;
	}
	| pointer direct_declarator {
		// Log reduction
		TR_LOGGER.PushReduction("pointer direct_declarator -> declarator");

		// Combine type qualifier lists
		cout << "HERE: " << $1.front().type_qualifier_list.size() << endl;

		for(list<SymbolTypes::TypeQualifier>::iterator iter = $1.front().type_qualifier_list.begin();
		iter != $1.front().type_qualifier_list.end(); iter++) {
			cout << "PUSHING: " << *iter << endl;
			$2.front().type_qualifier_list.push_back(*iter);
		}

		for(list<SymbolTypes::TypeQualifier>::iterator iter = $2.front().type_qualifier_list.begin();
		iter != $2.front().type_qualifier_list.end(); iter++) {
			cout << "PUSHED: " << *iter << endl;
		}

		if(!(IsTypeQualifierValid($2.front()))){
			TR_LOGGER.Error("Qualifier is invalid.", LINE, COLUMN);
		}

		// Copy array_sizes
		for(int array_size : $1.front().array_sizes) {
			$2.front().array_sizes.push_back(array_size);
		}

		// Get the symbol in the symbol table and assign it to what is here.
		SymbolInfo* temp = S_TABLE.GetMostRecentSymbolInfo($2.front().identifier_name);
		*temp = $2.front();

		for(list<SymbolTypes::TypeQualifier>::iterator iter = temp->type_qualifier_list.begin();
		iter != temp->type_qualifier_list.end(); iter++) {
			cout << "ST_HAS: " << *iter << endl;
		}

		$$ = $2;
	}
	;

direct_declarator
	: identifier {
		// Log reduction
		TR_LOGGER.PushReduction("identifier -> direct_declarator");

		// Pass through
		$$ = $1;
	}
	| OPEN_PAREN declarator CLOSE_PAREN {
		TR_LOGGER.PushReduction(
			"OPEN_PAREN declarator CLOSE_PAREN -> direct_declarator");
	}
	| direct_declarator OPEN_SQUARE CLOSE_SQUARE {
		// Log Reduction
		TR_LOGGER.PushReduction(
			"direct_declarator OPEN_SQUARE CLOSE_SQUARE -> direct_declarator");

		if($1.front().is_function) {
			TR_LOGGER.Error("Cannot make an array from a function.", LINE, COLUMN);
		}

		// Push back the new array size
		$1.front().array_sizes.push_back(SymbolTypes::NO_ARRAY_SIZE);

		// Get the symbol in the symbol table and assign it to what is here.
		SymbolInfo* temp = S_TABLE.GetMostRecentSymbolInfo($1.front().identifier_name);
		*temp = $1.front();

		// Pass through
		$$ = $1;
	}
	| direct_declarator OPEN_SQUARE constant_expression CLOSE_SQUARE {
		TR_LOGGER.PushReduction(
			"direct_declarator OPEN_SQUARE constant_expression CLOSE_SQUARE "
			"-> direct_declarator");
	}
	| direct_declarator open_paren_scope close_paren_scope {
		// Log Reduction
		TR_LOGGER.PushReduction(
			"direct_declarator OPEN_PAREN CLOSE_PAREN -> direct_declarator");

		// Error if identifier is already a function
		if($1.front().is_function) {
			TR_LOGGER.Error("Identifier already declared as a function",
										  LINE, COLUMN);
		}

		// Error if declared as an array
		if($1.front().array_sizes.size() > 0) {
			TR_LOGGER.Error("Identifier already declared as an array", LINE, COLUMN);
		}

		// Push set to be a function
		$1.front().is_function = true;

		// Get the symbol in the symbol table and assign it to what is here.
		SymbolInfo* temp = S_TABLE.GetMostRecentSymbolInfo($1.front().identifier_name);
		*temp = $1.front();

		// Pass through
		$$ = $1;
	}
	| direct_declarator open_paren_scope parameter_type_list close_paren_scope  {
		TR_LOGGER.PushReduction(
			"direct_declarator OPEN_PAREN parameter_type_list CLOSE_PAREN "
			"-> direct_declarator");
	}
	| direct_declarator open_paren_scope identifier_list close_paren_scope {
		// Log Reduction
		TR_LOGGER.PushReduction(
			"direct_declarator OPEN_PAREN identifier_list CLOSE_PAREN "
			"-> direct_declarator");

		// Error if identifier is already a function
		if($1.front().is_function) {
			TR_LOGGER.Error("Identifier already declared as a function",
										  LINE, COLUMN);
		}

		// Error if declared as an array
		if($1.front().array_sizes.size() > 0) {
			TR_LOGGER.Error("Identifier already declared as an array", LINE, COLUMN);
		}

		// Define it to be a function
		$1.front().is_function = true;

		// Define the function to take in integers based on the num of identifiers
		for(int i = 0; i < $3.size(); i++) {
			FunctionParameter temp;
			temp.type_specifier_list.push_back(SymbolTypes::INT);
			$1.front().parameters_types.push_back(temp);
		}

		// Get the symbol in the symbol table and assign it to what is here.
		SymbolInfo* temp = S_TABLE.GetMostRecentSymbolInfo($1.front().identifier_name);
		*temp = $1.front();

		// Pass through
		$$ = $1;
	}
	;

open_paren_scope 
	: OPEN_PAREN {
		S_TABLE.PushFrame();
	}
	;

close_paren_scope
	: CLOSE_PAREN {
		S_TABLE.PopFrame();
	}
	;

pointer
	: ASTERISK {
		// Log reduction.
		TR_LOGGER.PushReduction("ASTERISK -> pointer");

		$$ = *(new list<SymbolInfo>());
		$$.push_back(*(new SymbolInfo()));
		$$.front().array_sizes.push_back(SymbolTypes::NO_ARRAY_SIZE);
	}
	| ASTERISK type_qualifier_list {
		// Log reduction
		TR_LOGGER.PushReduction("ASTERISK type_qualifier_list -> pointer");

		// Push back an undefined array size.
		$2.front().array_sizes.push_back(SymbolTypes::NO_ARRAY_SIZE);

		// Pass through
		$$ = $2;
	}
	| ASTERISK pointer {
		// Log reduction
		TR_LOGGER.PushReduction("ASTERISK pointer -> pointer");

		// Push back an undefined array size.
		$2.front().array_sizes.push_back(SymbolTypes::NO_ARRAY_SIZE);

		$$ = $2;
	}
	| ASTERISK type_qualifier_list pointer {
		// Log reduction
		TR_LOGGER.PushReduction("ASTERISK type_qualifier_list pointer -> pointer");

		// Push back an undefined array size.
		for(int size : $3.front().array_sizes) {
			$2.front().array_sizes.push_back(size);
		}
		$2.front().array_sizes.push_back(SymbolTypes::NO_ARRAY_SIZE);

		$$ = $2;
	}
	;

type_qualifier_list
	: type_qualifier {
		// Log reduction.
		TR_LOGGER.PushReduction("type_qualifier -> type_qualifier_list");

		$$ = $1;
	}
	| type_qualifier_list type_qualifier {
		// Log reduction
		TR_LOGGER.PushReduction(
			"type_qualifier_list type_qualifier -> type_qualifier_list");

		// Add type qualifier
		$1.front().type_qualifier_list.push_back($2.front().type_qualifier_list.front());

		// Check type qualifier
		if(!(IsTypeQualifierValid($1.front()))) {
			TR_LOGGER.Error("Invalid Qualifier.", LINE, COLUMN);
		}
		$$ = $1;
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
		// Log reduction
		TR_LOGGER.PushReduction(
			"declaration_specifiers declarator -> parameter_declaration");

		// Pass through declaration_specifiers
		$$ = $1;
	}
	| declaration_specifiers  {
		// Log reduction
		TR_LOGGER.PushReduction("declaration_specifiers -> parameter_declaration");

		// Pass through declaration_specifiers
		$$ = $1;
	}
	| declaration_specifiers abstract_declarator {
		TR_LOGGER.PushReduction(
			"declaration_specifiers abstract_declarator -> parameter_declaration");
	}
	;

identifier_list
	: identifier {
		// Log Reduction
		TR_LOGGER.PushReduction("identifier -> identifier_list");

		cout << $1.size() << " " ;

		// Pass through
		$$ = $1; 
	}
	| identifier_list COMMA identifier {
		// Log reduction
		TR_LOGGER.PushReduction(
			"identifier_list COMMA identifier -> identifier_list");

		// Add identifier to the list
		$1.push_back($3.front());

		// Pass through
		$$ = $1;
	}
	;

initializer
	: assignment_expression {
		TR_LOGGER.PushReduction("assignment_expression -> initializer");
	}
	| open_curly initializer_list close_curly  {
		TR_LOGGER.PushReduction(
			"open_curly initializer_list close_curly -> initializer");
	}
	| open_curly initializer_list COMMA close_curly {
		TR_LOGGER.PushReduction(
			"open_curly initializer_list COMMA close_curly -> initializer");
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
	: open_curly close_curly {
		TR_LOGGER.PushReduction("open_curly close_curly -> expression_statement");
	}
	| open_curly statement_list close_curly {
		TR_LOGGER.PushReduction(
			"open_curly statement_list close_curly -> expression_statement");
	}
	| open_curly declaration_list close_curly {
		TR_LOGGER.PushReduction(
			"open_curly declaration_list close_curly -> expression_statement");
	}
	| open_curly declaration_list statement_list 
		close_curly {
		TR_LOGGER.PushReduction(
			"open_curly declaration_list statement_list close_curly "
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
			if($2.front().data_value.long_long_val == 0) {
			// Error division by 0
			TR_LOGGER.Error("Cannot divide by 0, seriously, stop that.",
											LINE, COLUMN);
			}
		TR_LOGGER.PushReduction(
			"multiplicative_expression FORWARD_SLASH cast_expression "
			"-> multiplicative_expression");
	}
	| multiplicative_expression PERCENT cast_expression {
		// Log reduction
		TR_LOGGER.PushReduction(
			"multiplicative_expression PERCENT cast_expression "
			"-> multiplicative_expression");
		// Check if the $3 is equal to zero
	}
	;

cast_expression
	: unary_expression {
		// Log reduction
		TR_LOGGER.PushReduction("unary_expression -> cast_expression");

		// Pass through
		$$ = $1;
	}
	| OPEN_PAREN type_name CLOSE_PAREN cast_expression {
		// Log Error
		TR_LOGGER.PushReduction(
			"OPEN_PAREN type_name CLOSE_PAREN cast_expression -> cast_expression");

		// Check down casting / up casting
	}
	;

unary_expression
	: postfix_expression {
		// Log reduction
		TR_LOGGER.PushReduction("postfix_expression -> unary_expression");
		// Pass through
		$$ = $1;
	}
	| INC_OP unary_expression {
		// Log reduction
		TR_LOGGER.PushReduction("INC_OP unary_expression -> unary_expression");

		// Check if the increment operation is possible
		if(!IsDataTypeValidForIncDec($2.front())) { // Check if it is a regular type
			TR_LOGGER.Error("Data type invalid for incrementation.", LINE, COLUMN);
		}
		if(IsConst($2.front())) { // Check if const
			TR_LOGGER.Error("Const value cannot be incremented.", LINE, COLUMN);
		}
		if(!S_TABLE.Has($2.front().identifier_name)) { // Check if it is an lval
			TR_LOGGER.Error("Lval needed for increment operation.", LINE, COLUMN);
		}
		
		// Pass through
		SymbolInfo* temp = 
				S_TABLE.GetMostRecentSymbolInfo($2.front().identifier_name);
		// TODO: Overflow Checking
		IncrementSymbolInfoBy(temp, 1);
		$$ = *(new list<SymbolInfo>({*(new SymbolInfo(*temp))}));
	}
	| DEC_OP unary_expression {
		// Log reduction
		TR_LOGGER.PushReduction("DEC_OP unary_expression -> unary_expression");

		// Check if the increment operation is possible
		if(!IsDataTypeValidForIncDec($2.front())) { // Check if it is a regular type
			TR_LOGGER.Error("Data type invalid for incrementation.", LINE, COLUMN);
		}
		if(IsConst($2.front())) { // Check if const
			TR_LOGGER.Error("Const value cannot be incremented.", LINE, COLUMN);
		}
		if(!S_TABLE.Has($2.front().identifier_name)) { // Check if it is an lval
			TR_LOGGER.Error("Lval needed for increment operation.", LINE, COLUMN);
		}
		
		// Pass through
		SymbolInfo* temp = 
				S_TABLE.GetMostRecentSymbolInfo($2.front().identifier_name);
		// TODO: Overflow Checking
		IncrementSymbolInfoBy(temp, -1);
		$$ = *(new list<SymbolInfo>({*(new SymbolInfo(*temp))}));
	}
	| AMPERSAND cast_expression {
		// Log reduction
		TR_LOGGER.PushReduction("AMPERSAND cast_expression -> unary_expression");

		// Check to see if it is an lval
		if(!S_TABLE.Has($2.front().identifier_name)) { // Check if it is an lval
			TR_LOGGER.Error("Lval needed for increment operation.", LINE, COLUMN);
		}

		$2.front().identifier_name = "";
		$2.front().array_sizes.push_back(SymbolTypes::NO_ARRAY_SIZE);
		$$ = $2;
	}
	| ASTERISK cast_expression {
		// Log reduction.
		TR_LOGGER.PushReduction("ASTERISK cast_expression -> unary_expression");

		// Check if it can be dereferenced.
		if($2.front().array_sizes.size() == 0) {
			TR_LOGGER.Error("Address needed for dereference.", LINE, COLUMN);
		}

		// Identifier name is no longer needed
		$2.front().identifier_name = "";

		// Dereference
		$2.front().array_sizes.pop_back();
		$$ = $2;
	}
	| PLUS cast_expression {
		// Log reduction
		TR_LOGGER.PushReduction("PLUS cast_expression -> unary_expression");

		// Make the data_value positive. Probably something like pushing a 0 to the 
		// highest bit.
		if($2.front().data_is_valid){
			if(IsNumber($2.front()) ){

				if( (($2.front().data_value.long_long_val) < 0) ){
				$$.front().data_value.long_long_val = (-1)*($2.front().data_value.long_long_val);
				}
			}
			else{
				TR_LOGGER.Error("Unkown type conversion, check that data is of type, char, int, or double.", LINE, COLUMN);
			}
		}
	}
	| MINUS cast_expression {
		// Log reduction
		TR_LOGGER.PushReduction("MINUS cast_expression -> unary_expression");

		// Check if unsigned. TODO
		if($2.front().data_is_valid){
			if(IsNumber($2.front()) ){
				$$.front().data_value.long_long_val = (-1)*($2.front().data_value.long_long_val);
			}
			else{
				TR_LOGGER.Error("Unkown type conversion, check that data is of type, char, int, or double.", LINE, COLUMN);
			}
		}
	}
	| TILDE cast_expression {
		// Log reduction
		TR_LOGGER.PushReduction("TILDE cast_expression -> unary_expression");
		// Bitwise not operator 
		// Must be a number 
		if($2.front().data_is_valid){
			if(IsNumber($2.front()) ){
				$$.front().data_value.long_long_val = ~($2.front().data_value.long_long_val);
			}
			else{
				TR_LOGGER.Error("Unkown type conversion, check that data is of type, char, int, or double.", LINE, COLUMN);
			}
		}

		// ~n = -(n+1)
		// Do this and pass through 
	}
	| BANG cast_expression {
		// Log operation.
		TR_LOGGER.PushReduction("BANG cast_expression -> unary_expression");

		// if != 0 change to zero, change to 1 if not can be any number or pointer
		// !(R, P) -> {0,1} : P = pointer
	}
	| SIZEOF unary_expression {
		// Log operation.
		TR_LOGGER.PushReduction("SIZEOF unary_expression -> unary_expression");

		// Becomes an integer
	}
	| SIZEOF OPEN_PAREN type_name CLOSE_PAREN {
		// Log operation.
		TR_LOGGER.PushReduction(
			"SIZEOF OPEN_PAREN type_name CLOSE_PAREN -> unary_expression");

		// Becomes an integer
	}
	;


postfix_expression
	: primary_expression {
		// Log Reduction
		TR_LOGGER.PushReduction("primary_expression -> postfix_expression");
		// Pass through
		$$ = $1;
	}
	| postfix_expression OPEN_SQUARE expression CLOSE_SQUARE {
		// Log reduction.
		TR_LOGGER.PushReduction(
			"postfix_expression OPEN_SQUARE expression CLOSE_SQUARE "
			"-> postfix_expression");

		// Check and see if there is any array_sizes
		if($1.front().array_sizes.size() == 0) {
			TR_LOGGER.Error("Cannot use expression as an array.", LINE, COLUMN);
		}

		if(!(IsExpressionValidArraySubscript($3.front()))) {
			TR_LOGGER.Error("Cannot use expression as an array subscript.", 
											LINE, COLUMN);
		}
		// Create new symbol info to be placed in $$
		$$ = *(new list<SymbolInfo>());
		$$.push_front(*(new SymbolInfo($1.front())));

		// Update value such that $$ has one less pointer or array.
		if($1.front().array_sizes.size() > 0) {
			$$.front().array_sizes.pop_back();
		}
	}
	| postfix_expression OPEN_PAREN CLOSE_PAREN {
		// Log Reduction
		TR_LOGGER.PushReduction(
			"postfix_expression OPEN_PAREN CLOSE_PAREN -> postfix_expression");
		// Check if expression is a function
		if(!$1.front().is_function) {
			TR_LOGGER.Error("Cannot use expression as a function.", LINE, COLUMN);
		}
		if($1.front().parameters_types.size() != 0) {
			TR_LOGGER.Error("Invalid number of parameters.", LINE, COLUMN);
		} 

		// Create new symbol info to be placed in $$
		$$ = *(new list<SymbolInfo>());
		$$.push_front(*(new SymbolInfo($1.front())));

		// Change symbol info to act like it has been called.
		$$.front().data_is_valid = false;
		$$.front().is_function = false;
		$$.front().identifier_name = string("");
	}
	| postfix_expression OPEN_PAREN argument_expression_list CLOSE_PAREN {
		// Log reduction
		TR_LOGGER.PushReduction(
			"postfix_expression OPEN_PAREN argument_expression_list CLOSE_PAREN "
			"-> postfix_expression");
		// Check if expression is a function
		if(!$1.front().is_function) {
			TR_LOGGER.Error("Cannot use expression as a function.", LINE, COLUMN);
		}
		if($1.front().parameters_types.size() != $3.size()) {
			TR_LOGGER.Error("Invalid number of parameters.", LINE, COLUMN);
		} 
		// TODO: Check each parameter type

		// Create new symbol info to be placed in $$
		$$ = *(new list<SymbolInfo>());
		$$.push_front(*(new SymbolInfo($1.front())));

		// Change function
		$$.front().data_is_valid = false;
		$$.front().is_function = false;
		$$.front().identifier_name = string("");
	}
	| postfix_expression DOT identifier {
		// Struct operation hold off on this.
		// Log reduction
		TR_LOGGER.PushReduction(
			"postfix_expression DOT identifier -> postfix_expression");
	}
	| postfix_expression PTR_OP identifier {
		// Struct operation hold off on this.
		// Log Reduction
		TR_LOGGER.PushReduction(
			"postfix_expression PTR_OP identifier -> postfix_expression");
	}
	| postfix_expression INC_OP {
		// Log Reduction
		TR_LOGGER.PushReduction(
			"postfix_expression INC_OP -> postfix_expression");
		// Check if the increment operation is possible
		if(!IsDataTypeValidForIncDec($1.front())) { // Check if it is a regular type
			TR_LOGGER.Error("Data type invalid for incrementation.", LINE, COLUMN);
		}
		if(IsConst($1.front())) { // Check if const
			TR_LOGGER.Error("Const value cannot be incremented.", LINE, COLUMN);
		}
		if(!S_TABLE.Has($2.front().identifier_name)) { // Check if it is an lval
			TR_LOGGER.Error("Lval needed for increment operation.", LINE, COLUMN);
		}

		// Pass through
		SymbolInfo* temp = 
				S_TABLE.GetMostRecentSymbolInfo($1.front().identifier_name);
		// TODO: Overflow Checking
		temp->postfix_increment++;
		$$ = *(new list<SymbolInfo>({*(new SymbolInfo(*temp))}));
	}
	| postfix_expression DEC_OP {
		TR_LOGGER.PushReduction(
			"postfix_expression DEC_OP -> postfix_expression");
		// Check if the increment operation is possible
		if(!IsDataTypeValidForIncDec($1.front())) { // Check if it is a regular type
			TR_LOGGER.Error("Data type invalid for incrementation.", LINE, COLUMN);
		}
		if(IsConst($1.front())) { // Check if const
			TR_LOGGER.Error("Const value cannot be incremented.", LINE, COLUMN);
		}
		if(!S_TABLE.Has($2.front().identifier_name)) { // Check if it is an lval
			TR_LOGGER.Error("Lval needed for increment operation.", LINE, COLUMN);
		}

		// Pass through
		SymbolInfo* temp = 
				S_TABLE.GetMostRecentSymbolInfo($1.front().identifier_name);
		// TODO: Overflow Checking
		temp->postfix_increment++;
		$$ = *(new list<SymbolInfo>({*(new SymbolInfo(*temp))}));
	}
	;

primary_expression
	: identifier {
		// Log reduction.
		TR_LOGGER.PushReduction("identifier -> primary_expression");
		// Pass through
	}
	| constant {
		// Log reduction
		TR_LOGGER.PushReduction("constant -> primary_expression");
		// Pass through
	}
	| string {
		// Log reduction
		TR_LOGGER.PushReduction("string -> primary_expression");
		// Pass through
		$$ = $1;
	}
	| OPEN_PAREN expression CLOSE_PAREN {
		// Log reduction
		TR_LOGGER.PushReduction(
			"OPEN_PAREN expression CLOSE_PAREN -> primary_expression");
		// Pass through
		$$ = $1;
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
		$$ = $1;
		TR_LOGGER.PushReduction("INTEGER_CONSTANT -> constant");
	}
	| CHARACTER_CONSTANT {
		$$ = $1;
		TR_LOGGER.PushReduction("CHARACTER_CONSTANT -> constant");
	}
	| FLOATING_CONSTANT {
		$$ = $1;
		TR_LOGGER.PushReduction("FLOATING_CONSTANT -> constant");
	}
	| ENUMERATION_CONSTANT {
		$$ = $1;
		TR_LOGGER.PushReduction("ENUMERATION_CONSTANT -> constant");
	}
	;

string
	: STRING_LITERAL {
		$$ = $1;
		TR_LOGGER.PushReduction("STRING_LITERAL -> string");
	}
	;

identifier
	: IDENTIFIER {
		$$ = $1;
		TR_LOGGER.PushReduction("IDENTIFIER -> identifier");
	}
	;

open_curly
	: OPEN_CURLY {
		S_TABLE.PushFrame();
		INSERT_MODE = false;
		TR_LOGGER.PushReduction("OPEN_CURLY-> open_curly");
	}

close_curly
	: CLOSE_CURLY {
		S_TABLE.PopFrame();
		TR_LOGGER.PushReduction("CLOSE_CURLY -> close_curly");
	}

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

