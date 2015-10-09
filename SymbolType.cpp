#include "SymbolType.h"

#include <iostream>
#include <istream>
#include <ostream>
#include <stdlib.h>

using namespace std;


std::ostream& operator <<(std::ostream &os, FunctionInfo &function_info) {
	os << "{ ";
	os << "parameter_types: {";
	for(SymbolType type : function_info.parameters_types) os << ' ' << type;
	os << " } ";
	os << "range_start: " << function_info.range_start;
	os << " }";

	return os;
}
std::istream& operator >>(std::istream &is, FunctionInfo &function_info) {
	char dummy_char;
	string dummy_str;
	int enum_value = -1;

	is >> dummy_char;
	is >> dummy_str >> dummy_char;
	do {
		is >> dummy_str;
		function_info.parameters_types.push_back( (SymbolType) (atoi(dummy_str.c_str())));
	} while(dummy_str != "}");
	is >> dummy_str >> function_info.range_start;
	is >> dummy_char;

	return is;
}

ostream& operator <<(ostream &os, SymbolInfo &symbol_info) {
	os << '{' << endl;
	os << "identifier_name: " << symbol_info.identifier_name << endl;
	os << "data_type: " << symbol_info.data_type << endl;
	os << "is_function: " << symbol_info.is_function << endl;
	os << "data_value: ";

	if (symbol_info.is_function) {
		os << symbol_info.data_value.function_info;
	} else {
		switch(symbol_info.data_type) {
			case CHAR:
				os << symbol_info.data_value.char_val;
				break;

			case SHORT:
				os << symbol_info.data_value.short_val;
				break;

			case INT:
				os << symbol_info.data_value.int_val;
				break;

			case LONG:
				os << symbol_info.data_value.long_val;
				break;

			case FLOAT:
				os << symbol_info.data_value.float_val;
				break;

			case DOUBLE:
				os << symbol_info.data_value.double_val;
				break;

			case TYPEDEF: //Fix Later
				os << "none";
				break;
		}
	}
	os << endl;
	os << "data_is_valid: " << symbol_info.data_is_valid << endl;
	os << "is_const: " << symbol_info.is_const << endl;
	os << "pointer_count: " << symbol_info.pointer_count << endl;
	os << '}' << endl;

	return os;
}

istream& operator >>(istream &is, SymbolInfo &symbol_info) {
	char dummy_char;
	string dummy_str;
	int enum_value = -1;

	is >> dummy_char;
	is >> dummy_str >> symbol_info.identifier_name;
	is >> dummy_str >> enum_value;
	symbol_info.data_type = SymbolType(enum_value);
	is >> dummy_str >> symbol_info.is_function;
	is >> dummy_str;

	if (symbol_info.is_function) {
		is >> symbol_info.data_value.function_info;
	} else {
		switch(symbol_info.data_type) {
			case CHAR:
				is >> symbol_info.data_value.char_val;
				break;

			case SHORT:
				is >> symbol_info.data_value.short_val;
				break;

			case INT:
				is >> symbol_info.data_value.int_val;
				break;

			case LONG:
				is >> symbol_info.data_value.long_val;
				break;

			case FLOAT:
				is >> symbol_info.data_value.float_val;
				break;

			case DOUBLE:
				is >> symbol_info.data_value.double_val;
				break;

			case TYPEDEF: //Fix Later
				is >> dummy_str;
				break;
		}
	}
	is >> dummy_str >> symbol_info.data_is_valid;
	is >> dummy_str >> symbol_info.is_const;
	is >> dummy_str >> symbol_info.pointer_count;
	is >> dummy_char;

	return is;
}
