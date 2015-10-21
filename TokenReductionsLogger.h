 /*
 * TokenReductionsLogger.h
 *
 *  Created on: Oct 11, 2015
 *      Author: ernestlandrito
 */

#ifndef TOKENREDUCTIONSLOGGER_H_
#define TOKENREDUCTIONSLOGGER_H_

#include <ostream>
#include <fstream>
#include <string>
#include <vector>

#include "CommandLineFlags.h"
#include "SymbolTable.h"

class TokenReductionsLogger {
public:
	static TokenReductionsLogger& GetInstance();
	void AddOutputToFile(const std::string& file_name);
	void SetSymbolTable(SymbolTable* table);
	void SetDebugType(DebugType debug_type);
	void PushToken(const std::string& token);
	void PushReduction(const std::string& reduct);
	void PushSourceWord(const std::string& word);
	void Error(const std::string& error, int line, int COLUMN);
	void Warning(const std::string& error, int line, int COLUMN);
	void LogTokenReductions();
	void LogSourceLine();

private:
	TokenReductionsLogger();
	std::vector<std::string> token_reductions_;
	std::vector<std::string> tokens_;
	std::vector<std::string> reductions_;
	std::vector<std::string> source_line_;
	std::ofstream* file_out_;
	SymbolTable* symbol_table;
	DebugType debug_type;
};

#endif /* TOKENREDUCTIONSLOGGER_H_ */
