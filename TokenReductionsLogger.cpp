/*
 * TokenReductionsLogger.cpp
 *
 *  Created on: Oct 11, 2015
 *      Author: ernestlandrito
 */

#include "TokenReductionsLogger.h"

#include <iostream>
#include <ostream>
#include <string>
#include <vector>

#include "Escape_Sequences_Colors.h"


using namespace std;

TokenReductionsLogger& TokenReductionsLogger::GetInstance() {
	static TokenReductionsLogger instance;
	return instance;
}

void TokenReductionsLogger::AddOutputToFile(const string& file_name) {
	file_out_ = new ofstream(file_name);
}

void TokenReductionsLogger::OutputToConsole(bool yes_or_no) {
	console_output_ = yes_or_no;
}

void TokenReductionsLogger::PushToken(const string& token) {
	if(!token_reductions_.empty() && token_reductions_.back() == "Reductions: ") {
		token_reductions_.pop_back();
	}
	token_reductions_.push_back((new string("Token : "))->append(COLOR_MAGENTA_NORMAL).append(token).append(COLOR_NORMAL));
	token_reductions_.push_back("Reductions: ");
}

void TokenReductionsLogger::PushReduction(const string& reduct) {
	token_reductions_.push_back( (new string("\t"))->append(COLOR_CYAN_NORMAL).append(reduct).append(COLOR_NORMAL));
}

void TokenReductionsLogger::PushSourceWord(const string& word) {
	source_line_.push_back(word);
}

void TokenReductionsLogger::LogTokenReductions() {
	if (console_output_) {
		for(string str : token_reductions_) {
			cout  << str << endl;
		}
	}

	if (file_out_ != NULL) {
		for(string str : token_reductions_) {
			*(file_out_) << str << endl;
		}
	}
	token_reductions_.clear();
}

void TokenReductionsLogger::LogSourceLine() {
	if (console_output_) {
		cout <<  "Source: " << COLOR_GREEN_NORMAL;
		for(string word : source_line_) {
			cout << word;
		}
		cout << COLOR_NORMAL << endl;
	}

	if (file_out_ != NULL) {
		*(file_out_) << "Source: ";
		for(string word : source_line_) {
			*(file_out_) << word;
		}
		*(file_out_) << endl;
	}
	source_line_.clear();
}

void TokenReductionsLogger::Error(
	const std::string& error, int line, int COLUMN) {
	LogTokenReductions();
	if (console_output_) {
		cerr <<  COLOR_BLINK_RED_NORMAL << "ERROR: " <<  COLOR_NORMAL << error << endl;
		cerr << "Line: " << line << " Column: " << COLUMN << endl;
		cerr  << "Source: ";
		for(string word : source_line_) {
			cerr << word;
		}
		cerr << endl;
		for(int i = 0; i < COLUMN + 7; i++) cerr << " ";
		cerr << "^" << endl;
	}

	if (file_out_ != NULL) {
		*(file_out_) << "ERROR: " << error <<  endl;
		*(file_out_) << " Line: " << line << " Column: " << COLUMN << endl;
		*(file_out_) << "Source: ";
		for(string word : source_line_) {
			*(file_out_) << word;
		}
		*(file_out_) << endl;
		for(int i = 0; i < COLUMN + 7; i++) *(file_out_) << " ";
		*(file_out_) << "^" << endl;
	}
	exit(0);
}

void TokenReductionsLogger::Warning(
	const std::string& error, int line, int COLUMN) {
	if (console_output_) {
		cerr << COLOR_BLINK_YELLOW_NORMAL << "WARNING: " << COLOR_NORMAL 
				 << error << endl;
		cerr << "Line: " << line << " Column: " << COLUMN << endl;
		cerr  << "Source: ";
		for(string word : source_line_) {
			cerr << word;
		}
		cerr << endl;
		for(int i = 0; i < COLUMN + 9; i++) cerr << " ";
		cerr << "^" << endl;
	}

	if (file_out_ != NULL) {
		*(file_out_) << "WARNING: " << error <<  endl;
		*(file_out_) << " Line: " << line << " Column: " << COLUMN << endl;
		*(file_out_) << "Source: ";
		for(string word : source_line_) {
			*(file_out_) << word;
		}
		*(file_out_) << endl;
		for(int i = 0; i < COLUMN + 9 ; i++) *(file_out_) << " ";
		*(file_out_) << "^" << endl;
	}
}

TokenReductionsLogger::TokenReductionsLogger() : file_out_(NULL), console_output_(true) {}
