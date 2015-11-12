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
#include <locale>

/* Included Header Files */
#include  "../src/helpers/CommandLineFlags.h"
#include  "../src/helpers/Escape_Sequences_Colors.h"
#include  "../src/helpers/TokenReductionsLogger.h"
#include  "../src/symbol_table/SymbolInfoUtil.h"

using namespace AST;
using namespace std;
%}

%code requires {
  #include  "../src/abstract_syntax_tree/Node.h"
  #include  "../src/symbol_table/SymbolTable.h"
  #define YYSTYPE std::list<SymbolInfo>
}

%{
/* Globals between flex and bison. These are declared in Globals.cpp. */
extern CommandLineFlags CL_FLAGS;
extern SymbolTable S_TABLE;
extern TokenReductionsLogger TR_LOGGER;
extern bool INSERT_MODE;
extern bool IN_SWITCH;
extern int LINE;
extern int COLUMN;
extern int IN_FUNCTION;

/* Functions from Flex */
extern int yylex();
void yyerror(const char * err);
extern FILE * yyin;
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
    // pass through
    Node * temp = new Node("Translation_Unit", $$.front().node);
    $$ = $1;
    $$.front().node = temp;
    $$.front().node->GenerateGraphviz("Translation_Unit");

  }
  | translation_unit external_declaration {
    TR_LOGGER.PushReduction(
      "translation_unit external_declaration -> translation_unit");
    $$ = $1;
    $$.front().node->AddChild($2.front().node);
    $$.front().node->GenerateGraphviz("Translation_Unit");
  }
  ;

external_declaration
  : function_definition {
    TR_LOGGER.PushReduction("function_definition -> external_declaration");

    SymbolInfo* temp = S_TABLE.GetMostRecentSymbolInfo($1.front().identifier_name);
    temp->function_defined = true;

    $$.front().node = new Node("External_Declaration", $$.front().node);
  }
  | declaration {
    TR_LOGGER.PushReduction("declaration -> external_declaration");

    if(IN_FUNCTION > 0) {
      IN_FUNCTION--;
      S_TABLE.PopFrame();
    }
    // pass through
    $$.front().node = new Node("Declaration", $$.front().node);
  }
  ;

function_definition
  : declarator compound_statement {
    // Log reduction.
    TR_LOGGER.PushReduction(
      "declarator compound_statement -> function_definition");

    // Check if $1 is function
    if(!$1.front().is_function) {
      TR_LOGGER.Error("Invalid function defininition.", LINE, COLUMN);
    }

    // Output warning
    TR_LOGGER.Warning("Function has no type specifier", LINE, COLUMN);

    // Give each identifier in the list the type from the 
    // declaration specifiers.
    SymbolInfo* temp = S_TABLE.GetMostRecentSymbolInfo($1.front().identifier_name);
    temp->type_specifier_list.push_front(SymbolTypes::INT);  

    $$ = $1;
  }
  | declarator declaration_list compound_statement {
    // Log reduction
    TR_LOGGER.PushReduction(
    "declarator declaration_list compound_statement "
    "-> function_definition");

    // Check if $1 is function
    if(!$1.front().is_function) {
      TR_LOGGER.Error("Invalid function defininition.", LINE, COLUMN);
    }

    // Output warning
    TR_LOGGER.Warning("Function has no type specifier", LINE, COLUMN);

    // Give each identifier in the list the type from the 
    // declaration specifiers.
    SymbolInfo* temp = S_TABLE.GetMostRecentSymbolInfo($1.front().identifier_name);
    temp->type_specifier_list.push_front(SymbolTypes::INT);

    $$ = $1;
  }
  | declaration_specifiers declarator compound_statement {
    // Log reduction.
    TR_LOGGER.PushReduction(
      "declaration_specifiers declarator compound_statement "
      "-> function_definition");

    // Check if $1 is function
    if(!$2.front().is_function) {
      TR_LOGGER.Error("Invalid function defininition.", LINE, COLUMN);
    }

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

    $$ = $2;
    Node * temp_node = new Node("Function_Definition");
    temp_node->AddChild($1.front().node);
    temp_node->AddChild($2.front().node);
    temp_node->AddChild($3.front().node);
    $$.front().node = temp_node;
  }
  | declaration_specifiers declarator declaration_list compound_statement {
    // Log reduction.
    TR_LOGGER.PushReduction(
      "declaration_specifiers declarator declaration_list compound_statement "
      "-> function_definition");

    // Check if $1 is function
    if(!$2.front().is_function) {
      TR_LOGGER.Error("Invalid function defininition.", LINE, COLUMN);
    }

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

    $$ = $2;
  }
  ;

declaration
  : declaration_specifiers SEMI {
    // Log reduction.
    TR_LOGGER.PushReduction("declaration_specifiers SEMI -> declaration");
    // Do nothing
    $$ = $1;
    $$.front().node = new Node("Empty_Declaration", $1.front().node);
  }
  | declaration_specifiers init_declarator_list SEMI {
    // Log reduction.
    TR_LOGGER.PushReduction(
      "declaration_specifiers init_declarator_list SEMI -> declaration");
    // Give each identifier in the list the type from the 
    // declaration specifiers.
    //TODO still working
    //$$.front().node = new Node("Declaration", $$.front().node);
    $$ = list<SymbolInfo>();
    $$.push_front(SymbolInfo());
    list<SymbolInfo*>* symbols_list = new list<SymbolInfo*>();

    for(auto info : $2){
      SymbolInfo* temp = S_TABLE.GetMostRecentSymbolInfo(info.identifier_name);
      temp->type_specifier_list = $1.front().type_specifier_list;
      for(auto qualifier : $1.front().type_qualifier_list) {
        temp->type_qualifier_list.push_back(qualifier);
      }
      temp->storage_class_specifier = $1.front().storage_class_specifier;

      if(!(IsTypeQualifierValid(*temp))) {
        TR_LOGGER.Error("Qualifier not valid.", LINE, COLUMN);
      }
      symbols_list->push_back(temp);
    }
    $$.front().node = new DeclarationNode(*symbols_list);
    $$.front().node->AddChild($1.front().node);
    $$.front().node->AddChild($2.front().node);
  }
  ;

declaration_list
  : {INSERT_MODE = true;} declaration {
    // Switch Insert mode
    INSERT_MODE = false;
    // Log reduction
    TR_LOGGER.PushReduction("declaration -> declaration_list");
    // Pass through
    $$ = $1;
    $$.front().node = new Node("Declaration_List", $2.front().node);
  }
  | declaration_list {INSERT_MODE = true;} declaration {
    // Switch Insert mode
    INSERT_MODE = false;
    // Log reduction
    TR_LOGGER.PushReduction("delcaration_list declaration -> declaration_list");
    // Pass through
    $$ = $1;
    $$.front().node->AddChild($3.front().node);
    $$.push_back($3.front());
  }
  ;

declaration_specifiers
  : storage_class_specifier {
    // Log Reduction
    TR_LOGGER.PushReduction(
      "storage_class_specifier -> declaration_specifiers");
    // Pass through symbol info
    $$ = $1;
    $$.front().node = new Node("Declaration_Specifiers", $$.front().node);
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
    $$.front().node->AddChild($1.front().node);
  }
  | type_specifier {
    // Log Reduction
    TR_LOGGER.PushReduction("type_specifier -> declaration_specifiers");

    // Pass through symbol info
    $$ = $1;
		$$.front().node = new Node("Declaration_Specifiers", $$.front().node);
  }
  | type_specifier declaration_specifiers {
    TR_LOGGER.PushReduction(
      "type_specifier declaration_specifiers -> declaration_specifiers");
    // Add type specifier to declaration specifier
    $2.front().type_specifier_list.push_front($1.front().type_specifier_list.front());
    $$ = $2;
    $$.front().node->AddChild($1.front().node);

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
    $$.front().node = new Node("Declaration_Specifiers", $$.front().node);
  }
  | type_qualifier declaration_specifiers {
    // Log reduction
    TR_LOGGER.PushReduction(
      "type_qualifier declaration_specifiers -> declaration_specifiers");

    // Push type qualifier to the front
    $2.front().type_qualifier_list.push_front($1.front().type_qualifier_list.front());

    // Assign $$ to $2
    $$ = $2;
    $$.front().node->AddChild($1.front().node);

    // Check if the Type qualifier is valid if not Error.
    if(!(IsTypeQualifierValid($2.front()))) {
      TR_LOGGER.Error("Repeated type qualifier.", LINE, COLUMN);
    }
  }
  ;

storage_class_specifier
  : AUTO {
    $$ = $1;
    $$.front().node = new Node("AUTO");
    TR_LOGGER.PushReduction("AUTO -> storage_class_specifier");
  }
  | REGISTER {
    $$ = $1;
    $$.front().node = new Node("REGISTER");
    TR_LOGGER.PushReduction("REGISTER -> storage_class_specifier");
  }
  | STATIC {
    $$ = $1;
    $$.front().node = new Node("STATIC");
    TR_LOGGER.PushReduction("STATIC -> storage_class_specifier");
  }
  | EXTERN {
    $$ = $1;
    $$.front().node = new Node("EXTERN");
    TR_LOGGER.PushReduction("EXTERN -> storage_class_specifier");
  }
  | TYPEDEF {
    $$ = $1;
    $$.front().node = new Node("TYPEDEF");
    TR_LOGGER.PushReduction("TYPEDEF -> storage_class_specifier");
  }
  ;

type_specifier
  : VOID {
    $$ = $1;
    $$.front().node = new Node("VOID");
    TR_LOGGER.PushReduction("VOID -> type_specifier");
  }
  | CHAR {
    $$ = $1;
    $$.front().node = new Node("CHAR");
    TR_LOGGER.PushReduction("CHAR -> type_specifier");
  }
  | SHORT {
    $$ = $1;
    $$.front().node = new Node("SHORT");
    TR_LOGGER.PushReduction("SHORT -> type_specifier");
  }
  | INT  {
    $$ = $1;
    $$.front().node = new Node("INT");
    TR_LOGGER.PushReduction("INT -> type_specifier");
  }
  | LONG {
    $$ = $1;
    $$.front().node = new Node("LONG");
    TR_LOGGER.PushReduction("LONG -> type_specifier");
  }
  | FLOAT {
    $$ = $1;
    $$.front().node = new Node("FLOAT");
    TR_LOGGER.PushReduction("FLOAT -> type_specifier");
  }
  | DOUBLE  {
    $$ = $1;
    $$.front().node = new Node("DOUBLE");
    TR_LOGGER.PushReduction("DOUBLE -> type_specifier");
  }
  | SIGNED  {
    $$ = $1;
    $$.front().node = new Node("SIGNED");
    TR_LOGGER.PushReduction("SIGNED -> type_specifier");
  }
  | UNSIGNED {
    $$ = $1;
    $$.front().node = new Node("UNSIGNED");
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
    $$.front().node = new Node("CONST");
    TR_LOGGER.PushReduction("CONST -> type_qualifier");
  }
  | VOLATILE {
    $$ = $1;
    $$.front().node = new Node("VOLATILE");
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
    TR_LOGGER.Warning("Structs and unions are unsupported.", LINE, COLUMN);


  }
  | struct_or_union open_curly struct_declaration_list close_curly {
    TR_LOGGER.PushReduction("struct_or_union open_curly "
                            "struct_declaration_list close_curly "
                            "-> struct_or_union_specifier");
    TR_LOGGER.Warning("Structs and unions are unsupported.", LINE, COLUMN);

  }
  | struct_or_union identifier {
    TR_LOGGER.PushReduction(
      "struct_or_union identifier -> struct_or_union_specifier");
    TR_LOGGER.Warning("Structs and unions are unsupported.", LINE, COLUMN);

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
    $$.front().node = new Node("Init_Declarator_List", $$.front().node);

    // Set insert mode
    INSERT_MODE = true;

  }
  | init_declarator_list COMMA init_declarator {
    // Log Reduction
    TR_LOGGER.PushReduction(
      "init_declarator_list COMMA init_declarator -> init_declarator_list");

    // Add new declarator to the back and pass through
    $1.push_back($3.front());
    $$ = $1;
    $$.front().node->AddChild($3.front().node);

    // Set insert mode
    INSERT_MODE = true;
  }
  ;

