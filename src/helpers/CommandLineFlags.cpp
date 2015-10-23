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

CommandLineFlags& CommandLineFlags::GetInstance() {
	static CommandLineFlags instance;
	return instance;
}

CommandLineFlags::CommandLineFlags() :
		flag_debug(NO_DEBUGGING),
		flag_output_file("PA6_Driver_Output.txt"),
		flag_input_file("") {}

bool CommandLineFlags::InitializeFlags(int argc, char** argv) {
	for(int i = 1; i < argc; i++) {
		if(string(argv[i]) == "-d") flag_debug = NO_DEBUGGING;
		else if(string(argv[i]) == "-ds") flag_debug = SYMBOL_TABLE;
		else if(string(argv[i]) == "-dts" ||
		   			string(argv[i]) == "-dst" ) flag_debug = TOKENS_AND_SYMBOL_TABLE;
		else if(string(argv[i]) == "-dt") flag_debug = TOKENS;
		else if(string(argv[i]) == "-dtr" ||
						string(argv[i]) == "-drt") flag_debug = TOKENS_AND_REDUCTIONS;
		else if(string(argv[i]) == "-drs" ||
						string(argv[i]) == "-dsr") flag_debug = REDUCTIONS_AND_SYMBOL_TABLE;
		else if(string(argv[i]) == "-dr") flag_debug = REDUCTIONS; 
		else if(string(argv[i]) == "-ds") flag_debug = SYMBOL_TABLE;
		else if(string(argv[i]) == "-dtrs" ||
						string(argv[i]) == "-dtsr" ||
						string(argv[i]) == "-dstr" ||
						string(argv[i]) == "-dsrt" ||
						string(argv[i]) == "-drst" ||
						string(argv[i]) == "-drts") flag_debug = TOKENS_AND_REDUCTIONS_AND_SYMBOL_TABLE;
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
				// No Input file.
				return false;
			}
			flag_input_file = string(argv[i]);
		}
	}
	if (flag_input_file == "") {
		// No Input file.
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

string CommandLineFlags::GetInputFile() {
	return flag_input_file;
}

void CommandLineFlags::Print() {
	switch (flag_debug) {
	case NO_DEBUGGING:
		cout << "No Debugging" << endl;
		break;

	case SYMBOL_TABLE:
		cout << "Symbol Table Debugging" << endl;
		break;

	case TOKENS:
		cout << "Tokens Debugging" << endl;
		break;

	case REDUCTIONS:
		cout << "Reductions Debugging" << endl;
		break;

	case TOKENS_AND_SYMBOL_TABLE:
		cout << "Tokens and Symbol Table Debugging" << endl;
		break;

	case TOKENS_AND_REDUCTIONS:
		cout << "Tokens and Reductions Debugging" << endl;
		break;

	case REDUCTIONS_AND_SYMBOL_TABLE:
		cout << "Reductions and Symbol Table Debugging" << endl;
		break;

	case TOKENS_AND_REDUCTIONS_AND_SYMBOL_TABLE:
		cout << "Tokens, Reductions, and Symbol Table Debugging" << endl;
		break;
	}
	cout << "Output File: " << flag_output_file << endl;
	cout << "Input File: " << flag_input_file << endl;
}
