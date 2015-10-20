#include "SymbolInfoUtil.h"

#include <algorithm>
#include <istream>
#include <list>
#include <ostream>
#include <set>

#include "SymbolTable.h"


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

    valid_data_types_initialized = true;
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

    valid_type_qualifiers_initialized = true;
  }

  return (valid_type_qualifiers.find(symbol_info.type_qualifier_list) 
          != valid_type_qualifiers.end());
}


bool IsExpressionValidArraySubscript(const SymbolInfo symbol_info) {
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

    valid_data_types_initialized = true;
  }

  return (valid_data_types.find(symbol_info.type_specifier_list) 
          != valid_data_types.end());
}

bool IsDataTypeValidForIncDec(const SymbolInfo& symbol_info) {
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

    valid_data_types_initialized = true;
  }

  return (valid_data_types.find(symbol_info.type_specifier_list) 
          != valid_data_types.end() || 
          symbol_info.array_sizes.size() > 0);
}

bool IsConst(const SymbolInfo& symbol_info) {
  // Declare set to check if type exists for types.
  static set<list<TypeQualifier>> valid_type_qualifiers;
  static bool valid_type_qualifiers_initialized = false;

  // Initialize the set with valid data types.
  if(!valid_type_qualifiers_initialized) {
    valid_type_qualifiers.insert(list<TypeQualifier>({CONST}));
    valid_type_qualifiers.insert(list<TypeQualifier>({CONST, VOLATILE}));
    valid_type_qualifiers.insert(list<TypeQualifier>({VOLATILE, CONST}));
  }

  return (valid_type_qualifiers.find(symbol_info.type_qualifier_list) 
          != valid_type_qualifiers.end());
}

void IncrementSymbolInfoBy(SymbolInfo* symbol_info, int value) {
  if(!symbol_info->data_is_valid) {
    return;
  }
  // Char data types
  if(symbol_info->type_specifier_list == list<SymbolType>({CHAR})
    || symbol_info->type_specifier_list == list<SymbolType>({SIGNED, CHAR})
    || symbol_info->type_specifier_list == list<SymbolType>({UNSIGNED, CHAR})) {
    symbol_info->data_value.char_val += value;
  // Unsigned int data types
  } else if(symbol_info->type_specifier_list == list<SymbolType>({UNSIGNED, SHORT})
    || symbol_info->type_specifier_list == list<SymbolType>({UNSIGNED, SHORT, INT})
    || symbol_info->type_specifier_list == list<SymbolType>({UNSIGNED})
    || symbol_info->type_specifier_list == list<SymbolType>({UNSIGNED, INT}) 
    || symbol_info->type_specifier_list == list<SymbolType>({UNSIGNED, LONG})
    || symbol_info->type_specifier_list == list<SymbolType>({UNSIGNED, LONG, INT}) 
    || symbol_info->type_specifier_list == list<SymbolType>({UNSIGNED, LONG, LONG})
    || symbol_info->type_specifier_list == list<SymbolType>({UNSIGNED, LONG, LONG, INT})) {
    symbol_info->data_value.unsigned_long_long_val += value;
  // Signed data types
  } else if(symbol_info->type_specifier_list == list<SymbolType>({SHORT})
    || symbol_info->type_specifier_list == list<SymbolType>({SHORT, INT})
    || symbol_info->type_specifier_list == list<SymbolType>({SIGNED, SHORT})
    || symbol_info->type_specifier_list == list<SymbolType>({SIGNED, SHORT, INT})
    || symbol_info->type_specifier_list == list<SymbolType>({INT})
    || symbol_info->type_specifier_list == list<SymbolType>({SIGNED})
    || symbol_info->type_specifier_list == list<SymbolType>({SIGNED, INT})
    || symbol_info->type_specifier_list == list<SymbolType>({LONG})
    || symbol_info->type_specifier_list == list<SymbolType>({LONG, INT})
    || symbol_info->type_specifier_list == list<SymbolType>({SIGNED, LONG})
    || symbol_info->type_specifier_list == list<SymbolType>({SIGNED, LONG, INT})
    || symbol_info->type_specifier_list == list<SymbolType>({LONG, LONG})
    || symbol_info->type_specifier_list == list<SymbolType>({LONG, LONG, INT})
    || symbol_info->type_specifier_list == list<SymbolType>({SIGNED, LONG, LONG})
    || symbol_info->type_specifier_list == list<SymbolType>({SIGNED, LONG, LONG, INT})) { 
    symbol_info->data_value.long_long_val += value;
  // Floating values
  } else if(symbol_info->type_specifier_list == list<SymbolType>({FLOAT})
    || symbol_info->type_specifier_list == list<SymbolType>({DOUBLE})
    || symbol_info->type_specifier_list == list<SymbolType>({LONG, DOUBLE})) {
    symbol_info->data_value.double_val += value;
  }
}

