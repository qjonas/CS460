#include "CommandLineFlags.h"
#include "SymbolTable.h"
#include "TokenReductionsLogger.h"

CommandLineFlags CL_FLAGS = CommandLineFlags::GetInstance();
SymbolTable S_TABLE = SymbolTable::GetInstance();
TokenReductionsLogger TR_LOGGER = TokenReductionsLogger::GetInstance();