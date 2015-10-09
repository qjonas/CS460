/*
 * FrontendFlags.h
 *
 *  Created on: Oct 8, 2015
 *      Author: ernestlandrito
 */

#ifndef FrontendFlags_H_
#define FrontendFlags_H_

#include <string>

class FrontendFlags {
public:
	FrontendFlags();
	enum DebugType {NO_DEBUGGING, LEXER, SYMBOL_TABLE, LEXER_AND_SYMBOL_TABLE};
	bool InitializeFlags(int argc, char** argv);
	DebugType GetDebugType();
	std::string GetOutputFile();
	void Print();

private:
	DebugType flag_debug;
	std::string flag_output_file;
	std::string flag_input_file;
};

#endif /* FrontendFlags_H_ */
