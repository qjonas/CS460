#include "SymbolType.h"

#include <iostream>
#include <fstream>
using namespace std;

int main() {
	SymbolInfo symbol_info;
	FunctionInfo function_info;

	function_info.parameters_types.push_back(SymbolTypes::INT);
	function_info.parameters_types.push_back(SymbolTypes::CHAR);

	symbol_info.identifier_name = "j";
	symbol_info.data_type = SymbolTypes::INT;
	symbol_info.is_function = false;
	symbol_info.data_value.int_val = 1234;
	symbol_info.data_is_valid = true;
	symbol_info.is_const = false;
	symbol_info.pointer_count = 0;

	cout << "Created SymbolInfo: " << endl << symbol_info;

	ofstream fout("SymbolType_test.txt");
	fout << symbol_info;
	fout.close();

	SymbolInfo symbol_info_2;
	ifstream fin("SymbolType_test.txt");
	fin >> symbol_info_2;
	fin.close();

	cout << endl << "FileOut->FileIn SymbolInfo: " << endl << symbol_info_2;
	return 0;
}