bool IsNumber(const SymbolInfo& symbol_info) {
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

    valid_data_types_initialized = true;
  }
  
  return (valid_data_types.find(symbol_info.type_specifier_list) 
          != valid_data_types.end());
}

bool IsInteger(const SymbolInfo& symbol_info) {
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

    valid_data_types_initialized = true;
  }
  
  return (valid_data_types.find(symbol_info.type_specifier_list) 
          != valid_data_types.end());
}

bool IsFloating(const SymbolInfo& symbol_info) {
  // Declare set to check if type exists for types.
  static set<list<SymbolType>> valid_data_types;
  static bool valid_data_types_initialized = false;

  // Initialize the set with valid data types.
  if(!valid_data_types_initialized) {
    // Floating point data types
    valid_data_types.insert(list<SymbolType>({FLOAT}));
    valid_data_types.insert(list<SymbolType>({DOUBLE}));
    valid_data_types.insert(list<SymbolType>({LONG, DOUBLE}));

    valid_data_types_initialized = true;
  }

  return (valid_data_types.find(symbol_info.type_specifier_list) 
          != valid_data_types.end());
}

int SizeOfNumber(const SymbolInfo& symbol_info) {
  // Declare set to check if type exists for types.
  static map<list<SymbolType>, int> data_types_to_size;
  static bool valid_data_types_initialized = false;

  if(!IsNumber(symbol_info)) {
    return -1;
  }

  // Initialize the set with valid data types.
  if(!valid_data_types_initialized) {
    // Char data types
    data_types_to_size[list<SymbolType>({CHAR})] = 8;
    data_types_to_size[list<SymbolType>({SIGNED, CHAR})] = 8;
    data_types_to_size[list<SymbolType>({UNSIGNED, CHAR})] = 8;
    
    // Short data types
    data_types_to_size[list<SymbolType>({SHORT})] = 16;
    data_types_to_size[list<SymbolType>({SHORT, INT})] = 16;
    data_types_to_size[list<SymbolType>({SIGNED, SHORT})] = 16;
    data_types_to_size[list<SymbolType>({SIGNED, SHORT, INT})] = 16;
    data_types_to_size[list<SymbolType>({UNSIGNED, SHORT})] = 16;
    data_types_to_size[list<SymbolType>({UNSIGNED, SHORT, INT})] = 16;

    // Regular int data types
    data_types_to_size[list<SymbolType>({INT})] = 16;
    data_types_to_size[list<SymbolType>({SIGNED})] = 16;
    data_types_to_size[list<SymbolType>({SIGNED, INT})] = 16;
    data_types_to_size[list<SymbolType>({UNSIGNED})] = 16;
    data_types_to_size[list<SymbolType>({UNSIGNED, INT})] = 16;

    // Long data Types
    data_types_to_size[list<SymbolType>({LONG})] = 32;
    data_types_to_size[list<SymbolType>({LONG, INT})] = 32;
    data_types_to_size[list<SymbolType>({SIGNED, LONG})] = 32;
    data_types_to_size[list<SymbolType>({SIGNED, LONG, INT})] = 32;
    data_types_to_size[list<SymbolType>({UNSIGNED, LONG})] = 32;
    data_types_to_size[list<SymbolType>({UNSIGNED, LONG, INT})] = 32;

    // Long Long data Types
    data_types_to_size[list<SymbolType>({LONG, LONG})] = 64;
    data_types_to_size[list<SymbolType>({LONG, LONG, INT})] = 64;
    data_types_to_size[list<SymbolType>({SIGNED, LONG, LONG})] = 64;
    data_types_to_size[list<SymbolType>({SIGNED, LONG, LONG, INT})] = 64;
    data_types_to_size[list<SymbolType>({UNSIGNED, LONG, LONG})] = 64;
    data_types_to_size[list<SymbolType>({UNSIGNED, LONG, LONG, INT})] = 64;

    // Floating point data types
    data_types_to_size[list<SymbolType>({FLOAT})] = 32;
    data_types_to_size[list<SymbolType>({DOUBLE})] = 64;
    data_types_to_size[list<SymbolType>({LONG, DOUBLE})] = 64;

    valid_data_types_initialized = true;
  }

  return data_types_to_size[symbol_info.type_specifier_list];
}
