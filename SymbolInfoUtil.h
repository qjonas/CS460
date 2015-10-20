#ifndef SYMBOLINFOUTIL_H_
#define SYMBOLINFOUTIL_H_

#include "SymbolTable.h"

bool IsDataTypeValid(const SymbolInfo& symbol_info);
bool IsTypeQualifierValid(const SymbolInfo& symbol_info);
bool IsExpressionValidArraySubscript(const SymbolInfo symbol_info);
bool IsDataTypeValidForIncDec(const SymbolInfo& symbol_info);
bool IsConst(const SymbolInfo& symbol_info);
void IncrementSymbolInfoBy(SymbolInfo* symbol_info, int value);
bool IsNumber(const SymbolInfo& symbol_info);
bool IsInteger(const SymbolInfo& symbol_info);
bool IsFloating(const SymbolInfo& symbol_info);
int SizeOfNumber(const SymbolInfo& symbol_info);
#endif //SYMBOLINFOUTIL_H_