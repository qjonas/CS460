#include "CommandLineFlags.h"
#include "SymbolTable.h"
#include "TokenReductionsLogger.h"

CommandLineFlags CL_FLAGS = CommandLineFlags::GetInstance();
SymbolTable S_TABLE;
TokenReductionsLogger TR_LOGGER = TokenReductionsLogger::GetInstance();
bool INSERT_MODE = true;
bool IN_SWITCH = false;
int COLUMN = 1;
int LINE = 1;
int IN_FUNCTION = 0;