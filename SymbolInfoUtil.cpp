#include "SymbolInfoUtil.h"

#include <algorithm>
#include <set>
#include <list>

#include "SymbolType.h"

using namespace std;
using namespace SymbolTypes;

bool IsDataTypeValid(const SymbolInfo& symbol_info){
  // Declare set to check if type exists for types.
  static set<list<SymbolType>> valid_data_types;
  static bool valid_data_types_initialized = false;

  // Initialize the set with valid data types.
  if(!valid_data_types_initialized) {
    // Char data types
    valid_data_types.insert(list<SymbolType>({CHAR}));
    valid_data_types.insert(list<SymbolType>({SIGNED, CHAR}));
    valid_data_types.insert(list<SymbolType>({UNSIGNED, CHAR}));
    
    // Short data types
    valid_data_types.insert(list<SymbolType>({SHORT}));
    valid_data_types.insert(list<SymbolType>({SHORT, INT}));
    valid_data_types.insert(list<SymbolType>({SIGNED, SHORT}));
    valid_data_types.insert(list<SymbolType>({SIGNED, SHORT, INT}));
    valid_data_types.insert(list<SymbolType>({UNSIGNED, SHORT}));
    valid_data_types.insert(list<SymbolType>({UNSIGNED, SHORT, INT}));

    // Regular int data types
    valid_data_types.insert(list<SymbolType>({INT}));
    valid_data_types.insert(list<SymbolType>({SIGNED}));
    valid_data_types.insert(list<SymbolType>({SIGNED, INT}));
    valid_data_types.insert(list<SymbolType>({UNSIGNED}));
    valid_data_types.insert(list<SymbolType>({UNSIGNED, INT}));

    // Long data Types
    valid_data_types.insert(list<SymbolType>({LONG}));
    valid_data_types.insert(list<SymbolType>({LONG, INT}));
    valid_data_types.insert(list<SymbolType>({SIGNED, LONG}));
    valid_data_types.insert(list<SymbolType>({SIGNED, LONG, INT}));
    valid_data_types.insert(list<SymbolType>({UNSIGNED, LONG}));
    valid_data_types.insert(list<SymbolType>({UNSIGNED, LONG, INT}));

    // Long Long data Types
    valid_data_types.insert(list<SymbolType>({LONG, LONG}));
    valid_data_types.insert(list<SymbolType>({LONG, LONG, INT}));
    valid_data_types.insert(list<SymbolType>({SIGNED, LONG, LONG}));
    valid_data_types.insert(list<SymbolType>({SIGNED, LONG, LONG, INT}));
    valid_data_types.insert(list<SymbolType>({UNSIGNED, LONG, LONG}));
    valid_data_types.insert(list<SymbolType>({UNSIGNED, LONG, LONG, INT}));

    // Floating point data types
    valid_data_types.insert(list<SymbolType>({FLOAT}));
    valid_data_types.insert(list<SymbolType>({DOUBLE}));
    valid_data_types.insert(list<SymbolType>({LONG, DOUBLE}));

    // Others
    valid_data_types.insert(list<SymbolType>({ENUM}));
    valid_data_types.insert(list<SymbolType>({STRUCT}));
    valid_data_types.insert(list<SymbolType>({UNION}));
  }

  return (valid_data_types.find(symbol_info.type_specifier_list) 
          != valid_data_types.end());
}

bool IsTypeQualifierValid(const SymbolInfo& symbol_info){
    // Declare set to check if type exists for types.
  static set<list<TypeQualifier>> valid_type_qualifiers;
  static bool valid_type_qualifiers_initialized = false;

  // Initialize the set with valid data types.
  if(!valid_type_qualifiers_initialized) {
    valid_type_qualifiers.insert(list<TypeQualifier>({}));
    valid_type_qualifiers.insert(list<TypeQualifier>({CONST}));
    valid_type_qualifiers.insert(list<TypeQualifier>({VOLATILE}));
    valid_type_qualifiers.insert(list<TypeQualifier>({CONST, VOLATILE}));
    valid_type_qualifiers.insert(list<TypeQualifier>({VOLATILE, CONST}));
  }

  return (valid_type_qualifiers.find(symbol_info.type_qualifier_list) 
          != valid_type_qualifiers.end());
}

