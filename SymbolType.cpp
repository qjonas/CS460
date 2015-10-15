#include "SymbolType.h"

#include <iostream>
#include <istream>
#include <ostream>
#include <stdlib.h>

using namespace std;


std::ostream& operator <<(std::ostream &os, FunctionInfo &function_info) {
	os << "{ ";
	os << "parameter_types: {";
	for(SymbolTypes::SymbolType type : function_info.parameters_types) os << ' ' << type;
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
		function_info.parameters_types.push_back( (SymbolTypes::SymbolType) (atoi(dummy_str.c_str())));
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
	os << "is_unsigned: " << symbol_info.is_unsigned << endl;
	os << "num_longs: " << symbol_info.num_longs << endl;
	os << "data_value: ";

	if (symbol_info.is_function) {
		os << *(symbol_info.data_value.function_info);
	} else {
		switch(symbol_info.data_type) {
			case SymbolTypes::CHAR:
				os << symbol_info.data_value.char_val;
				break;

			case SymbolTypes::STRING:
				if(symbol_info.data_value.string_val != NULL) {
					// There could be an error here if string is not set well.
					os << *(symbol_info.data_value.string_val);
				}

			case SymbolTypes::SHORT:
			case SymbolTypes::INT:
			case SymbolTypes::LONG:
				if(symbol_info.is_unsigned) {
					os << symbol_info.data_value.unsigned_long_long_val;
				} else {
					os << symbol_info.data_value.long_long_val;
				}
				break;

			case SymbolTypes::FLOAT:
			case SymbolTypes::DOUBLE:
				os << symbol_info.data_value.double_val;
				break;

			case SymbolTypes::TYPEDEF: //Fix Later
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
	symbol_info.data_type = SymbolTypes::SymbolType(enum_value);
	is >> dummy_str >> symbol_info.is_function;
	is >> dummy_str >> symbol_info.is_unsigned;
	is >> dummy_str >> enum_value;
	symbol_info.num_longs = SymbolInfo::Longs(enum_value);
	is >> dummy_str;

	if (symbol_info.is_function) {
		if(!symbol_info.data_value.function_info) delete symbol_info.data_value.function_info;
		symbol_info.data_value.function_info = new FunctionInfo();
		is >> *(symbol_info.data_value.function_info);
	} else {
		switch(symbol_info.data_type) {
			case SymbolTypes::CHAR:
				is >> symbol_info.data_value.char_val;
				break;

			case SymbolTypes::STRING:
				if(symbol_info.data_value.string_val != NULL) {
					// There could be an error here if string is not set well.
					string * temp = new string();
					is >> *temp;
					symbol_info.data_value.string_val = temp;
				}

			case SymbolTypes::SHORT:
			case SymbolTypes::INT:
			case SymbolTypes::LONG:
				if(symbol_info.is_unsigned) {
					is >> symbol_info.data_value.unsigned_long_long_val;
				} else {
					is >> symbol_info.data_value.long_long_val;
				}
				break;

			case SymbolTypes::FLOAT:
			case SymbolTypes::DOUBLE:
				is >> symbol_info.data_value.double_val;
				break;

			case SymbolTypes::TYPEDEF: //Fix Later
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
