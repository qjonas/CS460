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
	token_reductions_.push_back((new string("Token : "))->append(token));
	token_reductions_.push_back("Reductions: ");
}

void TokenReductionsLogger::PushReduction(const string& reduct) {
	token_reductions_.push_back( (new string("\t"))->append(reduct));
}

void TokenReductionsLogger::PushSourceWord(const string& word) {
	source_line_.push_back(word);
}

void TokenReductionsLogger::LogTokenReductions() {
	if (console_output_) {
		for(string str : token_reductions_) {
			cout << str << endl;
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
		cout << "Source: ";
		for(string word : source_line_) {
			cout << word;
		}
		cout << endl;
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

TokenReductionsLogger::TokenReductionsLogger() : file_out_(NULL), console_output_(true) {}
