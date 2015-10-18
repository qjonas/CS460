#ifndef SYMBOLINFOUTIL_H_
#define SYMBOLINFOUTIL_H_

#include "SymbolTable.h"

bool IsDataTypeValid(const SymbolInfo& symbol_info);
bool IsTypeQualifierValid(const SymbolInfo& symbol_info);
bool IsExpressionValidArraySubscript(const SymbolInfo symbol_info);
bool IsDataTypeValidForIncDec(const SymbolInfo& symbol_info);
bool IsConst(const SymbolInfo& symbol_info);
void IncrementSymbolInfoBy(SymbolInfo* symbol_info, int value);
std::ostream& operator<<(std::ostream &os, SymbolTypes::SymbolType symbol_type);
std::ostream& operator<<(std::ostream &os, SymbolTypes::StorageClassSpecifier storage_class_specifier);
std::ostream& operator<<(std::ostream &os, SymbolTypes::TypeQualifier type_qualifier);

#endif //SYMBOLINFOUTIL_H_