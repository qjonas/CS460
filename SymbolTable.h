/*
 * SymbolTable.h
 *
 *  Created on: Sep 21, 2015
 *      Author: ernestlandrito
 */

#ifndef SYMBOLTABLE_H_
#define SYMBOLTABLE_H_

#include <iterator>
#include <list>
#include <map>
#include <stack>
#include <string>

struct SymbolInfo;

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
const int NO_ARRAY_SIZE = -1;
}

class SymbolTable {
public:
	// Constructor
	SymbolTable();

	// Insert a new identifier into the symbol table
	bool InsertSymbol(const std::string& name, SymbolInfo value);

	// This will search for the symbol throughout the entire symbol table and return
	// an iterator to the symbol that is the closest to the top of the stack.
	SymbolInfo* GetMostRecentSymbolInfo(const std::string& search_name);

	bool HasShadowing(const std::string& search_name) const;

	bool HasInScope(const std::string& search_name) const;

	// This will search for the symbol throughout the entire symbol table and 
	// return true if the name is in the symbol table somewhere.
	bool Has(const std::string& search_name) const;

	// This will take the symbol table and turn it into a form that will be able to
	// be read by the contruct from file constructor
	void OutputToFile(const std::string& file_name) const;

	void Print() const;

	// Creates a new stack frame.
	void PushFrame();
	
	// Removes a stack frame. Will return false if already at the global scope.
	bool PopFrame();

	// Makes it such that the instance is like it is freshly instantiated.
	void Reset();

	// Copies the output of a previous symbol table.
	void CopyFromFile(const std::string& file_name);

	// Searches through 
	void PerformPostfixIncrement();

	std::list< std::map<std::string, SymbolInfo> > table_;
};

struct FunctionParameter {
	/* Members Deaing with Data Type */
	// Data type will store the enumerated SymbolType value of the identifier.
	std::list<SymbolTypes::SymbolType> type_specifier_list;

	// This will store the storage classifier type
	SymbolTypes::StorageClassSpecifier storage_class_specifier;

	// This will store a list of type qualifiers
	std::list<SymbolTypes::TypeQualifier> type_qualifier_list;

	// Contains the sizes of the arrays declared with square brackets. Empty
	// brackets will have an ambiguous size and the value in the list will be
	// SymbolTypes::AMBIGUOUS_ARRAY_SIZE
	// The size of the array_sizes list will be the number of square brackets.
	std::list<int> array_sizes;
};

// SymbolValue will union the values of the identifiers.
union SymbolValue {
	char char_val;
	long long long_long_val;
	unsigned long long unsigned_long_long_val;
	double double_val;
	std::string * string_val;
};

// SymbolInfo will store all of the information of the identifier.
typedef struct SymbolInfo {
	SymbolInfo();
	SymbolInfo(const SymbolInfo& other);

	/* Basic SymbolInfo */
	// Identifier name will store the name of the identifier.
	// Only SymbolInfos with names are going to be in the Symbol table.
	std::string identifier_name;

	// Data value will store a pointer to the value of associated with an identifier.
	SymbolValue data_value;
	// Denotes if the data value is still valid for value checking
	bool data_is_valid;

	/* Members Deaing with Data Type */
	// Data type will store the enumerated SymbolType value of the identifier.
	std::list<SymbolTypes::SymbolType> type_specifier_list;

	// This will store the storage classifier type
	SymbolTypes::StorageClassSpecifier storage_class_specifier;

	// This will store a list of type qualifiers
	std::list<SymbolTypes::TypeQualifier> type_qualifier_list;

	// Name of type if type_specifier is a typedef_name;
	std::string typedef_name;

	// Values inside of struct
	SymbolTable struct_or_union_values;

	// Contains the sizes of the arrays declared with square brackets. Empty
	// brackets will have an ambiguous size and the value in the list will be
	// SymbolTypes::AMBIGUOUS_ARRAY_SIZE
	// The size of the array_sizes list will be the number of square brackets.
	std::list<int> array_sizes;


	/* Member dealing with identifier being a function */
	// Is const denotes whether an identifier is function.
	bool is_function;

	// Parameter types will list the parameter types of a function.
	// ex: int foo(int i, char c, double d);
	// parameter_types = {{INT}, {CHAR}, {DOUBLE}};
	std::list<FunctionParameter> parameters_types;

	// Range start will denote which parameter holds the elipses.
	// ex_1: int foo(int i, char c, ...);
	// range_start = 2
	// ex_2: int bar(...);
	// range_start = 0
	// ex_3: int baz();
	// range_start = -1
	int range_start;

	// Postfix Increment
	int postfix_increment;
} SymbolInfo;

std::ostream& operator<<(std::ostream &os, SymbolTypes::SymbolType symbol_type);
std::ostream& operator<<(std::ostream &os, SymbolTypes::StorageClassSpecifier storage_class_specifier);
std::ostream& operator<<(std::ostream &os, SymbolTypes::TypeQualifier type_qualifier);


#endif /* SYMBOLTABLE_H_ */
