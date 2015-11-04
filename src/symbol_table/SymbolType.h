 /*
 * SymbolType.h
 *
 *  Created on: Oct 9, 2015
 *      Author: ernestlandrito
 */

#ifndef SYMBOLTYPE_H_
#define SYMBOLTYPE_H_

#include <istream>
#include <list>
#include <ostream>
#include <string>
#include <vector>

#include "../abstract_syntax_tree/Node.h"

// SymbolType will enumerate the primitive data types in C.
namespace SymbolTypes{
enum SymbolType {
	STRUCT, UNION, ENUM, TYPEDEF_NAME, SIGNED, UNSIGNED, SHORT, LONG, 
	CHAR, INT, FLOAT, DOUBLE, STRING
};
enum StorageClassSpecifier {
	NONE, AUTO, REGISTER, STATIC, EXTERN, TYPEDEF
};
enum TypeQualifier {
	CONST, VOLATILE
};
}

std::ostream& operator<<(std::ostream &os, SymbolTypes::SymbolType symbol_type);
std::ostream& operator<<(std::ostream &os, SymbolTypes::StorageClassSpecifier storage_class_specifier);
std::ostream& operator<<(std::ostream &os, SymbolTypes::TypeQualifier type_qualifier);


// FunctionInfo will store information of function identifiers in C.
struct FunctionInfo {
	// Parameter types will list the parameter types of a function.
	// ex: int foo(int i, char c, double d);
	// parameter_types = {INT, CHAR, DOUBLE};
	std::list<SymbolTypes::SymbolType> parameters_types;

	// Range start will denote which parameter holds the elipses.
	// ex_1: int foo(int i, char c, ...);
	// range_start = 2
	// ex_2: int bar(...);
	// range_start = 0
	// ex_3: int baz();
	// range_start = -1
	int range_start;
};

std::ostream& operator <<(std::ostream &os, FunctionInfo &function_info);
std::istream& operator >>(std::istream &is, FunctionInfo &function_info);

// SymbolValue will union the values of the identifiers.
union SymbolValue {
	char char_val;
	long long long_long_val;
	int int_val;
	unsigned long long unsigned_long_long_val;
	long double double_val;
	std::string * string_val;
	FunctionInfo * function_info;
};

// SymbolInfo will store all of the information of the identifier.
typedef struct SymbolInfo {
	SymbolInfo();
	// Identifier name will store the name of the identifier.
	std::string identifier_name;

	// Data type will store the enumerated SymbolType value of the identifier.
	std::list<SymbolTypes::SymbolType> type_specifier_list;

	// This will store the storage classifier type
	SymbolTypes::StorageClassSpecifier storage_class_specifier;

	// This will store a list of type qualifiers
	std::list<SymbolTypes::TypeQualifier> type_qualifier_list;

	// Name of type if type_specifier is a typedef_name;
	std::string typedef_name;

	// Is const denotes whether an identifier is function.
	bool is_function;

	// Data value will store a pointer to the value of associated with an identifier.
	SymbolValue data_value;

	// Denotes if the data value is still valid for value checking
	bool data_is_valid;

	// Pointer Count will denote the number of '*' there are for a given identifier.
	// ex: int** i; Will have a pointer_counter equal to 2
	unsigned int pointer_count;

	// This will hold the node
	AST::Node * node;
} SymbolInfo;

std::ostream& operator <<(std::ostream &os, SymbolInfo &symbol_info);
std::istream& operator >>(std::istream &is, SymbolInfo &symbol_info);


#endif /* SYMBOLTYPE_H_ */
