/*
 * CommandLineFlags.cpp
 *
 *  Created on: Oct 8, 2015
 *      Author: ernestlandrito
 */

#include "CommandLineFlags.h"
#include <iostream>
#include <fstream>
using namespace std;

CommandLineFlags::CommandLineFlags() :
		flag_debug(NO_DEBUGGING),
		flag_output_file("PA6_Driver_Output.txt"),
		flag_input_file("") {}

bool CommandLineFlags::InitializeFlags(int argc, char** argv) {
	if (argc < 2) {
			cerr << "[ERROR] No input file specified to be parsed." << endl;
			return false;
		}

	for(int i = 1; i < argc; i++) {
		if(string(argv[i]) == "-d") flag_debug = NO_DEBUGGING;
		else if(string(argv[i]) == "-ds") flag_debug = SYMBOL_TABLE;
		else if(string(argv[i]) == "-dls" ||
		   string(argv[i]) == "-dsl" ) flag_debug = LEXER_AND_SYMBOL_TABLE;
		else if(string(argv[i]) == "-dl") flag_debug = LEXER;
		else if(string(argv[i]) == "-o") {
			i++;
			if (i >= argc || string(argv[i])[0] == '-') {
				cerr << "[ERROR] No output file specified." << endl;
				return false;
			}
			flag_output_file = string(argv[i]);
		}
		else if(argv[i][0] == '-') {
			cerr << "[ERROR] Unknown flag " << argv[i] << " input." << endl;
		}
		else {
			if(!(new ifstream(argv[i]))->good()) {
				cerr << "[ERROR] Input file " << argv[i] << " not found" << endl;
				return false;
			}
			flag_input_file = string(argv[i]);
		}
	}
	if (flag_input_file == "") {
		cerr << "[ERROR] Input file missing." << endl;
		return false;
	}
	return true;
}

DebugType CommandLineFlags::GetDebugType() {
	return flag_debug;
}

string CommandLineFlags::GetOutputFile() {
	return flag_output_file;
}

void CommandLineFlags::Print() {
	switch (flag_debug) {
	case NO_DEBUGGING:
		cout << "No Debugging" << endl;
		break;

	case SYMBOL_TABLE:
		cout << "Symbol Table Debugging" << endl;
		break;

	case LEXER_AND_SYMBOL_TABLE:
		cout << "Lexer and Symbol Table Debugging" << endl;
		break;

	case LEXER:
		cout << "Lexer Debugging" << endl;
		break;
	}
	cout << "Output File: " << flag_output_file << endl;
	cout << "Input File: " << flag_input_file << endl;
}