init_declarator
  : declarator {
    // Log reduction
    TR_LOGGER.PushReduction("declarator -> init_declarator");
    // Pass through
    $$ = $1;
    $$.front().node = new Node("Init_Declarator", $$.front().node);
  }
  | declarator EQUALS_SIGN initializer {
    //TODO for initializing and declaring a variable in the same line
    // Log reduction
    TR_LOGGER.PushReduction(
      "declarator EQUALS_SIGN initializer -> init_declarator");

    // declarator will take on type specifier list
    $1.front().type_specifier_list = $3.front().type_specifier_list;

    // Check if they are numbers
    if(!IsRelational($3.front())) {
      TR_LOGGER.Error("Cannot assign non relational type", 
                      LINE, COLUMN);
    }

    // Perform the 
    if($3.front().data_is_valid) {
      // Integer 
      if(IsInteger($3.front())) {
        if(IsUnsigned($3.front())) {
          $1.front().data_value.unsigned_long_long_val
            = $3.front().data_value.unsigned_long_long_val;
        } else {
          $1.front().data_value.long_long_val
            = $3.front().data_value.long_long_val;
        }
      }
      if(IsFloating($3.front())) {
        $1.front().data_value.double_val = $3.front().data_value.double_val;
      }
      $1.front().data_is_valid = true;
    } else {
      $1.front().data_is_valid = false;
    }

    SymbolInfo* temp = S_TABLE.GetMostRecentSymbolInfo($1.front().identifier_name);
    if(temp != NULL) *temp = $1.front();

    $$ = list<SymbolInfo>({*temp});
    $$.front().node = new Node("Init_declarator", $1.front().node);
    $$.front().node->AddChild($3.front().node);

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
    // Log reduction
    TR_LOGGER.PushReduction("type_specifier -> specifier_qualifier_list");

    // Pass through
    $$ = $1;
  }
  | type_specifier specifier_qualifier_list {
    // Log reduction
    TR_LOGGER.PushReduction(
      "type_specifier specifier_qualifier_list -> specifier_qualifier_list");

    // Add type specifier to declaration specifier
    $2.front().type_specifier_list.push_front($1.front().type_specifier_list.front());
    $$ = $2;

    // Check if the data type is valid
    if(!(IsDataTypeValid($2.front()))) {
      TR_LOGGER.Error("Data Type not valid.", LINE, COLUMN);
    }
  }
  | type_qualifier {
    // Log reduction.
    TR_LOGGER.PushReduction("type_qualifier -> specifier_qualifier_list");

    // Pass through
    $$ = $1;
  }
  | type_qualifier specifier_qualifier_list {
    // Log reduction.
    TR_LOGGER.PushReduction(
      "type_qualifier specifier_qualifier_list -> specifier_qualifier_list");

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
    $$.front().node = new Node("Declarator", $$.front().node);

    INSERT_MODE = false;

  }
  | pointer direct_declarator {
    //TODO for pointers
    // Log reduction
    TR_LOGGER.PushReduction("pointer direct_declarator -> declarator");

    // Combine type qualifier lists
    for(list<SymbolTypes::TypeQualifier>::iterator iter = $1.front().type_qualifier_list.begin();
    iter != $1.front().type_qualifier_list.end(); iter++) {
      $2.front().type_qualifier_list.push_back(*iter);
    }

    for(list<SymbolTypes::TypeQualifier>::iterator iter = $2.front().type_qualifier_list.begin();
    iter != $2.front().type_qualifier_list.end(); iter++) {
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

    $$ = $2;
  }
  ;

direct_declarator
  : identifier {
    // Log reduction
    TR_LOGGER.PushReduction("identifier -> direct_declarator");

    // Pass through
    $$ = $1;
    $$.front().node = new Node("Direct_Declarator", $$.front().node);
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
    $$.front().node->AddChild(new Node("ArrayDeclaration"));
  }
  | direct_declarator OPEN_SQUARE constant_expression CLOSE_SQUARE {
    TR_LOGGER.PushReduction(
      "direct_declarator OPEN_SQUARE constant_expression CLOSE_SQUARE "
      "-> direct_declarator");

    if($1.front().is_function) {
      TR_LOGGER.Error("Cannot make an array from a function.", LINE, COLUMN);
    }

    //check valid array subscripts
    if(IsExpressionValidArraySubscript($3.front())){
        if($3.front().data_is_valid){
        //push array size if valid data
        $1.front().array_sizes.push_back($3.front().data_value.long_long_val);
        }
        //if not push -1
        else{
        $1.front().array_sizes.push_back(-1);
        }
    }
    else{
    TR_LOGGER.Error("not valid array subscript",
                        LINE, COLUMN);
    }

    // Get the symbol in the symbol table and assign it to what is here.
    SymbolInfo* temp = S_TABLE.GetMostRecentSymbolInfo($1.front().identifier_name);
    *temp = $1.front();

    // Pass through
    $$ = $1;
    Node * temp_node = new Node("ArrayDeclaration");
    temp_node->AddChild($3.front().node);
    $$.front().node->AddChild(temp_node);
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
    $$.front().node = new Node("Direct_Declarator", $$.front().node);
  }
  | direct_declarator open_paren_scope parameter_type_list close_paren_scope  {
    // Log reduction
    TR_LOGGER.PushReduction(
      "direct_declarator OPEN_PAREN parameter_type_list CLOSE_PAREN "
      "-> direct_declarator");

    // Pass param type list and range start
    $1.front().parameters_types = $3.front().parameters_types;
    $1.front().range_start = $3.front().range_start;
    $1.front().is_function = true;

    // Get the symbol in the symbol table and assign it to what is here.
    SymbolInfo* temp = S_TABLE.GetMostRecentSymbolInfo($1.front().identifier_name);
    *temp = $1.front();

    $$ = $1;

    $$.front().node = new Node("Direct_Declarator", $$.front().node);
    Node * temp_node = new Node("Parameters");
    for(FunctionParameter param : $$.front().parameters_types) {
      temp_node->AddChild(new Node(param.identifier_name));
    }
    $$.front().node->AddChild(temp_node);
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
    IN_SWITCH = false;
    IN_FUNCTION++;
  }
  ;

pointer
  : ASTERISK {
    // Log reduction.
    TR_LOGGER.PushReduction("ASTERISK -> pointer");

    $$ = list<SymbolInfo>();
    $$.push_back(SymbolInfo());
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
    // Log reduction.
    TR_LOGGER.PushReduction("parameter_list -> parameter_type_list");

    // Pass through.
    $$ = $1;
  }
  | parameter_list COMMA ELLIPSIS {
    // Log reduction.
    TR_LOGGER.PushReduction(
      "parameter_list COMMA ELLIPSIS -> parameter_type_list");

    // Range start stuff
    $1.front().range_start = $1.front().parameters_types.size() + 1;
    $$ = $1;
  }
  ;

parameter_list
  : parameter_declaration {
    // Log reduction
    TR_LOGGER.PushReduction("parameter_declaration -> parameter_list");
    // Pass through
    $$ = $1;

    INSERT_MODE = true;
  }
  | parameter_list COMMA parameter_declaration {
    // Log reduction.
    TR_LOGGER.PushReduction(
      "parameter_list COMMA parameter_declaration -> parameter_list");
    // Push_back and pass through
    $1.front().parameters_types.push_back($3.front().parameters_types.front());
    $$ = $1;

    INSERT_MODE = true;

  }
  ;

parameter_declaration
  : declaration_specifiers declarator {
    // Log reduction
    TR_LOGGER.PushReduction(
      "declaration_specifiers declarator -> parameter_declaration");

    // Give each identifier in the list the type from the 
    // declaration specifiers.
    SymbolInfo* st_temp = S_TABLE.GetMostRecentSymbolInfo($2.front().identifier_name);
    st_temp->type_specifier_list = $1.front().type_specifier_list;
    for(auto qualifier : $1.front().type_qualifier_list) {
      st_temp->type_qualifier_list.push_back(qualifier);
    }
    st_temp->storage_class_specifier = $1.front().storage_class_specifier;

    FunctionParameter* temp = new FunctionParameter();

    temp->type_specifier_list = $1.front().type_specifier_list;
    temp->type_qualifier_list = $1.front().type_qualifier_list;
    temp->storage_class_specifier = $1.front().storage_class_specifier;

    for(auto qualifier : $2.front().type_qualifier_list) {
      temp->type_qualifier_list.push_back(qualifier);
    }

    temp->array_sizes = $2.front().array_sizes;
    temp->identifier_name = $2.front().identifier_name;

    $2.front().parameters_types.push_front(*temp);

    $$ = $2;
  }
  | declaration_specifiers  {
    // Log reduction
    TR_LOGGER.PushReduction("declaration_specifiers -> parameter_declaration");

    FunctionParameter* temp = new FunctionParameter();

    temp->type_specifier_list = $1.front().type_specifier_list;
    temp->type_qualifier_list = $1.front().type_qualifier_list;
    temp->storage_class_specifier = $1.front().storage_class_specifier;
    temp->identifier_name = "NO_IDENTIFIER_NAME";


    $1.front().parameters_types.push_front(*temp);

    // Pass through declaration_specifiers
    $$ = $1;
  }
  | declaration_specifiers abstract_declarator {
    // Log reduction
    TR_LOGGER.PushReduction(
      "declaration_specifiers abstract_declarator -> parameter_declaration");
    
    TR_LOGGER.Warning("abstract_declarator not implemented.", LINE, COLUMN);

    $$ = $2;
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
    // Log Reduction.
    TR_LOGGER.PushReduction("assignment_expression -> initializer");
    $$ = $1;
  }
  | open_curly initializer_list close_curly  {
    // Log Reduction.
    TR_LOGGER.PushReduction(
      "open_curly initializer_list close_curly -> initializer");
    TR_LOGGER.Warning("initializer_list is unsupported.", LINE, COLUMN);
  }
  | open_curly initializer_list COMMA close_curly {
    TR_LOGGER.PushReduction(
      "open_curly initializer_list COMMA close_curly -> initializer");
    TR_LOGGER.Warning("initializer_list is unsupported.", LINE, COLUMN);
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
    // Log reduction.
    TR_LOGGER.PushReduction("specifier_qualifier_list -> type_name");

    // Pass through
    $$ = $1;
  }
  | specifier_qualifier_list abstract_declarator {
    // Ain't gonna do this.
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
    // Log reduction
    TR_LOGGER.PushReduction("compound_statement -> statement");
    $$ = $1;
  }
  | expression_statement {
    // Log reduction
    TR_LOGGER.PushReduction("expression_statement -> statement");

    // Pass through
    $$ = $1;
  }
  | selection_statement {
    // Log reduction
    TR_LOGGER.PushReduction("selection_statement -> statement");

    //Pass through
    $$ = $1;
  }
  | iteration_statement {
    // Log reduction.
    TR_LOGGER.PushReduction("iteration_statement -> statement");

    // Pass through
    $$ = $1;
    $$.front().node = new Node("Statement", $$.front().node);
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
      if(!IN_SWITCH){
      TR_LOGGER.Error("CASE reached outside of Switch scope", LINE, COLUMN);
    }
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
    // Log reduction
    TR_LOGGER.PushReduction("expression SEMI -> expression_statement");

    // Pass through
    $$ = $1;
    $$.front().node = new Node("Expression_Statement", $$.front().node);
  }
  ;

compound_statement
  : open_curly close_curly {
    // Log Reduction
    TR_LOGGER.PushReduction("open_curly close_curly -> compound_statement");

    // Check if it is in a function.
    if(IN_FUNCTION > 0) {
      IN_FUNCTION--;
      S_TABLE.PopFrame();
    }

    // Pass through
    $$ = list<SymbolInfo>({SymbolInfo()});
    $$.front().node = new Node("Compound_Statement");
  }
  | open_curly statement_list close_curly {
    TR_LOGGER.PushReduction(
      "open_curly statement_list close_curly -> compound_statement");

    if(IN_FUNCTION > 0) {
      IN_FUNCTION--;
      S_TABLE.PopFrame();
    }

    // Pass through
    $$ = list<SymbolInfo>({SymbolInfo()});
    $$.front().node = new Node("Compound_Statement", $2.front().node);
  }
  | open_curly declaration_list close_curly {
    TR_LOGGER.PushReduction(
      "open_curly declaration_list close_curly -> compound_statement");

    if(IN_FUNCTION > 0) {
      IN_FUNCTION--;
      S_TABLE.PopFrame();
    }
    $$.front().node = new Node("Compound_Statement", $2.front().node);
  }
  | open_curly declaration_list statement_list 
    close_curly {
    TR_LOGGER.PushReduction(
      "open_curly declaration_list statement_list close_curly "
      "-> compound_statement");

    if(IN_FUNCTION > 0) {
      IN_FUNCTION--;
      S_TABLE.PopFrame();
    }

    $$.front().node = new Node("Compound_Statement", $2.front().node);
    $$.front().node->AddChild($3.front().node);
  }
  ;

statement_list
  : statement {
    // Log Reduction
    TR_LOGGER.PushReduction("statement -> statement_list");

    // Pass through
    $$ = $1;
    $$.front().node = new Node("Statement_List", $$.front().node);
  }
  | statement_list statement {
    // Log Reduction
    TR_LOGGER.PushReduction("statement_list statement -> statement_list");

    // Pass through
    $$ = $1;
    $$.front().node->AddChild($2.front().node);
  }
  ;

selection_statement
  : IF OPEN_PAREN expression CLOSE_PAREN statement {
    // Log Reduction
    TR_LOGGER.PushReduction(
      "IF OPEN_PAREN expression CLOSE_PAREN statement "
      "-> selection_statement");

    $$ = list<SymbolInfo>({SymbolInfo()});
    $$.front().node = new SelectionNode();
    $$.front().node->AddChild($3.front().node);
    if($5.size() > 0 && $5.front().node != NULL) {
      $$.front().node->AddChild($5.front().node);
    }
  }
  | IF OPEN_PAREN expression CLOSE_PAREN statement ELSE statement {
    TR_LOGGER.PushReduction(
      "IF OPEN_PAREN expression CLOSE_PAREN statement ELSE statement "
      "-> selection_statement");

    // Pass through
    $$ = list<SymbolInfo>({SymbolInfo()});
    $$.front().node = new SelectionNode();
    $$.front().node->AddChild($3.front().node);
    if($5.size() > 0 && $5.front().node != NULL) {
      $$.front().node->AddChild($5.front().node);
    }
    if($7.size() > 0 && $7.front().node != NULL ) {
      $$.front().node->AddChild($7.front().node);
    } 
  }
  | SWITCH OPEN_PAREN expression CLOSE_PAREN statement  {
    TR_LOGGER.PushReduction(
      "SWITCH OPEN_PAREN expression CLOSE_PAREN statement "
      "-> selection_statement");
  }
  ;

iteration_statement
  : WHILE OPEN_PAREN expression CLOSE_PAREN statement {
    // Log Reduction
    TR_LOGGER.PushReduction(
      "WHILE OPEN_PAREN expression CLOSE_PAREN statement "
      "-> iteration_statement");

    // Pass through AST Node
    $$ = list<SymbolInfo>({SymbolInfo()});
    $$.front().node = new IterationNode();
    $$.front().node->AddChild(NULL);
    $$.front().node->AddChild($3.front().node);
    $$.front().node->AddChild(NULL);
    $$.front().node->AddChild(NULL);
    if($5.size() > 0 && $5.front().node != NULL) {
      $$.front().node->AddChild($5.front().node);
    }
  }
  | DO statement WHILE OPEN_PAREN expression CLOSE_PAREN SEMI {
    // Log reduction
    TR_LOGGER.PushReduction(
      "DO statement WHILE OPEN_PAREN expression CLOSE_PAREN SEMI "
      "-> iteration_statement");

    // Pass through AST Node
    $$ = list<SymbolInfo>({SymbolInfo()});
    bool is_post_check(true);
    $$.front().node = new IterationNode(is_post_check);
    $$.front().node->AddChild($5.front().node);
    $$.front().node->AddChild(NULL);
    $$.front().node->AddChild(NULL);
    $$.front().node->AddChild(NULL);
    if($2.size() > 0 && $2.front().node != NULL) {
      $$.front().node->AddChild($2.front().node);
    }
  }
  | FOR OPEN_PAREN SEMI SEMI CLOSE_PAREN statement {
    // Log reduction
    TR_LOGGER.PushReduction(
      "FOR OPEN_PAREN SEMI SEMI CLOSE_PAREN statement -> iteration_statement");

    // Pass through AST Node
    $$ = list<SymbolInfo>({SymbolInfo()});
    $$.front().node = new IterationNode();
    $$.front().node->AddChild(NULL);
    $$.front().node->AddChild(NULL);
    $$.front().node->AddChild(NULL);
    if($6.size() > 0 && $6.front().node != NULL) {
      $$.front().node->AddChild($6.front().node);
    }
  }
  | FOR OPEN_PAREN SEMI SEMI expression CLOSE_PAREN statement {
    // Log Reduction
    TR_LOGGER.PushReduction(
      "FOR OPEN_PAREN SEMI SEMI expression CLOSE_PAREN statement "
      "-> iteration_statement");

    // Pass through AST Node
    $$ = list<SymbolInfo>({SymbolInfo()});
    $$.front().node = new IterationNode();
    $$.front().node->AddChild(NULL);
    $$.front().node->AddChild(NULL);
    if($5.size() > 0 && $5.front().node != NULL) {
      $$.front().node->AddChild($5.front().node);
    }
    if($7.size() > 0 && $7.front().node != NULL) {
      $$.front().node->AddChild($7.front().node);
    }
  }
  | FOR OPEN_PAREN SEMI expression SEMI CLOSE_PAREN statement {
    // Log Reduction
    TR_LOGGER.PushReduction(
      "FOR OPEN_PAREN SEMI expression SEMI CLOSE_PAREN statement "
      "-> iteration_statement");

    // Pass through AST Node
    $$ = list<SymbolInfo>({SymbolInfo()});
    $$.front().node = new IterationNode();
    $$.front().node->AddChild(new Node("Expression"));
    $$.front().node->AddChild(NULL);
    if($4.size() > 0 && $4.front().node != NULL) {
      $$.front().node->AddChild($4.front().node);
    }
    $$.front().node->AddChild(NULL);
    if($7.size() > 0 && $7.front().node != NULL) {
      $$.front().node->AddChild($7.front().node);
    }
  }
  | FOR OPEN_PAREN SEMI expression SEMI expression CLOSE_PAREN statement {
    // Log Reduction
    TR_LOGGER.PushReduction(
      "FOR OPEN_PAREN SEMI expression SEMI expression CLOSE_PAREN statement "
      "-> iteration_statement");
    // Pass through AST Node
    $$ = list<SymbolInfo>({SymbolInfo()});
    $$.front().node = new IterationNode();
    $$.front().node->AddChild(new Node("Expression"));
    $$.front().node->AddChild(NULL);
    if($4.size() > 0 && $4.front().node != NULL) {
      $$.front().node->AddChild($4.front().node);
    }
    if($6.size() > 0 && $6.front().node != NULL) {
      $$.front().node->AddChild($6.front().node);
    }
    if($8.size() > 0 && $8.front().node != NULL) {
      $$.front().node->AddChild($8.front().node);
    }
  }
  | FOR OPEN_PAREN expression SEMI SEMI CLOSE_PAREN statement {
    // Log Reduction
    TR_LOGGER.PushReduction(
      "FOR OPEN_PAREN expression SEMI SEMI CLOSE_PAREN statement "
      "-> iteration_statement");

    // Pass through AST Node
    $$ = list<SymbolInfo>({SymbolInfo()});
    $$.front().node = new IterationNode();
    if($3.size() > 0 && $3.front().node != NULL) {
      $$.front().node->AddChild($3.front().node);
    }
    $$.front().node->AddChild(NULL);
    $$.front().node->AddChild(NULL);
    if($7.size() > 0 && $7.front().node != NULL) {
      $$.front().node->AddChild($7.front().node);
    }
  }
  | FOR OPEN_PAREN expression SEMI SEMI expression CLOSE_PAREN statement {
    // Log reduction
    TR_LOGGER.PushReduction(
      "FOR OPEN_PAREN expression SEMI SEMI expression CLOSE_PAREN statement "
      "-> iteration_statement");

    // Pass through AST Node
    $$ = list<SymbolInfo>({SymbolInfo()});
    $$.front().node = new IterationNode();
    if($3.size() > 0 && $3.front().node != NULL) {
      $$.front().node->AddChild($3.front().node);
    }
    $$.front().node->AddChild(NULL);
    if($6.size() > 0 && $6.front().node != NULL) {
      $$.front().node->AddChild($6.front().node);
    }
    if($8.size() > 0 && $8.front().node != NULL) {
      $$.front().node->AddChild($8.front().node);
    }
  }
  | FOR OPEN_PAREN expression SEMI expression SEMI CLOSE_PAREN statement {
    // Log reduction.
    TR_LOGGER.PushReduction(
      "FOR OPEN_PAREN expression SEMI expression SEMI CLOSE_PAREN statement "
      "-> iteration_statement");
    
    // Pass through AST Node
    $$ = list<SymbolInfo>({SymbolInfo()});
    $$.front().node = new IterationNode();
    if($3.size() > 0 && $3.front().node != NULL) {
      $$.front().node->AddChild($3.front().node);
    }
    if($5.size() > 0 && $5.front().node != NULL) {
      $$.front().node->AddChild($5.front().node);
    }
    $$.front().node->AddChild(NULL);
    if($8.size() > 0 && $8.front().node != NULL) {
      $$.front().node->AddChild($8.front().node);
    }
  }
  | FOR OPEN_PAREN expression SEMI expression SEMI expression CLOSE_PAREN statement {
    // Log reduction
    TR_LOGGER.PushReduction(
      "FOR OPEN_PAREN expression SEMI expression SEMI expression CLOSE_PAREN statement "
      "-> iteration_statement");
    
    // Pass through AST Node
    $$ = list<SymbolInfo>({SymbolInfo()});
    $$.front().node = new IterationNode();
    if($3.size() > 0 && $3.front().node != NULL) {
      $$.front().node->AddChild($3.front().node);
    }
    if($5.size() > 0 && $5.front().node != NULL) {
      $$.front().node->AddChild($5.front().node);
    }
    if($7.size() > 0 && $7.front().node != NULL) {
      $$.front().node->AddChild($7.front().node);
    }
    if($9.size() > 0 && $9.front().node != NULL) {
      $$.front().node->AddChild($9.front().node);
    }
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
    // Log reduction
    TR_LOGGER.PushReduction("assignment_expression -> expression");
    // Pass through 
    $$ = $1;
    $$.front().node = new ExpressNode($$.front().node);
  }
  | expression COMMA assignment_expression {
    TR_LOGGER.PushReduction(
      "expression COMMA assignment_expression -> expression");
    $$ = $1;
    $$.push_front($3.front());
    $$.front().node->AddChild($3.front().node);
  }
  ;

assignment_expression
  : conditional_expression {
    // Log reduction
    TR_LOGGER.PushReduction("conditional_expression -> assignment_expression");
    // Pass through
    $$ = $1;
  }
  | unary_expression assignment_operator assignment_expression {
    // Log reduction
    TR_LOGGER.PushReduction(
      "unary_expression assignment_operator assignment_expression "
      "-> assignment_expression");

    // TODO: TypeCheck
    // Copy value
    $1.front().data_value.unsigned_long_long_val = $3.front().data_value.unsigned_long_long_val;
    $1.front().data_is_valid = true;

    SymbolInfo* temp = S_TABLE.GetMostRecentSymbolInfo($1.front().identifier_name);
    if(temp != NULL) {
      *temp = $1.front();
    } 

    // Pass through
    $$ = $1;
    $2.front().node->AddChild($1.front().node);
    $2.front().node->AddChild($3.front().node);
    $$.front().node = $2.front().node;
  }
  ;

assignment_operator
  : EQUALS_SIGN {
    // Log reduction
    TR_LOGGER.PushReduction("EQUALS_SIGN -> assignment_operator");

    // Pass through assignment node.
    $$ = list<SymbolInfo>({SymbolInfo()});
    $$.front().node = new 
        AssignmentNode(AssignmentNode::AssignmentType::EQUALS);
  }
  | MUL_ASSIGN {
    // Log reduction
    TR_LOGGER.PushReduction("MUL_ASSIGN -> assignment_operator");

    // Pass through assignment node.
    $$ = list<SymbolInfo>({SymbolInfo()});
    $$.front().node = new 
        AssignmentNode(AssignmentNode::AssignmentType::MUL);
  }
  | DIV_ASSIGN {
    // Log reduction
    TR_LOGGER.PushReduction("DIV_ASSIGN -> assignment_operator");

    // Pass through assignment node.
    $$ = list<SymbolInfo>({SymbolInfo()});
    $$.front().node = new 
        AssignmentNode(AssignmentNode::AssignmentType::DIV);
  }
  | MOD_ASSIGN {
    // Log reduction
    TR_LOGGER.PushReduction("MOD_ASSIGN -> assignment_operator");

    // Pass through assignment node.
    $$ = list<SymbolInfo>({SymbolInfo()});
    $$.front().node = new 
        AssignmentNode(AssignmentNode::AssignmentType::MOD);
  }
  | ADD_ASSIGN {
    // Log reduction
    TR_LOGGER.PushReduction("ADD_ASSIGN -> assignment_operator");

    // Pass through assignment node.
    $$ = list<SymbolInfo>({SymbolInfo()});
    $$.front().node = new 
        AssignmentNode(AssignmentNode::AssignmentType::EQUALS);
  }
  | SUB_ASSIGN {
    // Log reduction
    TR_LOGGER.PushReduction("SUB_ASSIGN -> assignment_operator");

    // Pass through assignment node.
    $$ = list<SymbolInfo>({SymbolInfo()});
    $$.front().node = new 
        AssignmentNode(AssignmentNode::AssignmentType::SUB);
  }
  | LEFT_ASSIGN {
    // Log reduction
    TR_LOGGER.PushReduction("LEFT_ASSIGN -> assignment_operator");

    // Pass through assignment node.
    $$ = list<SymbolInfo>({SymbolInfo()});
    $$.front().node = new 
        AssignmentNode(AssignmentNode::AssignmentType::LEFT);
  }
  | RIGHT_ASSIGN {
    // Log reduction
    TR_LOGGER.PushReduction("RIGHT_ASSIGN -> assignment_operator");

    // Pass through assignment node.
    $$ = list<SymbolInfo>({SymbolInfo()});
    $$.front().node = new 
        AssignmentNode(AssignmentNode::AssignmentType::RIGHT);
  }
  | AND_ASSIGN {
    // Log reduction
    TR_LOGGER.PushReduction("AND_ASSIGN -> assignment_operator");

    // Pass through assignment node.
    $$ = list<SymbolInfo>({SymbolInfo()});
    $$.front().node = new 
        AssignmentNode(AssignmentNode::AssignmentType::AND);
  }
  | XOR_ASSIGN {
    // Log reduction
    TR_LOGGER.PushReduction("XOR_ASSIGN -> assignment_operator");

    // Pass through assignment node.
    $$ = list<SymbolInfo>({SymbolInfo()});
    $$.front().node = new 
        AssignmentNode(AssignmentNode::AssignmentType::XOR);
  }
  | OR_ASSIGN {
    // Log reduction
    TR_LOGGER.PushReduction("OR_ASSIGN -> assignment_operator");

    // Pass through assignment node.
    $$ = list<SymbolInfo>({SymbolInfo()});
    $$.front().node = new 
        AssignmentNode(AssignmentNode::AssignmentType::OR);
  }
  ;

conditional_expression
  : logical_or_expression {
    // Log reduction.
    TR_LOGGER.PushReduction("logical_or_expression -> conditional_expression");
    // Pass through
    $$ = $1;
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
    // Log reduction.
    TR_LOGGER.PushReduction("logical_and_expression -> logical_or_expression");
    // Pass through
  }
  | logical_or_expression OR_OP logical_and_expression {
    // Log reduction.
    TR_LOGGER.PushReduction(
      "logical_or_expression OR_OP logical_and_expression "
      "-> logical_or_expression");
    // Check if they are integers
    if(!IsInteger($1.front()) || !IsInteger($3.front())) {
      TR_LOGGER.Error("Cannot perform boolean calculation on not integer type", 
                      LINE, COLUMN);
    }
    // Perform the logical and operation.
    if($3.front().data_is_valid && $1.front().data_is_valid) {
      if(IsUnsigned($1.front()) && IsUnsigned($3.front())) {
        $1.front().data_value.unsigned_long_long_val
          = $1.front().data_value.unsigned_long_long_val 
            && $3.front().data_value.unsigned_long_long_val;
      } else if (!IsUnsigned($1.front()) && IsUnsigned($3.front())) {
        $1.front().data_value.unsigned_long_long_val
          = $1.front().data_value.long_long_val 
            && $3.front().data_value.unsigned_long_long_val;
      } else if (IsUnsigned($1.front()) && !IsUnsigned($3.front())) {
        $1.front().data_value.unsigned_long_long_val
          = $1.front().data_value.long_long_val 
            && $3.front().data_value.unsigned_long_long_val;
      } else {
        $1.front().data_value.unsigned_long_long_val
          = $1.front().data_value.long_long_val 
            && $3.front().data_value.long_long_val;
      }
    } else {
      $1.front().data_is_valid = false;
    }

    $1.front().type_specifier_list 
      = list<SymbolTypes::SymbolType>({SymbolTypes::INT});

    // Pass through.
    $$ = $1;
  }
  ;

logical_and_expression
  : inclusive_or_expression {
    // Log reduction
    TR_LOGGER.PushReduction(
      "inclusive_or_expression -> logical_and_expression");
    // Pass through
    $$ = $1;
  }
  | logical_and_expression AND_OP inclusive_or_expression {
    // Log reduction.
    TR_LOGGER.PushReduction(
      "logical_and_expression AND_OP inclusive_or_expression "
      "-> logical_and_expression");
    // Check if the $3 is equal to zero
    if(!IsInteger($1.front()) || !IsInteger($3.front())) {
      TR_LOGGER.Error("Cannot perform boolean calculation on not integer type", 
                      LINE, COLUMN);
    }
    // Perform the logical and operation.
    if($3.front().data_is_valid && $1.front().data_is_valid) {
      if(IsUnsigned($1.front()) && IsUnsigned($3.front())) {
        $1.front().data_value.unsigned_long_long_val
          = $1.front().data_value.unsigned_long_long_val 
            && $3.front().data_value.unsigned_long_long_val;
      } else if (!IsUnsigned($1.front()) && IsUnsigned($3.front())) {
        $1.front().data_value.unsigned_long_long_val
          = $1.front().data_value.long_long_val 
            && $3.front().data_value.unsigned_long_long_val;
      } else if (IsUnsigned($1.front()) && !IsUnsigned($3.front())) {
        $1.front().data_value.unsigned_long_long_val
          = $1.front().data_value.long_long_val 
            && $3.front().data_value.unsigned_long_long_val;
      } else {
        $1.front().data_value.unsigned_long_long_val
          = $1.front().data_value.long_long_val 
            && $3.front().data_value.long_long_val;
      }
    } else {
      $1.front().data_is_valid = false;
    }

    $1.front().type_specifier_list 
      = list<SymbolTypes::SymbolType>({SymbolTypes::INT});

    // Pass through.
    $$ = $1;
  }
  ;

inclusive_or_expression
  : exclusive_or_expression {
    // Log reduction
    TR_LOGGER.PushReduction(
      "exclusive_or_expression -> inclusive_or_expression");
    // Pass through
    $$ = $1;
  }
  | inclusive_or_expression PIPE exclusive_or_expression {
    // Log reduction
    TR_LOGGER.PushReduction(
      "inclusive_or_expression PIPE exclusive_or_expression "
      "-> inclusive_or_expression");
    // Check if the they are integers
    if(!IsInteger($1.front()) || !IsInteger($3.front())) {
      TR_LOGGER.Error("Cannot do binary expressions on something of not "
                      "integer type", LINE, COLUMN);
    }

    // Perform the and_expression operation.
    if($3.front().data_is_valid && $1.front().data_is_valid) {
      if(IsUnsigned($1.front()) && IsUnsigned($3.front())) {
        $1.front().data_value.unsigned_long_long_val 
            |= $3.front().data_value.unsigned_long_long_val;
      } else if (!IsUnsigned($1.front()) && IsUnsigned($3.front())) {
        $1.front().data_value.long_long_val 
            |= $3.front().data_value.unsigned_long_long_val;
      } else if (IsUnsigned($1.front()) && !IsUnsigned($3.front())) {
        $1.front().data_value.long_long_val 
            |= $3.front().data_value.unsigned_long_long_val;
      } else {
        $1.front().data_value.long_long_val 
            |= $3.front().data_value.long_long_val;
      }
    } else {
      $1.front().data_is_valid = false;
    }

    // Pass through
    $$ = $1;
  }
  ;

exclusive_or_expression
  : and_expression {
    // Log reduction
    TR_LOGGER.PushReduction("exclusive_or_expression -> and_expression");
    // Pass through
    $$ = $1;
  }
  | exclusive_or_expression CARAT and_expression {
    // Log reduction.
    TR_LOGGER.PushReduction(
      "exclusive_or_expression CARAT and_expression "
      "-> exclusive_or_expression");
    // Check if the they are integers.
    if(!IsInteger($1.front()) || !IsInteger($3.front())) {
      TR_LOGGER.Error("Cannot do binary expressions on something of not "
                      "integer type", LINE, COLUMN);
    }

    // Perform the and_expression operation.
    if($3.front().data_is_valid && $1.front().data_is_valid) {
      if(IsUnsigned($1.front()) && IsUnsigned($3.front())) {
        $1.front().data_value.unsigned_long_long_val 
            ^= $3.front().data_value.unsigned_long_long_val;
      } else if (!IsUnsigned($1.front()) && IsUnsigned($3.front())) {
        $1.front().data_value.long_long_val 
            ^= $3.front().data_value.unsigned_long_long_val;
      } else if (IsUnsigned($1.front()) && !IsUnsigned($3.front())) {
        $1.front().data_value.long_long_val 
            ^= $3.front().data_value.unsigned_long_long_val;
      } else {
        $1.front().data_value.long_long_val 
            ^= $3.front().data_value.long_long_val;
      }
    } else {
      $1.front().data_is_valid = false;
    }

    // Pass through
    $$ = $1;
  }
  ;

and_expression
  : equality_expression {
    // Log reduction.
    TR_LOGGER.PushReduction("equality_expression -> and_expression");
    // Pass through
    $$ = $1;
  }
  | and_expression AMPERSAND equality_expression {
    // Log reduction
    TR_LOGGER.PushReduction(
      "and_expression AMPERSAND equality_expression -> and_expression");

    // Check if the they are integers
    if(!IsInteger($1.front()) || !IsInteger($3.front())) {
      TR_LOGGER.Error("Cannot do binary expressions on something of not "
                      "integer type", LINE, COLUMN);
    }

    // Perform the and_expression operation.
    if($3.front().data_is_valid && $1.front().data_is_valid) {
      if(IsUnsigned($1.front()) && IsUnsigned($3.front())) {
        $1.front().data_value.unsigned_long_long_val 
            &= $3.front().data_value.unsigned_long_long_val;
      } else if (!IsUnsigned($1.front()) && IsUnsigned($3.front())) {
        $1.front().data_value.long_long_val 
            &= $3.front().data_value.unsigned_long_long_val;
      } else if (IsUnsigned($1.front()) && !IsUnsigned($3.front())) {
        $1.front().data_value.long_long_val 
            &= $3.front().data_value.unsigned_long_long_val;
      } else {
        $1.front().data_value.long_long_val 
            &= $3.front().data_value.long_long_val;
      }
    } else {
      $1.front().data_is_valid = false;
    }

    // Pass through
    $$ = $1;
  }
  ;

equality_expression
  : relational_expression {
    // Log reduction.
    TR_LOGGER.PushReduction("relational_expression -> equality_expression");
    // Pass through.
    $$ = $1;
  }
  | equality_expression EQ_OP relational_expression {
    // Log reduction.
    TR_LOGGER.PushReduction(
      "equality_expression EQ_OP relational_expression -> equality_expression");
    // Check if they are numbers
    if(!IsRelational($1.front()) || !IsRelational($3.front())) {
      TR_LOGGER.Error("Cannot calculate equality of non relational type", 
                      LINE, COLUMN);
    }

    // Perform the lesser
    if($3.front().data_is_valid && $1.front().data_is_valid) {
      // Integer lesser
      if(IsInteger($1.front()) && IsInteger($3.front())) {
        if(IsUnsigned($1.front()) && IsUnsigned($3.front())) {
          $1.front().data_value.unsigned_long_long_val 
              = $1.front().data_value.unsigned_long_long_val 
                  == $3.front().data_value.unsigned_long_long_val;
        } else if (!IsUnsigned($1.front()) && IsUnsigned($3.front())) {
          $1.front().data_value.unsigned_long_long_val 
            = $1.front().data_value.long_long_val 
              == $3.front().data_value.unsigned_long_long_val;
        } else if (IsUnsigned($1.front()) && !IsUnsigned($3.front())) {
          $1.front().data_value.unsigned_long_long_val 
            = $1.front().data_value.long_long_val 
              == $3.front().data_value.unsigned_long_long_val;
        } else {
          $1.front().data_value.unsigned_long_long_val 
            = $1.front().data_value.long_long_val 
              == $3.front().data_value.long_long_val;
        }
      // Both floating divide
      } else if (IsFloating($1.front()) && IsFloating($3.front())) {
        $1.front().data_value.unsigned_long_long_val 
          = $1.front().data_value.double_val 
            == $3.front().data_value.double_val;
      // Single floating divide
      } else if (IsFloating($1.front())) {
        if(IsUnsigned($3.front())) {
          $1.front().data_value.unsigned_long_long_val 
            = $1.front().data_value.double_val 
             == $3.front().data_value.unsigned_long_long_val;
        } else {
          $1.front().data_value.unsigned_long_long_val 
            = $1.front().data_value.double_val 
              == $3.front().data_value.long_long_val;
        }
      } else {
        if(IsUnsigned($1.front())) {
          $1.front().data_value.unsigned_long_long_val 
            = $1.front().data_value.unsigned_long_long_val 
              == $3.front().data_value.double_val;
        } else {
          $1.front().data_value.unsigned_long_long_val 
            = $1.front().data_value.long_long_val 
              == $3.front().data_value.double_val;
        }
      }
    } else {
      $1.front().data_is_valid = false;
    }

    $1.front().type_specifier_list 
      = list<SymbolTypes::SymbolType>({SymbolTypes::INT});

    $$ = $1;

    Node * temp = new EqualityNode(EqualityNode::RelationalType::EQ);
    temp->AddChild($1.front().node);
    temp->AddChild(new Node("EQUALS"));
    temp->AddChild($3.front().node);
    $$.front().node = temp;
  }
  | equality_expression NE_OP relational_expression {
    // Log reduction
    TR_LOGGER.PushReduction(
      "equality_expression NE_OP relational_expression -> equality_expression");
    // Check if they are numbers
    if(!IsRelational($1.front()) || !IsRelational($3.front())) {
      TR_LOGGER.Error("Cannot calculate equality of non relational type", 
                      LINE, COLUMN);
    }

    // Perform the lesser
    if($3.front().data_is_valid && $1.front().data_is_valid) {
      // Integer lesser
      if(IsInteger($1.front()) && IsInteger($3.front())) {
        if(IsUnsigned($1.front()) && IsUnsigned($3.front())) {
          $1.front().data_value.unsigned_long_long_val 
              = $1.front().data_value.unsigned_long_long_val 
                  != $3.front().data_value.unsigned_long_long_val;
        } else if (!IsUnsigned($1.front()) && IsUnsigned($3.front())) {
          $1.front().data_value.unsigned_long_long_val 
            = $1.front().data_value.long_long_val 
              != $3.front().data_value.unsigned_long_long_val;
        } else if (IsUnsigned($1.front()) && !IsUnsigned($3.front())) {
          $1.front().data_value.unsigned_long_long_val 
            = $1.front().data_value.long_long_val 
              != $3.front().data_value.unsigned_long_long_val;
        } else {
          $1.front().data_value.unsigned_long_long_val 
            = $1.front().data_value.long_long_val 
              != $3.front().data_value.long_long_val;
        }
      // Both floating divide
      } else if (IsFloating($1.front()) && IsFloating($3.front())) {
        $1.front().data_value.unsigned_long_long_val 
          = $1.front().data_value.double_val 
            != $3.front().data_value.double_val;
      // Single floating divide
      } else if (IsFloating($1.front())) {
        if(IsUnsigned($3.front())) {
          $1.front().data_value.unsigned_long_long_val 
            = $1.front().data_value.double_val 
             != $3.front().data_value.unsigned_long_long_val;
        } else {
          $1.front().data_value.unsigned_long_long_val 
            = $1.front().data_value.double_val 
              != $3.front().data_value.long_long_val;
        }
      } else {
        if(IsUnsigned($1.front())) {
          $1.front().data_value.unsigned_long_long_val 
            = $1.front().data_value.unsigned_long_long_val 
              != $3.front().data_value.double_val;
        } else {
          $1.front().data_value.unsigned_long_long_val 
            = $1.front().data_value.long_long_val 
              != $3.front().data_value.double_val;
        }
      }
    } else {
      $1.front().data_is_valid = false;
    }

    $1.front().type_specifier_list 
      = list<SymbolTypes::SymbolType>({SymbolTypes::INT});

    $$ = $1;

    Node * temp = new EqualityNode(EqualityNode::RelationalType::NE);
    temp->AddChild($1.front().node);
    temp->AddChild(new Node("NOT_EQ"));
    temp->AddChild($3.front().node);
    $$.front().node = temp;
  }
  ;

relational_expression
  : shift_expression {
    // Log reduction
    TR_LOGGER.PushReduction("shift_expression -> relational_expression");
    // Pass through
    $$ = $1;
  }
  | relational_expression LESSER shift_expression {
    // Log reduction
    TR_LOGGER.PushReduction(
      "relational_expression LESSER shift_expression -> relational_expression");
    // Check if they are numbers
    if(!IsRelational($1.front()) || !IsRelational($3.front())) {
      TR_LOGGER.Error("Cannot calculate less of non relational type", 
                      LINE, COLUMN);
    }

    // Perform the lesser
    if($3.front().data_is_valid && $1.front().data_is_valid) {
      // Integer lesser
      if(IsInteger($1.front()) && IsInteger($3.front())) {
        if(IsUnsigned($1.front()) && IsUnsigned($3.front())) {
          $1.front().data_value.unsigned_long_long_val 
              = $1.front().data_value.unsigned_long_long_val 
                  < $3.front().data_value.unsigned_long_long_val;
        } else if (!IsUnsigned($1.front()) && IsUnsigned($3.front())) {
          $1.front().data_value.unsigned_long_long_val 
            = $1.front().data_value.long_long_val 
              < $3.front().data_value.unsigned_long_long_val;
        } else if (IsUnsigned($1.front()) && !IsUnsigned($3.front())) {
          $1.front().data_value.unsigned_long_long_val 
            = $1.front().data_value.long_long_val 
              < $3.front().data_value.unsigned_long_long_val;
        } else {
          $1.front().data_value.unsigned_long_long_val 
            = $1.front().data_value.long_long_val 
              < $3.front().data_value.long_long_val;
        }
      // Both floating divide
      } else if (IsFloating($1.front()) && IsFloating($3.front())) {
        $1.front().data_value.unsigned_long_long_val 
          = $1.front().data_value.double_val 
            < $3.front().data_value.double_val;
      // Single floating divide
      } else if (IsFloating($1.front())) {
        if(IsUnsigned($3.front())) {
          $1.front().data_value.unsigned_long_long_val 
            = $1.front().data_value.double_val 
              < $3.front().data_value.unsigned_long_long_val;
        } else {
          $1.front().data_value.unsigned_long_long_val 
            = $1.front().data_value.double_val 
              < $3.front().data_value.long_long_val;
        }
      } else {
        if(IsUnsigned($1.front())) {
          $1.front().data_value.unsigned_long_long_val 
            = $1.front().data_value.unsigned_long_long_val 
              < $3.front().data_value.double_val;
        } else {
          $1.front().data_value.unsigned_long_long_val 
            = $1.front().data_value.long_long_val 
              < $3.front().data_value.double_val;
        }
      }
    } else {
      $1.front().data_is_valid = false;
    }

    $1.front().type_specifier_list 
      = list<SymbolTypes::SymbolType>({SymbolTypes::INT});

    $$ = $1;

    Node * temp = new EqualityNode(EqualityNode::RelationalType::LESS);
    temp->AddChild($1.front().node);
    temp->AddChild(new Node("LESS"));
    temp->AddChild($3.front().node);
    $$.front().node = temp;
  }
  | relational_expression GREATER shift_expression {
    // Log reduction
    TR_LOGGER.PushReduction(
      "relational_expression GREATER shift_expression "
      "-> relational_expression");

    // Check if they are numbers
    if(!IsRelational($1.front()) || !IsRelational($3.front())) {
      TR_LOGGER.Error("Cannot calculate greater of non relational type", 
                      LINE, COLUMN);
    }

    // Perform the lesser
    if($3.front().data_is_valid && $1.front().data_is_valid) {
      // Integer lesser
      if(IsInteger($1.front()) && IsInteger($3.front())) {
        if(IsUnsigned($1.front()) && IsUnsigned($3.front())) {
          $1.front().data_value.unsigned_long_long_val 
              = $1.front().data_value.unsigned_long_long_val 
                  > $3.front().data_value.unsigned_long_long_val;
        } else if (!IsUnsigned($1.front()) && IsUnsigned($3.front())) {
          $1.front().data_value.unsigned_long_long_val 
            = $1.front().data_value.long_long_val 
              > $3.front().data_value.unsigned_long_long_val;
        } else if (IsUnsigned($1.front()) && !IsUnsigned($3.front())) {
          $1.front().data_value.unsigned_long_long_val 
            = $1.front().data_value.long_long_val 
              > $3.front().data_value.unsigned_long_long_val;
        } else {
          $1.front().data_value.unsigned_long_long_val 
            = $1.front().data_value.long_long_val 
              > $3.front().data_value.long_long_val;
        }
      // Both floating divide
      } else if (IsFloating($1.front()) && IsFloating($3.front())) {
        $1.front().data_value.unsigned_long_long_val 
          = $1.front().data_value.double_val 
            > $3.front().data_value.double_val;
      // Single floating divide
      } else if (IsFloating($1.front())) {
        if(IsUnsigned($3.front())) {
          $1.front().data_value.unsigned_long_long_val 
            = $1.front().data_value.double_val 
              > $3.front().data_value.unsigned_long_long_val;
        } else {
          $1.front().data_value.unsigned_long_long_val 
            = $1.front().data_value.double_val 
              > $3.front().data_value.long_long_val;
        }
      } else {
        if(IsUnsigned($1.front())) {
          $1.front().data_value.unsigned_long_long_val 
            = $1.front().data_value.unsigned_long_long_val 
              > $3.front().data_value.double_val;
        } else {
          $1.front().data_value.unsigned_long_long_val 
            = $1.front().data_value.long_long_val 
              > $3.front().data_value.double_val;
        }
      }
    } else {
      $1.front().data_is_valid = false;
    }

    $1.front().type_specifier_list 
      = list<SymbolTypes::SymbolType>({SymbolTypes::INT});

    $$ = $1;

    Node * temp = new EqualityNode(EqualityNode::RelationalType::GREATER);
    temp->AddChild($1.front().node);
    temp->AddChild(new Node("GREATER"));
    temp->AddChild($3.front().node);
    $$.front().node = temp;
  }
  | relational_expression LE_OP shift_expression {
    // Log reduction.
    TR_LOGGER.PushReduction(
      "relational_expression LE_OP shift_expression -> relational_expression");
    // Check if they are numbers
    if(!IsRelational($1.front()) || !IsRelational($3.front())) {
      TR_LOGGER.Error("Cannot calculate less or equal of non relational type", 
                      LINE, COLUMN);
    }

    // Perform the lesser
    if($3.front().data_is_valid && $1.front().data_is_valid) {
      // Integer lesser
      if(IsInteger($1.front()) && IsInteger($3.front())) {
        if(IsUnsigned($1.front()) && IsUnsigned($3.front())) {
          $1.front().data_value.unsigned_long_long_val 
              = $1.front().data_value.unsigned_long_long_val 
                  <= $3.front().data_value.unsigned_long_long_val;
        } else if (!IsUnsigned($1.front()) && IsUnsigned($3.front())) {
          $1.front().data_value.unsigned_long_long_val 
            = $1.front().data_value.long_long_val 
              <= $3.front().data_value.unsigned_long_long_val;
        } else if (IsUnsigned($1.front()) && !IsUnsigned($3.front())) {
          $1.front().data_value.unsigned_long_long_val 
            = $1.front().data_value.long_long_val 
              <= $3.front().data_value.unsigned_long_long_val;
        } else {
          $1.front().data_value.unsigned_long_long_val 
            = $1.front().data_value.long_long_val 
              <= $3.front().data_value.long_long_val;
        }
      // Both floating divide
      } else if (IsFloating($1.front()) && IsFloating($3.front())) {
        $1.front().data_value.unsigned_long_long_val 
          = $1.front().data_value.double_val 
            <= $3.front().data_value.double_val;
      // Single floating divide
      } else if (IsFloating($1.front())) {
        if(IsUnsigned($3.front())) {
          $1.front().data_value.unsigned_long_long_val 
            = $1.front().data_value.double_val 
              <= $3.front().data_value.unsigned_long_long_val;
        } else {
          $1.front().data_value.unsigned_long_long_val 
            = $1.front().data_value.double_val 
              <= $3.front().data_value.long_long_val;
        }
      } else {
        if(IsUnsigned($1.front())) {
          $1.front().data_value.unsigned_long_long_val 
            = $1.front().data_value.unsigned_long_long_val 
              <= $3.front().data_value.double_val;
        } else {
          $1.front().data_value.unsigned_long_long_val 
            = $1.front().data_value.long_long_val 
              <= $3.front().data_value.double_val;
        }
      }
    } else {
      $1.front().data_is_valid = false;
    }

    $1.front().type_specifier_list 
      = list<SymbolTypes::SymbolType>({SymbolTypes::INT});

    $$ = $1;

    Node * temp = new EqualityNode(EqualityNode::RelationalType::LE);
    temp->AddChild($1.front().node);
    temp->AddChild(new Node("LEES_EQUAL"));
    temp->AddChild($3.front().node);
    $$.front().node = temp;
  }
  | relational_expression GE_OP shift_expression {
    TR_LOGGER.PushReduction(
      "relational_expression GE_OP shift_expression -> relational_expression");
    // Check if they are numbers
    if(!IsRelational($1.front()) || !IsRelational($3.front())) {
      TR_LOGGER.Error("Cannot calculate greater or equal of non relational type", 
                      LINE, COLUMN);
    }

    // Perform the lesser
    if($3.front().data_is_valid && $1.front().data_is_valid) {
      // Integer lesser
      if(IsInteger($1.front()) && IsInteger($3.front())) {
        if(IsUnsigned($1.front()) && IsUnsigned($3.front())) {
          $1.front().data_value.unsigned_long_long_val 
              = $1.front().data_value.unsigned_long_long_val 
                  >= $3.front().data_value.unsigned_long_long_val;
        } else if (!IsUnsigned($1.front()) && IsUnsigned($3.front())) {
          $1.front().data_value.unsigned_long_long_val 
            = $1.front().data_value.long_long_val 
              >= $3.front().data_value.unsigned_long_long_val;
        } else if (IsUnsigned($1.front()) && !IsUnsigned($3.front())) {
          $1.front().data_value.unsigned_long_long_val 
            = $1.front().data_value.long_long_val 
              >= $3.front().data_value.unsigned_long_long_val;
        } else {
          $1.front().data_value.unsigned_long_long_val 
            = $1.front().data_value.long_long_val 
              >= $3.front().data_value.long_long_val;
        }
      // Both floating divide
      } else if (IsFloating($1.front()) && IsFloating($3.front())) {
        $1.front().data_value.unsigned_long_long_val 
          = $1.front().data_value.double_val 
            >= $3.front().data_value.double_val;
      // Single floating divide
      } else if (IsFloating($1.front())) {
        if(IsUnsigned($3.front())) {
          $1.front().data_value.unsigned_long_long_val 
            = $1.front().data_value.double_val 
              >= $3.front().data_value.unsigned_long_long_val;
        } else {
          $1.front().data_value.unsigned_long_long_val 
            = $1.front().data_value.double_val 
              >= $3.front().data_value.long_long_val;
        }
      } else {
        if(IsUnsigned($1.front())) {
          $1.front().data_value.unsigned_long_long_val 
            = $1.front().data_value.unsigned_long_long_val 
              >= $3.front().data_value.double_val;
        } else {
          $1.front().data_value.unsigned_long_long_val 
            = $1.front().data_value.long_long_val 
              >= $3.front().data_value.double_val;
        }
      }
    } else {
      $1.front().data_is_valid = false;
    }

    $1.front().type_specifier_list 
      = list<SymbolTypes::SymbolType>({SymbolTypes::INT});

    $$ = $1;

    Node * temp = new EqualityNode(EqualityNode::RelationalType::GE);
    temp->AddChild($1.front().node);
    temp->AddChild(new Node("GREATER_EQUAL"));
    temp->AddChild($3.front().node);
    $$.front().node = temp;
  }
  ;

shift_expression
  : additive_expression {
    // Log reduction.
    TR_LOGGER.PushReduction("additive_expression -> shift_expression");
    // Pass through
    $$ = $1;
  }
  | shift_expression LEFT_OP additive_expression {
    // Log reduction.
    TR_LOGGER.PushReduction(
      "shift_expression LEFT_OP additive_expression -> shift_expression");
    // Check if the $3 is equal to zero
    if(!IsInteger($1.front()) || !IsInteger($3.front())) {
      TR_LOGGER.Error("Cannot left shift something of not integer type", 
                      LINE, COLUMN);
    }
    // Perform the left shift operation.
    if($3.front().data_is_valid && $1.front().data_is_valid) {
      if(IsUnsigned($1.front()) && IsUnsigned($3.front())) {
        $1.front().data_value.unsigned_long_long_val 
            <<= $3.front().data_value.unsigned_long_long_val;
      } else if (!IsUnsigned($1.front()) && IsUnsigned($3.front())) {
        $1.front().data_value.long_long_val 
            <<= $3.front().data_value.unsigned_long_long_val;
      } else if (IsUnsigned($1.front()) && !IsUnsigned($3.front())) {
        $1.front().data_value.long_long_val 
            <<= $3.front().data_value.unsigned_long_long_val;
      } else {
        $1.front().data_value.long_long_val 
            <<= $3.front().data_value.long_long_val;
      }
    } else {
      $1.front().data_is_valid = false;
    }

    // Pass through.
    $$ = $1;
  }
  | shift_expression RIGHT_OP additive_expression {
    // Log reduction
    TR_LOGGER.PushReduction(
      "shift_expression RIGHT_OP additive_expression -> shift_expression");
    // Check if either are not integers
    if(!IsInteger($1.front()) || !IsInteger($3.front())) {
      TR_LOGGER.Error("Cannot right shift something of not integer type", 
                      LINE, COLUMN);
    }
    // Perform the right shift operation.
    if($3.front().data_is_valid && $1.front().data_is_valid) {
      if(IsUnsigned($1.front()) && IsUnsigned($3.front())) {
        $1.front().data_value.unsigned_long_long_val 
            >>= $3.front().data_value.unsigned_long_long_val;
      } else if (!IsUnsigned($1.front()) && IsUnsigned($3.front())) {
        $1.front().data_value.long_long_val 
            >>= $3.front().data_value.unsigned_long_long_val;
      } else if (IsUnsigned($1.front()) && !IsUnsigned($3.front())) {
        $1.front().data_value.long_long_val 
            >>= $3.front().data_value.unsigned_long_long_val;
      } else {
        $1.front().data_value.long_long_val 
            >>= $3.front().data_value.long_long_val;
      }
    } else {
      $1.front().data_is_valid = false;
    }

    // Pass through
    $$ = $1;
  }
  ;

additive_expression
  : multiplicative_expression {
    // Log reduction
    TR_LOGGER.PushReduction("multiplicative_expression -> additive_expression");
    // Pass through
    $$ = $1;
  }
  | additive_expression PLUS multiplicative_expression {
    TR_LOGGER.PushReduction(
      "additive_expression PLUS multiplicative_expression "
      "-> additive_expression");
  //long Double maxValue(SymbolInfo)
    if(!IsNumber($1.front()) || !IsNumber($3.front())){
      TR_LOGGER.Error("Cannot add minus something not of NUMBER type.",
                      LINE, COLUMN);  
    }
    // data is valid
    // Integer MULT
      if(IsInteger($1.front()) && IsInteger($3.front())) {
        if(IsUnsigned($1.front()) && IsUnsigned($3.front())) {
          //Check overflow
          if(addOverflow($1.front(), $3.front())){
          TR_LOGGER.Error("addition overflow detected", LINE, COLUMN);
          }
          else{
          $$.front().data_value.unsigned_long_long_val = 
              $1.front().data_value.unsigned_long_long_val 
              + $3.front().data_value.unsigned_long_long_val;
          }
        } else if (!IsUnsigned($1.front()) && IsUnsigned($3.front())) {
          //Check overflow
          if(addOverflow($1.front(), $3.front())){
          TR_LOGGER.Error("addition overflow detected", LINE, COLUMN);
          }
          else{
          $$.front().data_value.long_long_val = $1.front().data_value.long_long_val 
              + $3.front().data_value.unsigned_long_long_val;
          }
        } else if (IsUnsigned($1.front()) && !IsUnsigned($3.front())) {
          //Check overflow
          if(addOverflow($1.front(), $3.front())){
          TR_LOGGER.Error("addition overflow detected", LINE, COLUMN);
          }
          else{
          $$.front().data_value.long_long_val = $1.front().data_value.long_long_val 
              + $3.front().data_value.unsigned_long_long_val;
          }
        } else {
          //check overflow
          if(addOverflow($1.front(), $3.front())){
          TR_LOGGER.Error("addition overflow detected", LINE, COLUMN);
          }
          else{
          $$.front().data_value.long_long_val = $1.front().data_value.long_long_val 
              + $3.front().data_value.long_long_val;
          }
        }
      // Both floating divide
      } else if (IsFloating($1.front()) && IsFloating($3.front())) {
          //check overflow
          if(addOverflow($1.front(), $3.front())){
          TR_LOGGER.Error("addition overflow detected", LINE, COLUMN);
          }
          else{
          $$.front().data_value.double_val = $1.front().data_value.double_val + $3.front().data_value.double_val;
          }
      // Single floating divide
      } else if (IsFloating($1.front())) {
        if(IsUnsigned($3.front())) {
          //check overflow
          if(addOverflow($1.front(),$3.front())){
          TR_LOGGER.Error("addition overflow detected", LINE, COLUMN);
          }
          else{
          $$.front().data_value.double_val = $1.front().data_value.double_val 
            + $3.front().data_value.unsigned_long_long_val;
          }
        } else {
          //check overflow
          if(addOverflow($1.front(),$3.front())){
          TR_LOGGER.Error("addition overflow detected", LINE, COLUMN);
          }
          else{
          $$.front().data_value.double_val = $1.front().data_value.double_val 
            + $3.front().data_value.long_long_val;
          }
        }
      } else {
        if(IsUnsigned($1.front())) {
          //check overflow
          if(addOverflow($1.front(),$3.front())){
          TR_LOGGER.Error("addition overflow detected", LINE, COLUMN);
          }
          else{
          $$.front().data_value.double_val 
            = $1.front().data_value.unsigned_long_long_val 
                + $3.front().data_value.double_val;
          }
        } else {
          //check overflow
          if(addOverflow($1.front(),$3.front())){
          TR_LOGGER.Error("addition overflow detected", LINE, COLUMN);
          }
          else{
          $$.front().data_value.double_val 
            = $1.front().data_value.long_long_val 
            + $3.front().data_value.double_val;
          }
        }
        $$.front().type_specifier_list = $3.front().type_specifier_list;
      }

      bool is_addition = true;
      Node * temp = new AdditiveNode(is_addition);
      temp->AddChild($1.front().node);
      temp->AddChild(new Node("PLUS"));
      temp->AddChild($3.front().node);

      $$.front().node = temp;
  }
  | additive_expression MINUS multiplicative_expression {
    TR_LOGGER.PushReduction(
      "additive_expression MINUS multiplicative_expression "
      "-> additive_expression");
    //long Double maxValue(SymbolInfo)
    if(!IsNumber($1.front()) || !IsNumber($3.front())){
      TR_LOGGER.Error("Cannot add subtract something not of NUMBER type.",
                      LINE, COLUMN);  
    }
    // data is valid
    // Integer MULT
      if(IsInteger($1.front()) && IsInteger($3.front())) {
        if(IsUnsigned($1.front()) && IsUnsigned($3.front())) {
          //Check overflow
          if(subOverflow($1.front(), $3.front())){
          TR_LOGGER.Error("subtraction overflow detected", LINE, COLUMN);
          }
          else{
          $$.front().data_value.unsigned_long_long_val = 
              $1.front().data_value.unsigned_long_long_val 
              - $3.front().data_value.unsigned_long_long_val;
          }
        } else if (!IsUnsigned($1.front()) && IsUnsigned($3.front())) {
          //Check overflow
          if(subOverflow($1.front(), $3.front())){
          TR_LOGGER.Error("subtraction overflow detected", LINE, COLUMN);
          }
          else{
          $$.front().data_value.long_long_val = $1.front().data_value.long_long_val 
              - $3.front().data_value.unsigned_long_long_val;
          }
        } else if (IsUnsigned($1.front()) && !IsUnsigned($3.front())) {
          //Check overflow
          if(subOverflow($1.front(), $3.front())){
          TR_LOGGER.Error("subtraction overflow detected", LINE, COLUMN);
          }
          else{
          $$.front().data_value.long_long_val = $1.front().data_value.long_long_val 
              - $3.front().data_value.unsigned_long_long_val;
          }
        } else {
          //check overflow
          if(subOverflow($1.front(), $3.front())){
          TR_LOGGER.Error("subtraction overflow detected", LINE, COLUMN);
          }
          else{
          $$.front().data_value.long_long_val = $1.front().data_value.long_long_val 
              - $3.front().data_value.long_long_val;
          }
        }
      // Both floating divide
      } else if (IsFloating($1.front()) && IsFloating($3.front())) {
          //check overflow
          if(subOverflow($1.front(), $3.front())){
          TR_LOGGER.Error("subtraction overflow detected", LINE, COLUMN);
          }
          else{
          $$.front().data_value.double_val = $1.front().data_value.double_val - $3.front().data_value.double_val;
          }
      // Single floating divide
      } else if (IsFloating($1.front())) {
        if(IsUnsigned($3.front())) {
          //check overflow
          if(subOverflow($1.front(),$3.front())){
          TR_LOGGER.Error("subtraction overflow detected", LINE, COLUMN);
          }
          else{
          $$.front().data_value.double_val = $1.front().data_value.double_val 
            - $3.front().data_value.unsigned_long_long_val;
          }
        } else {
          //check overflow
          if(subOverflow($1.front(),$3.front())){
          TR_LOGGER.Error("subtraction overflow detected", LINE, COLUMN);
          }
          else{
          $$.front().data_value.double_val = $1.front().data_value.double_val 
            - $3.front().data_value.long_long_val;
          }
        }
      } else {
        if(IsUnsigned($1.front())) {
          //check overflow
          if(subOverflow($1.front(),$3.front())){
          TR_LOGGER.Error("subtraction overflow detected", LINE, COLUMN);
          }
          else{
          $$.front().data_value.double_val 
            = $1.front().data_value.unsigned_long_long_val 
                - $3.front().data_value.double_val;
          }
        } else {
          //check overflow
          if(subOverflow($1.front(),$3.front())){
          TR_LOGGER.Error("subtraction overflow detected", LINE, COLUMN);
          }
          else{
          $$.front().data_value.double_val 
            = $1.front().data_value.long_long_val 
            - $3.front().data_value.double_val;
          }
        }
        $$.front().type_specifier_list = $3.front().type_specifier_list;
      }
      bool is_addition = false;
      Node * temp = new AdditiveNode(is_addition);
      temp->AddChild($1.front().node);
      temp->AddChild(new Node("PLUS"));
      temp->AddChild($3.front().node);

      $$.front().node = temp;
  }
  ;

multiplicative_expression
  : cast_expression {
    // Log reduction
    TR_LOGGER.PushReduction("cast_expression -> multiplicative_expression");
    // Pass through
    $$ = $1;
  }
  | multiplicative_expression ASTERISK cast_expression {
    TR_LOGGER.PushReduction(
      "multiplicative_expression ASTERISK cast_expression "
      "-> multiplicative_expression");
    //$$ = $1 * $2;
    //long Double maxValue(SymbolInfo)
    if(!IsNumber($1.front()) || !IsNumber($3.front())){
      TR_LOGGER.Error("Cannot divide multipy something not of NUMBER type.",
                      LINE, COLUMN);  
    }
    // data is valid
    // Integer MULT
      if(IsInteger($1.front()) && IsInteger($3.front())) {
        if(IsUnsigned($1.front()) && IsUnsigned($3.front())) {
          $$.front().data_value.unsigned_long_long_val = 
              $1.front().data_value.unsigned_long_long_val 
              * $3.front().data_value.unsigned_long_long_val;
        } else if (!IsUnsigned($1.front()) && IsUnsigned($3.front())) {
          $$.front().data_value.long_long_val = $1.front().data_value.long_long_val 
              * $3.front().data_value.unsigned_long_long_val;
        } else if (IsUnsigned($1.front()) && !IsUnsigned($3.front())) {
          $$.front().data_value.long_long_val = $1.front().data_value.long_long_val 
              * $3.front().data_value.unsigned_long_long_val;
        } else {
          $$.front().data_value.long_long_val = $1.front().data_value.long_long_val 
              * $3.front().data_value.long_long_val;
        }
      // Both floating divide
      } else if (IsFloating($1.front()) && IsFloating($3.front())) {
        $$.front().data_value.double_val = $1.front().data_value.double_val * $3.front().data_value.double_val;
      // Single floating divide
      } else if (IsFloating($1.front())) {
        if(IsUnsigned($3.front())) {
          $$.front().data_value.double_val = $1.front().data_value.double_val 
            * $3.front().data_value.unsigned_long_long_val;
        } else {
          $$.front().data_value.double_val = $1.front().data_value.double_val 
            * $3.front().data_value.long_long_val;
        }
      } else {
        if(IsUnsigned($1.front())) {
          $$.front().data_value.double_val 
            = $1.front().data_value.unsigned_long_long_val 
                * $3.front().data_value.double_val;
        } else {
          $$.front().data_value.double_val 
            = $1.front().data_value.long_long_val 
            * $3.front().data_value.double_val;
        }
        $$.front().type_specifier_list = $3.front().type_specifier_list;
      }
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
    // Check if they are numbers
    if(!IsNumber($1.front()) || !IsNumber($3.front())) {
      TR_LOGGER.Error("Cannot divide something of not number type", 
                      LINE, COLUMN);
    }
    // Check if data is == 0
    if($3.front().data_is_valid) {
      if( (IsInteger($3.front()) && 
           $3.front().data_value.unsigned_long_long_val == 0) ||
          (IsFloating($3.front()) &&
           $3.front().data_value.double_val == 0.0) ) {
        TR_LOGGER.Error("Cannot divide by 0", LINE, COLUMN);
      }
    }

    // Perform the divide
    if($3.front().data_is_valid && $1.front().data_is_valid) {
      // Integer divide
      if(IsInteger($1.front()) && IsInteger($3.front())) {
        if(IsUnsigned($1.front()) && IsUnsigned($3.front())) {
          $1.front().data_value.unsigned_long_long_val 
              /= $3.front().data_value.unsigned_long_long_val;
        } else if (!IsUnsigned($1.front()) && IsUnsigned($3.front())) {
          $1.front().data_value.long_long_val 
              /= $3.front().data_value.unsigned_long_long_val;
        } else if (IsUnsigned($1.front()) && !IsUnsigned($3.front())) {
          $1.front().data_value.long_long_val 
              /= $3.front().data_value.unsigned_long_long_val;
        } else {
          $1.front().data_value.long_long_val 
              /= $3.front().data_value.long_long_val;
        }
      // Both floating divide
      } else if (IsFloating($1.front()) && IsFloating($3.front())) {
        $1.front().data_value.double_val /= $3.front().data_value.double_val;
      // Single floating divide
      } else if (IsFloating($1.front())) {
        if(IsUnsigned($3.front())) {
          $1.front().data_value.double_val 
            /= $3.front().data_value.unsigned_long_long_val;
        } else {
          $1.front().data_value.double_val 
            /= $3.front().data_value.long_long_val;
        }
      } else {
        if(IsUnsigned($1.front())) {
          $1.front().data_value.double_val 
            = $1.front().data_value.unsigned_long_long_val 
                / $3.front().data_value.double_val;
        } else {
          $1.front().data_value.double_val 
            = $1.front().data_value.long_long_val 
                / $3.front().data_value.double_val;
        }
        $1.front().type_specifier_list = $3.front().type_specifier_list;
      }
    } else {
      $1.front().data_is_valid = false;
    }

    // Pass through
    $$ = $1;
  }
  | multiplicative_expression PERCENT cast_expression {
    // Log reduction
    TR_LOGGER.PushReduction(
      "multiplicative_expression PERCENT cast_expression "
      "-> multiplicative_expression");
    // Check if the $3 is equal to zero
    if(!IsInteger($1.front()) || !IsInteger($3.front())) {
      TR_LOGGER.Error("Cannot modulo something of not integer type", LINE, COLUMN);
    }
    if($3.front().data_is_valid && 
       $3.front().data_value.unsigned_long_long_val == 0) {
      TR_LOGGER.Error("Cannot modulo something of not integer type", LINE, COLUMN);
    }

    // Perform the modulo operation.
    if($3.front().data_is_valid && $1.front().data_is_valid) {
      if(IsUnsigned($1.front()) && IsUnsigned($3.front())) {
        $1.front().data_value.unsigned_long_long_val 
            %= $3.front().data_value.unsigned_long_long_val;
      } else if (!IsUnsigned($1.front()) && IsUnsigned($3.front())) {
        $1.front().data_value.long_long_val 
            %= $3.front().data_value.unsigned_long_long_val;
      } else if (IsUnsigned($1.front()) && !IsUnsigned($3.front())) {
        $1.front().data_value.long_long_val 
            %= $3.front().data_value.unsigned_long_long_val;
      } else {
        $1.front().data_value.long_long_val 
            %= $3.front().data_value.long_long_val;
      }
    } else {
      $1.front().data_is_valid = false;
    }

    // Pass through
    $$ = $1;
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

    // Check down casting / up casting for numbers
    if(IsNumber($2.front()) && IsNumber($4.front())) {
      if (IsFloating($2.front()) && IsInteger($4.front())) {
        TR_LOGGER.Warning("Up casting", LINE, COLUMN);
      } else if (IsInteger($2.front()) && IsFloating($4.front())) {
        TR_LOGGER.Warning("Down casting", LINE, COLUMN);
      } else if (SizeOfNumber($2.front()) > SizeOfNumber($4.front())) {
        TR_LOGGER.Warning("Up casting", LINE, COLUMN);
      } else if (SizeOfNumber($2.front()) > SizeOfNumber($4.front())) {
        TR_LOGGER.Warning("Down casting", LINE, COLUMN);
      }
      $4.front().type_specifier_list = $2.front().type_specifier_list;
      $4.front().type_qualifier_list = $2.front().type_qualifier_list;
      $4.front().storage_class_specifier = $2.front().storage_class_specifier;
    }

    // Check if both pointers
    if($2.front().array_sizes.size() > 0 &&
       $4.front().array_sizes.size() > 0) {
      $4.front().array_sizes = $2.front().array_sizes;
      $4.front().type_specifier_list = $2.front().type_specifier_list;
      $4.front().type_qualifier_list = $2.front().type_qualifier_list;
      $4.front().storage_class_specifier = $2.front().storage_class_specifier;
    }

    // Not gonna deal with structs 
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
    
    
    IncrementSymbolInfoBy(temp, 1);
    $$ = list<SymbolInfo>({SymbolInfo(*temp)});

    SymbolInfo dummy;
    dummy.data_value.long_long_val = 1;
    dummy.type_specifier_list = $$.front().type_specifier_list;
    
    // Overflow Checking
    if(addOverflow($$.front(), dummy)){
      TR_LOGGER.Error("addition overflow detected", LINE, COLUMN);
    }
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

    IncrementSymbolInfoBy(temp, -1);
    $$ = list<SymbolInfo>({SymbolInfo(*temp)});

    SymbolInfo dummy;
    dummy.data_value.long_long_val = 1;
    dummy.type_specifier_list = $$.front().type_specifier_list;
    //overflow check
    if(subOverflow($$.front(), dummy)){
      TR_LOGGER.Error("subtraction overflow detected", LINE, COLUMN);
    }
  }
  | AMPERSAND cast_expression {
    // Log reduction
    TR_LOGGER.PushReduction("AMPERSAND cast_expression -> unary_expression");

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
    $$ = $2;
    // Make the data_value positive. Probably something like pushing a 0 to the 
    // highest bit.
    if($2.front().data_is_valid){
      $$.front().data_is_valid = true;
      if(IsNumber($2.front()) ){

        if( (($2.front().data_value.long_long_val) < 0) ){
        $$.front().data_value.long_long_val = (-1)*($2.front().data_value.long_long_val);
        }
      }
      else{
        TR_LOGGER.Error("Unkown type conversion, check that data is of type, char, int, float, or double.", LINE, COLUMN);
      }
    }
  }
  | MINUS cast_expression {
    // Log reduction
    TR_LOGGER.PushReduction("MINUS cast_expression -> unary_expression");

    // Check if unsigned. TODO: Warning message, C allows this but it is nonsensical
    $$ = $2;
    if($2.front().data_is_valid){
      $$.front().data_is_valid = true;
      if(IsNumber($2.front()) ){
        $$.front().data_value.long_long_val = (-1)*($2.front().data_value.long_long_val);
      }
      else{
        TR_LOGGER.Error("Unkown type conversion, check that data is of type, char, int, float, or double.", LINE, COLUMN);
      }
    }
  }
  | TILDE cast_expression {
    // Log reduction
    TR_LOGGER.PushReduction("TILDE cast_expression -> unary_expression");
    // Bitwise not operator 
    // Must be a number 
    $$ = $2;
    if($2.front().data_is_valid){
      $$.front().data_is_valid = true;
      if(IsNumber($2.front()) ){
        $$.front().data_value.long_long_val = ~($2.front().data_value.long_long_val);
      }
      else{
        TR_LOGGER.Error("Unkown type conversion, check that data is of type, char, int, float, or double.", LINE, COLUMN);
      }
    }

    // ~n = -(n+1)
    // Do this and pass through 
  }
  | BANG cast_expression {
    // Log operation.
    TR_LOGGER.PushReduction("BANG cast_expression -> unary_expression");
    $$ = $2;
    if($2.front().data_is_valid){
      $$.front().data_is_valid = true;
      if(IsNumber($2.front())){
        if($2.front().data_value.long_long_val == 0){
          $$.front().data_value.long_long_val = 1;
        }
        else{
          $$.front().data_value.long_long_val = 0;
        }
      }
      else{
        TR_LOGGER.Error("Unkown type conversion, check that data is of type: char, int, float, or double.", LINE, COLUMN);
      }
    }
    // if != 0 change to zero, change to 1 if not can be any number or pointer
    // !(R, P) -> {0,1} : P = pointer
  }
  | SIZEOF unary_expression {
    // Log operation.
    TR_LOGGER.PushReduction("SIZEOF unary_expression -> unary_expression");
    $$ = $2;
    // Becomes an integer
    if($2.front().data_is_valid){
      $$.front().data_is_valid = true;
      $$.front().type_specifier_list.push_front(SymbolTypes::INT);
      $$.front().data_value.long_long_val = sizeof($2.front().type_specifier_list.front());
    }
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
    $$ = list<SymbolInfo>();
    $$.push_front(SymbolInfo($1.front()));
    $$.front().identifier_name = "";
    $$.front().data_is_valid = false;

    // Update value such that $$ has one less pointer or array.
    if($1.front().array_sizes.size() > 0) {
      $$.front().array_sizes.pop_back();
    }

    Node * temp = new ArrayAccessNode(&($$.front()));
    temp->AddChild($1.front().node);
    temp->AddChild($3.front().node);

    $$.front().node = temp;

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
    $$ = list<SymbolInfo>();
    $$.push_front(SymbolInfo($1.front()));

    // Change symbol info to act like it has been called.
    $$.front().data_is_valid = false;
    $$.front().is_function = false;
    $$.front().identifier_name = string("");

    $$.front().node = new Node("FunctionCall", $$.front().node);
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

    // Compare parameters
    list<FunctionParameter>::iterator param_iter 
        = $1.front().parameters_types.begin();

    list<SymbolInfo>::iterator argument_iter
        = $3.begin();

    Node* temp_node = new Node("FunctionCall", $$.front().node);

    while(param_iter != $1.front().parameters_types.end() &&
          argument_iter != $3.end()) {
      if( !CompareParamToArgument(*param_iter, *argument_iter)) {
        TR_LOGGER.Error("Invalid function parameter.", LINE, COLUMN);
      }
      param_iter++;
      argument_iter++;

      temp_node->AddChild(new Node("argument"));
    }

    // Create new symbol info to be placed in $$
    $$ = list<SymbolInfo>();
    $$.push_front(SymbolInfo($1.front()));

    // Change function
    $$.front().data_is_valid = false;
    $$.front().is_function = false;
    $$.front().identifier_name = string("");
    $$.front().node = temp_node;
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

    temp->postfix_increment++;
    $$ = list<SymbolInfo>({SymbolInfo(*temp)});

    //overflow check
    SymbolInfo dummy;
    dummy.data_value.long_long_val = 1;
    dummy.type_specifier_list = $$.front().type_specifier_list;
    if(addOverflow($$.front(), dummy)){
      TR_LOGGER.Error("addition overflow detected", LINE, COLUMN);
    }

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

    temp->postfix_increment++;
    $$ = list<SymbolInfo>({SymbolInfo(*temp)});
    SymbolInfo dummy;
    dummy.data_value.long_long_val = 1;
    dummy.type_specifier_list = $$.front().type_specifier_list;
    //overflow check
    if(subOverflow($$.front(), dummy)){
      TR_LOGGER.Error("subtraction overflow detected", LINE, COLUMN);
    }
  }
  ;

primary_expression
  : identifier {
    // Log reduction.
    TR_LOGGER.PushReduction("identifier -> primary_expression");
    // Pass through
    $$ = $1;
  }
  | constant {
    // Log reduction;
    TR_LOGGER.PushReduction("constant -> primary_expression");
    // Pass through
    $$ = $1;
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
    // Log reduction.
    TR_LOGGER.PushReduction(
      "assignment_expression -> argument_expression_list");
    // Pass through
    $$ = $1;
  }
  | argument_expression_list COMMA assignment_expression {
    // Log reduction
    TR_LOGGER.PushReduction(
      "argument_expression_list COMMA assignment_expression "
      "-> argument_expression_list");

    // Pass through
    $1.push_back(SymbolInfo($3.front()));
    $$ = $1;
  }
  ;

constant
  : INTEGER_CONSTANT {
    $$ = $1;
    $$.front().node 
        = new IntegerConstantNode($$.front().data_value.char_val);

    TR_LOGGER.PushReduction("INTEGER_CONSTANT -> constant");
  }
  | CHARACTER_CONSTANT {
    $$ = $1;
    $$.front().node 
      = new CharConstantNode($$.front().data_value.char_val);
    TR_LOGGER.PushReduction("CHARACTER_CONSTANT -> constant");
  }
  | FLOATING_CONSTANT {
    $$ = $1;
    $$.front().node = new FloatingConstantNode($$.front().data_value.double_val);
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
    $$.front().node = 
        new IdentifierNode(S_TABLE.GetMostRecentSymbolInfo(
          $$.front().identifier_name));
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
    INSERT_MODE = true;
  }

%%
/******************************************************************************/
/* User Written Code */
/******************************************************************************/
int main(int argc, char** argv) {
  CL_FLAGS.InitializeFlags(argc, argv);
  // TR_LOGGER.SetDebugType(TOKENS_AND_REDUCTIONS);
  TR_LOGGER.SetDebugType(CL_FLAGS.GetDebugType());
  TR_LOGGER.SetSymbolTable(&S_TABLE);

  if((new ifstream(CL_FLAGS.GetInputFile()))->good()) {
    yyin = fopen(CL_FLAGS.GetInputFile().c_str(), "r");
  }
  return yyparse(); 
}

void yyerror(const char * err) {
  string new_err(err);
  new_err[0] = toupper(new_err[0], locale());
  TR_LOGGER.Error(new_err, LINE, COLUMN - 1);
}

