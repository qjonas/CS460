/*
 * TokenReductionsLogger_test.h
 *
 *  Created on: Oct 11, 2015
 *      Author: ernestlandrito
 */
#include "TokenReductionsLogger.h"

int main() {
	TokenReductionsLogger logger = TokenReductionsLogger::GetInstance();

	logger.AddOutputToFile("logger_out_test.txt");
	logger.PushToken("Token_1");
	logger.PushReduction("Reduct1 -> Token_1");
	logger.PushToken("Token_2");
	logger.PushReduction("Token_1 -> Token_2");

	logger.PushSourceWord("This is a source line;");

	logger.LogSourceLine();
	logger.LogTokenReductions();

}


