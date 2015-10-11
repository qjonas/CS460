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

class TokenReductionsLogger {
public:
	static TokenReductionsLogger& GetInstance();
	void AddOutputToFile(const std::string& file_name);
	void OutputToConsole(bool yes_or_no);
	void PushToken(const std::string& token);
	void PushReduction(const std::string& reduct);
	void PushSourceWord(const std::string& word);
	void LogTokenReductions();
	void LogSourceLine();

private:
	TokenReductionsLogger();
	bool console_output_;
	std::vector<std::string> token_reductions_;
	std::vector<std::string> source_line_;
	std::ofstream* file_out_;
};

#endif /* TOKENREDUCTIONSLOGGER_H_ */
