/*
 * CommandLineFlags.h
 *
 *  Created on: Oct 8, 2015
 *      Author: ernestlandrito
 */

#ifndef CommandLineFlags_H_
#define CommandLineFlags_H_

#include <string>

enum DebugType {NO_DEBUGGING, LEXER, SYMBOL_TABLE, LEXER_AND_SYMBOL_TABLE};

class CommandLineFlags {
public:
	static CommandLineFlags& GetInstance();
	bool InitializeFlags(int argc, char** argv);
	DebugType GetDebugType();
	std::string GetInputFile();
	std::string GetOutputFile();
	void Print();

private:
  CommandLineFlags();
	DebugType flag_debug;
	std::string flag_output_file;
	std::string flag_input_file;
};

#endif /* CommandLineFlags_H_ */
