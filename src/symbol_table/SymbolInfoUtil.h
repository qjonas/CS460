#ifndef SYMBOLINFOUTIL_H_
#define SYMBOLINFOUTIL_H_

#include "SymbolTable.h"

int ArrayAccessSizeOf(const SymbolInfo& symbol_info);
bool IsDataTypeValid(const SymbolInfo& symbol_info);
bool IsTypeQualifierValid(const SymbolInfo& symbol_info);
bool IsExpressionValidArraySubscript(const SymbolInfo symbol_info);
bool IsDataTypeValidForIncDec(const SymbolInfo& symbol_info);
bool IsConst(const SymbolInfo& symbol_info);
void IncrementSymbolInfoBy(SymbolInfo* symbol_info, int value);
bool IsPointer(const SymbolInfo& symbol_info);
bool IsNumber(const SymbolInfo& symbol_info);
bool IsInteger(const SymbolInfo& symbol_info);
bool IsFloating(const SymbolInfo& symbol_info);
int SizeOfNumber(const SymbolInfo& symbol_info);
bool IsUnsigned(const SymbolInfo& symbol_info);
bool checkOverflow(const SymbolInfo& symbol_info);
bool IsRelational(const SymbolInfo& symbol_info);
long double maxValue(const SymbolInfo& symbol_info);
long double minValue(const SymbolInfo& symbol_info);
bool multOverflow(const SymbolInfo& symbol_info_LH, const SymbolInfo& symbol_info_RH);
bool addOverflow(const SymbolInfo& symbol_info_LH, const SymbolInfo& symbol_info_RH);
bool subOverflow(const SymbolInfo& symbol_info_LH, const SymbolInfo& symbol_info_RH);
bool CompareParamToArgument(const FunctionParameter& function_param, const SymbolInfo& symbol_info);
void Harris();
bool IsFunction(const SymbolInfo& symbol_info);
#endif //SYMBOLINFOUTIL_H_
