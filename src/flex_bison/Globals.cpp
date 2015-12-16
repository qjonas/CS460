#include <vector>
#include <string>
#include "../abstract_syntax_tree/Node.h"
#include "../helpers/CommandLineFlags.h"
#include "../helpers/TokenReductionsLogger.h"
#include "../symbol_table/SymbolTable.h"

CommandLineFlags CL_FLAGS = CommandLineFlags::GetInstance();
SymbolTable S_TABLE;
TokenReductionsLogger TR_LOGGER = TokenReductionsLogger::GetInstance();
std::vector< std::vector<std::string> > TAC_VECTOR;


bool INSERT_MODE = true;
bool IN_SWITCH = false;
int COLUMN = 1;
int LINE = 1;
int IN_FUNCTION = 0;