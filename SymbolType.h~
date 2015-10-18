 /*
 * SymbolType.h
 *
 *  Created on: Oct 9, 2015
 *      Author: ernestlandrito
 */

#ifndef SYMBOLTYPE_H_
#define SYMBOLTYPE_H_

#include <vector>
#include <string>
#include <istream>
#include <ostream>

// SymbolType will enumerate the primitive data types in C.
namespace SymbolTypes{
enum SymbolType {
	CHAR, SHORT, INT, LONG, FLOAT, DOUBLE, TYPEDEF, STRING
};
}

// FunctionInfo will store information of function identifiers in C.
struct FunctionInfo {
	// Parameter types will list the parameter types of a function.
	// ex: int foo(int i, char c, double d);
	// parameter_types = {INT, CHAR, DOUBLE};
	std::vector<SymbolTypes::SymbolType> parameters_types;

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
	unsigned long long unsigned_long_long_val;
	double double_val;
	std::string * string_val;
	FunctionInfo * function_info;
};

// SymbolInfo will store all of the information of the identifier.
typedef struct SymbolInfo {
	// Identifier name will store the name of the identifier.
	std::string identifier_name;

	// Data type will store the enumerated SymbolType value of the identifier.
	SymbolTypes::SymbolType data_type;

	// Is const denotes whether an identifier is function.
	bool is_function;

	// Data value will store a pointer to the value of associated with an identifier.
	SymbolValue data_value;

	// Denotes if the data value is still valid for value checking
	bool data_is_valid;

	// Is const denotes whether an identifier is constant.
	bool is_const;

	// Is unsigned denotes whether an identifier is an unsigned.
	bool is_unsigned;

	enum Longs{
		NO_LONG, ONE_LONG, TWO_LONG
	};

	Longs num_longs;

	// Pointer Count will denote the number of '*' there are for a given identifier.
	// ex: int** i; Will have a pointer_counter equal to 2
	unsigned int pointer_count;
} SymbolInfo;

std::ostream& operator <<(std::ostream &os, SymbolInfo &symbol_info);
std::istream& operator >>(std::istream &is, SymbolInfo &symbol_info);

#endif /* SYMBOLTYPE_H_ */
