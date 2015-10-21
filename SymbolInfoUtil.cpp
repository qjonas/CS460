#include "SymbolInfoUtil.h"

#include <algorithm>
#include <istream>
#include <iostream>
#include <list>
#include <ostream>
#include <set>
#include <climits>
#include <cfloat>

#include "SymbolTable.h"
#include "Escape_Sequences_Colors.h"

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

  // Check Pointer
  if(symbol_info.array_sizes.size() > 0) {
    return false;
  }

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

  // Check Pointer
  if(symbol_info.array_sizes.size() > 0) {
    return false;
  }

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

  // Check Pointer
  if(symbol_info.array_sizes.size() > 0) {
    return false;
  }
  
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

bool IsUnsigned(const SymbolInfo& symbol_info) {
  // Declare set to check if type exists for types.
  static set<list<SymbolType>> valid_data_types;
  static bool valid_data_types_initialized = false;

  // Initialize the set with valid data types.
  if(!valid_data_types_initialized) {
    // Char data types
    valid_data_types.insert(list<SymbolType>({UNSIGNED, CHAR}));
    
    // Short data types
    valid_data_types.insert(list<SymbolType>({UNSIGNED, SHORT}));
    valid_data_types.insert(list<SymbolType>({UNSIGNED, SHORT, INT}));

    // Regular int data types
    valid_data_types.insert(list<SymbolType>({UNSIGNED}));
    valid_data_types.insert(list<SymbolType>({UNSIGNED, INT}));

    // Long data Types
    valid_data_types.insert(list<SymbolType>({UNSIGNED, LONG}));
    valid_data_types.insert(list<SymbolType>({UNSIGNED, LONG, INT}));

    // Long Long data Types
    valid_data_types.insert(list<SymbolType>({UNSIGNED, LONG, LONG}));
    valid_data_types.insert(list<SymbolType>({UNSIGNED, LONG, LONG, INT}));

    valid_data_types_initialized = true;
  }

  return (valid_data_types.find(symbol_info.type_specifier_list) 
          != valid_data_types.end());
}

long double maxValue(const SymbolInfo& symbol_info){
	// Declare set to check if type exists for types.
  static map<list<SymbolType>, long double> max_value;
  static bool max_value_initialized = false;

  // Initialize the set with valid data types.
  if(!max_value_initialized) {
    // Char data types
    max_value[list<SymbolType>({CHAR})] = SCHAR_MAX;
    max_value[list<SymbolType>({SIGNED, CHAR})] = SCHAR_MAX;
    max_value[list<SymbolType>({UNSIGNED, CHAR})] = UCHAR_MAX;
    
    // Short data types
    max_value[list<SymbolType>({SHORT})] = SHRT_MAX;
    max_value[list<SymbolType>({SHORT, INT})] = SHRT_MAX;
    max_value[list<SymbolType>({SIGNED, SHORT})] = SHRT_MAX;
    max_value[list<SymbolType>({SIGNED, SHORT, INT})] = SHRT_MAX;
    max_value[list<SymbolType>({UNSIGNED, SHORT})] = USHRT_MAX;
    max_value[list<SymbolType>({UNSIGNED, SHORT, INT})] = USHRT_MAX;

    // Regular int data types
    max_value[list<SymbolType>({INT})] = INT_MAX;
    max_value[list<SymbolType>({SIGNED})] = INT_MAX;
    max_value[list<SymbolType>({SIGNED, INT})] = INT_MAX;
    max_value[list<SymbolType>({UNSIGNED})] = UINT_MAX;
    max_value[list<SymbolType>({UNSIGNED, INT})] = UINT_MAX;

    // Long data Types
    max_value[list<SymbolType>({LONG})] = LONG_MAX;
    max_value[list<SymbolType>({LONG, INT})] = LONG_MAX;
    max_value[list<SymbolType>({SIGNED, LONG})] = LONG_MAX;
    max_value[list<SymbolType>({SIGNED, LONG, INT})] = LONG_MAX;
    max_value[list<SymbolType>({UNSIGNED, LONG})] = ULONG_MAX;
    max_value[list<SymbolType>({UNSIGNED, LONG, INT})] = ULONG_MAX;

    // Long Long data Types
    max_value[list<SymbolType>({LONG, LONG})] = LLONG_MAX;
    max_value[list<SymbolType>({LONG, LONG, INT})] = LLONG_MAX;
    max_value[list<SymbolType>({SIGNED, LONG, LONG})] = LLONG_MAX;
    max_value[list<SymbolType>({SIGNED, LONG, LONG, INT})] = LLONG_MAX;
    max_value[list<SymbolType>({UNSIGNED, LONG, LONG})] = ULLONG_MAX;
    max_value[list<SymbolType>({UNSIGNED, LONG, LONG, INT})] = ULLONG_MAX;

    // Floating point data types
    max_value[list<SymbolType>({FLOAT})] = FLT_MAX;
    max_value[list<SymbolType>({DOUBLE})] = DBL_MAX;
    max_value[list<SymbolType>({LONG, DOUBLE})] = LDBL_MAX;

    max_value_initialized = true;
  }

  return max_value[symbol_info.type_specifier_list];
}

long double minValue(const SymbolInfo& symbol_info){
	// Declare set to check if type exists for types.
  static map<list<SymbolType>, long double> min_value;
  static bool min_value_initialized = false;

  // Initialize the set with valid data types.
  if(!min_value_initialized) {
    // Char data types
    min_value[list<SymbolType>({CHAR})] = SCHAR_MIN;
    min_value[list<SymbolType>({SIGNED, CHAR})] = SCHAR_MIN;
    min_value[list<SymbolType>({UNSIGNED, CHAR})] = 0;
    
    // Short data types
    min_value[list<SymbolType>({SHORT})] = SHRT_MIN;
    min_value[list<SymbolType>({SHORT, INT})] = SHRT_MIN;
    min_value[list<SymbolType>({SIGNED, SHORT})] = SHRT_MIN;
    min_value[list<SymbolType>({SIGNED, SHORT, INT})] = SHRT_MIN;
    min_value[list<SymbolType>({UNSIGNED, SHORT})] = 0;
    min_value[list<SymbolType>({UNSIGNED, SHORT, INT})] = 0;

    // Regular int data types
    min_value[list<SymbolType>({INT})] = INT_MIN;
    min_value[list<SymbolType>({SIGNED})] = INT_MIN;
    min_value[list<SymbolType>({SIGNED, INT})] = INT_MIN;
    min_value[list<SymbolType>({UNSIGNED})] = 0;
    min_value[list<SymbolType>({UNSIGNED, INT})] = 0;

    // Long data Types
    min_value[list<SymbolType>({LONG})] = LONG_MIN;
    min_value[list<SymbolType>({LONG, INT})] = LONG_MIN;
    min_value[list<SymbolType>({SIGNED, LONG})] = LONG_MIN;
    min_value[list<SymbolType>({SIGNED, LONG, INT})] = LONG_MIN;
    min_value[list<SymbolType>({UNSIGNED, LONG})] = 0;
    min_value[list<SymbolType>({UNSIGNED, LONG, INT})] = 0;

    // Long Long data Types
    min_value[list<SymbolType>({LONG, LONG})] = LLONG_MIN;
    min_value[list<SymbolType>({LONG, LONG, INT})] = LLONG_MIN;
    min_value[list<SymbolType>({SIGNED, LONG, LONG})] = LLONG_MIN;
    min_value[list<SymbolType>({SIGNED, LONG, LONG, INT})] = LLONG_MIN;
    min_value[list<SymbolType>({UNSIGNED, LONG, LONG})] = 0;
    min_value[list<SymbolType>({UNSIGNED, LONG, LONG, INT})] = 0;

    // Floating point data types
    min_value[list<SymbolType>({FLOAT})] = FLT_MIN;
    min_value[list<SymbolType>({DOUBLE})] = DBL_MIN;
    min_value[list<SymbolType>({LONG, DOUBLE})] = LDBL_MIN;

    min_value_initialized = true;
  }

  return min_value[symbol_info.type_specifier_list];
}

bool multOverflow(const SymbolInfo& symbol_info_LH, const SymbolInfo& symbol_info_RH){

return true;
}
bool addOverflow(const SymbolInfo& symbol_info_LH, const SymbolInfo& symbol_info_RH){
//check if int
if(IsInteger(symbol_info_LH)){
	//check if unsigned
	if(IsUnsigned(symbol_info_LH)){
	unsigned long long max = maxValue(symbol_info_LH);
	unsigned long long val_LH = symbol_info_LH.data_value.unsigned_long_long_val;
	unsigned long long val_RH = symbol_info_RH.data_value.unsigned_long_long_val;
  return((max - val_LH) < val_RH);
	}
	//check else signed
	else{
	long long max = maxValue(symbol_info_LH);
	long long val_LH = symbol_info_LH.data_value.long_long_val;
	long long val_RH = symbol_info_RH.data_value.long_long_val;
  return((max - val_LH) < val_RH);
	}
}

if(IsFloating(symbol_info_LH)){
  long double max = maxValue(symbol_info_LH);
  long double val_LH = symbol_info_LH.data_value.double_val;
  long double val_RH = symbol_info_RH.data_value.double_val;
  return((max - val_LH) < val_RH);
  }
//error
else{
 

  }

return true;
}

bool subOverflow(const SymbolInfo& symbol_info_LH, const SymbolInfo& symbol_info_RH){
//check if int
if(IsInteger(symbol_info_LH)){
	//check if unsigned
	if(IsUnsigned(symbol_info_LH)){
	unsigned long long min = minValue(symbol_info_LH);
	unsigned long long val_LH = symbol_info_LH.data_value.unsigned_long_long_val;
	unsigned long long val_RH = symbol_info_RH.data_value.unsigned_long_long_val;
  return((min + val_LH) > val_RH);
	}
	//check else signed
	else{
	long long min = minValue(symbol_info_LH);
	long long val_LH = symbol_info_LH.data_value.long_long_val;
	long long val_RH = symbol_info_RH.data_value.long_long_val;
  return((min + val_LH) > val_RH);
	}
}

if(IsFloating(symbol_info_LH)){
  long double min = minValue(symbol_info_LH);
  long double val_LH = symbol_info_LH.data_value.double_val;
  long double val_RH = symbol_info_RH.data_value.double_val;
  return((min + val_LH) > val_RH);
  }
//error
else{
 
  }

return true;
}

bool IsRelational(const SymbolInfo& symbol_info) {
  return IsDataTypeValidForIncDec(symbol_info);
}

bool CompareTypeSpecifierList(const list<SymbolTypes::SymbolType> list_one,
                              const list<SymbolTypes::SymbolType> list_two) {
  SymbolInfo temp_one, temp_two;
  temp_one.type_specifier_list = list_one;
  temp_two.type_specifier_list = list_two;

  return ((IsNumber(temp_one) && IsNumber(temp_two))) || (list_one == list_two);
}

bool CompareParamToArgument(const FunctionParameter& function_param, const SymbolInfo& symbol_info) {
  if(function_param.array_sizes.size() > 0 && 
     symbol_info.array_sizes.size() > 0) {
    return true;
  } else if (function_param.array_sizes.size() > 0 ||
     symbol_info.array_sizes.size() > 0) {
    return false;
  } else {
    return CompareTypeSpecifierList(function_param.type_specifier_list, 
                                  symbol_info.type_specifier_list);
  }
}

void Harris() {
  cout  << COLOR_RED_NORMAL <<
"DDDNNMMMMNDD8OOOOO888DDNNNNNDD8DDDDNNNNNNNDDDDD8DDDDDD88O88O888D8OD8DDDDD8DDDDDNNNNDDDDNNDDD88888DDDNNMMNNMMMMMMMMMMMMMM" << endl <<
"DDDDNNNNMNND8OOOO8OOOOO8DNNNND888DDDNNNNNNNDDDDDDD8D8DDD8888888O8888DDNDDDDDDDDDDNNDDDDNDNDDD888888888DNNNNNNNMMMMMMMMMM" << endl <<
"DDDNNNNNNNND8888888OOOOOODDNND8DDD8DNNNNNNDDDDD8888D8DDDDDO8D88OOOOOZZZO88888DDDDDDNNNNNNNDD88888OOOOOO8DNNNNNNNMMMMMMMM" << endl <<
"NNDDNNNNNNNDDD88888888OOO88DDDDDDDNNNNNDND8OOOOOOOO888888OOD8888OOOO8ZO8O88888DDDNDDNNNNNNNDD8888OOOOOO88NNNNNMMMMMMMMMM" << endl <<
"DDDDDDNNNMNNNDDDDDND88OOO8888DDNNNNDDDD8O$$$$Z$$$ZZOZZZZZZZOOOZZO8OOOZOOOOOOOO8OODNNNNNNNMNDDD888OOOZZOO8DNNMMMMMMMMMMMM" << endl <<
"DDDDDDNNMMMMNNNNNNNND88O88888DDDDDDDD8$7777$77III7$$777$$$$$$$ZZZOOOOZOOOOOOOO88D88DNNNNMMNNDD8888OZZZO88NNMMMMMMMMMMMMM" << endl <<
"DDDDDDNNNMMMMMMMNNNNNDDD8888DDNDDN8O$77III???7?I?I?I?III77I77777$$$ZZZZOOOOO$8O888DDDNMMMMNNNDNNDD88OOO8DNMMMMMMMMMMNNNN" << endl <<
"DDDDDNNNNMMMMMMMNNNDDDNNDDDDDDD88877777II???????++++?????IIII77777$$$ZZZZZOOOZOZO888DDDNMMMMNNNDDNDO8OO8DMMMMMMMMMMNNNNN" << endl <<
"DNNNNNNNNNMMMMMNNNNNNDNNDDDNNND8$7777II????+?+?+++++??+???IIII7777$$$$ZZZZZZZ$ZZOO888DNNNNMMNMNDNDD88O88DNMMMMMMMMNNNNNN" << endl <<
"NNNNNNNNNNMNNMMMNNNNNNNNDDNDDD$77IIIIII????++++++++++???I?IIIII77$7777$$ZZZZZZZZOOOO8DDDNNMMMMMNDDD88888DDMMMMMMMMNNNNNN" << endl <<
"DNNNMMNNNNNNNNMMMNNNNDD8DNDD8IIIIIII??????++?+++++??+??????IIIII77777$$$ZZZZZZZZZOOO8DDDDDNMMMMMNNNDD8D8DNNMMMMMMMMNNNNN" << endl <<
"DNNNMMNNNNNNNNNNNMMND8DDDD8ZIIIII?????+++++++++++++?+++????I?IIII777777$$ZZZZOOZOO8O8DDDDDDNNMMMMMNDDDDDDDNNMMMMMMMMMMNN" << endl <<
"DNNNNNNNNNDDDDNNNNN88888D87II?????+++++?++++++++++++?+?????I?III7I7777$$$ZZZZOZOO888DDDDDDDNNNMMMMMMNNDNNNNNMMMMMMMMMMMM" << endl <<
"DDDDNNNDDDDDDDDNNNDZ88DD87I?????+++++++++++++++++++++?+?+?????IIIII7777$$$ZZZOOO8O88DDDDDDDDDNNMMMMMDNNNNNMMMMMMMMMMMMMM" << endl <<
"888DDDDDDD88DDDDNDO88D88IIIII???++++++++++++++++++++++++???????IIIIII77$$Z$ZZZOOOO88DDDDDDDDDDNNMMMMMDNMNMMMMMMMMMMMMMMM" << endl <<
"888888DDDDDDDDDDD8O88D8II????++++++++++=++==+==++++++++++??+?I??IIII7I77$Z$ZZZOOOO88DDDDDDDDDDNNMMMMMMNMMNMMMMMMMMNMMNMM" << endl <<
"88888DDDDDDDDDDDOO88DDII????++++++++====+=+=++==++=++++++++???II??I777I7$$ZZZZOOOOOO8DDDDDDDDDDNMMMMMMNNMNNMNNNNNMNMMMMM" << endl <<
"8888DDDNNDDDDDNDZZ8NDZI?????+++++=================+++++++++???????IIIII77$$$ZZZOOOOO88DDDDDDDDDDNMMNMNNNNMMMMMNNMMMMMMMM" << endl <<
"888888DDDDDNNNNZZ88D8??+????+++++========~============+=+=++++?+???II77777$$ZZZOOOOO88DDDDDDDDDDNMMMNMMNMNMMMNNNMMMMMMNN" << endl <<
"OOOOOOO88DDDNN8Z888Z7?++++++?++======~~~~~::~~~~~=====+====++++?????II7777$$$$ZZOOOO88DDDDDDDDDDNMMMNNDMMMMMMMNMMMMMNNNN" << endl <<
"ZZZZZZZOO888DDOOOO8Z??++++++++======~~~~~~~~~~~~~===========++++????II77777$$$ZZZOZO888DDDDDDDDDDNMMMNMMMMMMMMMMMMMMNNND" << endl <<
"$$$$$ZZZOOOO8OOOOO8I?+++++++=+=======~~~~~~~~~~~~=====+======++++???III7777$$$$ZZZZO88DDDDDDDDDDDNMMMMNMNMMMMMMMMMNNNNND" << endl <<
"$$$ZZZZZZOOOO8O$O8Z??+++++++++====~~~~~~~~~~~~~=~=~==========+=+++???II77777$$$ZZZZOO8DDDDDDDDDDDNNMMMMMMMMMMMMMMMNNNNNN" << endl <<
"$$ZZZOOOOOOOOOOZOO$??++++++======~~~~~~~~:~~~~:~~==~========+++++???IIII777777$$ZZZOO88DDDDDDDDDDNMMMMMMMMMMNNNNNNNNNNNN" << endl <<
"$ZZZZOOOOOZZZ8OOOO7??++++++=====~~~~~~~~~~~~~~~~~~~====~======+=++???III777777$$ZZZZ8888DDDDDDDDDNNMMMMMMMMMNDNNNNNNNNDD" << endl <<
"ZZZZOOOOZZZZZ888OO??++++++========~~~~~~~~~=~~=~~~=========+++++++??III77777$7$$ZZZOO88DDDDDDDDDDNNMMMMMMMMMNDDDNNNNNDDD" << endl <<
"OOOOOOOOZZOZOD88Z$I?+++++===========~~~~~~~~=~~==========++=++++++???I777777$$$ZZZZZ888888DDDDDDDDNMMMMMMMMND8DDDNNNNDNN" << endl <<
"OOO888OOOOOO8D8OZ$I?++++===========~~~~~~~~~~~~~~~==========++++++???II77777$$ZZZZOO888888DD8DDDDDNNMMMMMMMMD88DNNNNNNNN" << endl <<
"88D8DD88OOOO88OZZ$??++++==========~~~~~~~~~~~~==~==~=~===~===+=+?????II77777$$ZZZZZO88888888D8DDDDNNMMMMMMMMD88DNNNNNNNN" << endl <<
"DDDDDDD888888DZZ$7I+++++==========~~~~~~~=~~~======~=~~==~====+++????IIII777$$$ZZZOOO88888888DDDDDNNMMMMMMMMN88DNNNNNNNN" << endl <<
"DDDDDD8OO888DDOZ$$?+++====+======~~~~~~:~~~~~~~======~==~=====++++?????I7777$$ZZZOOO88888888888DDDNNMMMMMMMMNDDNNNNNNNNN" << endl <<
"DDDDZ7777$Z8DN8OZ7?+++=+=======~~=~~~~::~~~~~~~====~~==~=~=====++++???II777$$$ZZZZOO8D888888D888DDDNNMNMMMMMMDDNNNNNNNNN" << endl <<
"DDDO7IIIII7ZDD8O$?++++=+===+===~==~=~~~~~~~~~~~~====~~=======+=++????III77$7$$$$ZZO888888D88D888DDDNNMMMMMMMMDDDDDDDDDDD" << endl <<
"DDDZ7IIIIIIZND8O$I++++++==+=========~~~~~~~~~=~~===~~~==~==+++++???+?III777$$$$$$ZO8888888888888DDDNNNMMMMMMMDDDDDDDDDDD" << endl <<
"DDDO7IIIII7ZDD8O$?+++++=+==+==========~~~~=~===~~~========++++++++??III777$$$ZZZO88888DD888888D88DDNNMMMMMMMMO8DDDDDDDDD" << endl <<
"DDDDZ77II7ZODD8O7?++++++==++????II??++++=============+++==+++++??II7$ZOOO8888888DDDDDDD8888D88D8DDDDNMMMMMMMN8O888DDDDDN" << endl <<
"DDD8OOZZ$ZZO8D8O7?++==++=++?7III7$$$Z$777II++======++++?=+++??I77$ZZ888D8DD8OO888888DDD8D888888DDDDNNMMMMMMMMNNDDD8DDDDD" << endl <<
"DDD8OOOOZ$7$8DN87?+++===+?III??III77$$Z$$77+?++=++=+==+?==+??77$ZZ888D88OOZZOOO8DDDDDDDDDD8D88D8DDDDNMMMMMMMNDNNDDDDDDDD" << endl <<
"88D8OOOZ7++??NZ87?++===++?II??++====++?IIIIII??+++===++?++??77ZOO88OO$7IIIII7$ZO8DDDDDDDD8DD88DDDDDNMMMMMMNNNNNMMNDDDDDD" << endl <<
"8888OOOO?7ZI8+IO7?++===+?II++???+???+++?IIIII?+?++===+??+?I7Z88888OOZZOZZOOOO8888888DDDDDDDD8DDDDDNMNDNNNDDNNNNNNMDDDDDD" << endl <<
"888888OO?7ZIN+777I++=++?II?+=++++III7$ZZZZO887?++=~~~=??II7Z?7O888DOZII7$OZO88DD8OO888DDD8D888DDNNDDDDDDNNNNDDNNNNNDDDDD" << endl <<
"OOOOOOOO+I7+ODI7I?$7++=++?++?IZI?Z8D$DND8ZZOO$OI+==~~=+?I7OZ88DDNDOO8Z87NM8DDNNNNND888ZD88888DNM8DDDDDDDNDDDDDNNNNN888DD" << endl <<
"OOOOOOOO+II+?DZ7+?I?I+=====?ZOO8Z7IOZDNZZOOOZ7?D77III7$$ZOOO8DDDDDDZ++ZZ$ZZ88ZODDDDDDDD$8O8D8D8DD8DDDDDNNDDDDDDNNND888DD" << endl <<
"OOOOOOOO+?7++7NN88I+??+=+++?II???+?IIZZ$7II$$7+8++7I??7$Z88ODD8D8O7?+++?II7$ZZOOODDDD8OZ$8OOO888DDDDDDNDDDDDDDDNNND8DDDD" << endl <<
"OOOOOOOO?=7+==+I+O?++?I?++??+?+++++??II77777?=+DOI=~~==?ZD888DD8Z7?I?I?I777777$O88OOOOOZ$ZZZO8DDDD8DDDNNMNNNDDDNNDD88DDD" << endl <<
"88888888Z+?+==+?+??++++++++==+??????II77$7II+=+D87=~~~=?ZDDO88DD8ZZ$$$77$$7$ZZZO8O$$$ZZO7OZZO88DDDDDDDNNMMNNNDDNDD8OOO88" << endl <<
"888888888I=+==++++++++=+++++++??I777IIIIII?++=78D==~~++?78N8D88D8OZZ7$7$$ZZZZZ$$7II7$$$Z$ZOZ88DDDDDDDDNNNNNNNDDNDZ$$$$ZZ" << endl <<
"888888888O+===++++?+++====+???????+??+?+?I?=++D?7~~===++IO8D888888OZ$777II7IIII?III77$$ZZZO8888DDDDDDDNDDNMNNDDDZ7II7777" << endl <<
"DDDDD88888O===++++?++++==~~====++++++=+++====?+?=======+7Z88Z888OOZ$$II7I??I????II7777$$ZOO888DDDDDDDDNNNNMMNDD8I??????I" << endl <<
"DDDD8888888$==+??++++++============++======+++I=======+?7Z88OZ8OZZ$7III?I?I??III?I77$$Z$ZO888DDDDDDDDDDNNMMNDDDI??++++?I" << endl <<
"OOOOOOO88OO8+=+I+++++++=+======~===========++?=======+?I7O88OOZOZ$$II?????+?????I77$$$IO8888DDDDDDDDDDNNMNNDDDZII?????II" << endl <<
"77777777$$$$7=~++++=+?++===~==~=====~=~====+?+=======??I$ZO888OZZ$$7III?++++?????77$I$O88D8DDDDDDDDDDDDNDDDDDD777III7777" << endl <<
"?????????????+==?+++++++==+++=~~====+===+++++========?I7$ZO88888OZ$777777IIII777I7$$ZOO888DDDDDD8DDDD8DNDD8DDOZZZZZZZZOO" << endl <<
"=========+++++==?++++++===~======+==++++++++==+======+?77$8888D88OZ7IIII??++?I?I77$$ZO888DDDDDDDDDDDDDDDDD8DD88888O8O8OO" << endl <<
"~~~~~~==~====+==+?+++++===~====++++++??I??+++=====~~~=?I7$OO8888DD8$7I??+?++++?II7$ZZOO88DDDDDDDDDDDDDDDDD8D8$$$$$$$ZZZZ" << endl <<
"~~~~~~~~~~~~~~+=++++++++====~~=+=++??II7I?+======~::=++II7Z8888O88D8Z7I??+++=+?I?I7$ZOO88DDDDDDDDDDDDDDDD8DD7???II?IIIII" << endl <<
"~~~~~~~~~~~~~~+=+++++++=========++?I77Z$?+======~~::~=+?I7Z8888OO8DNDZ7I???+++??I77$ZOO88DDDDDDDDDDDDDDDD8D8++++++++++++" << endl <<
"====~~~~~~~~~~+==?+=+++++====+=++?I7ZOI+=+?++===~::===+?7$88888888DNDDO$I???????II7$ZO88DDDDDDDDDDDDDDDDDD87============" << endl <<
"+++===========++=++++++===+++++?II$ZO?=====+$$?+===++?I7Z8DDDDNNDDDNDD8OZ7I???III7$$ZODDDDDDDDDDDDDDDDDD88D=~~~~~~~~~~~~" << endl <<
"?????????+++++++=+++++++++++++?II$ZOI====~===+++??+?II$Z8DDNNNNNDDDDDD88O$7IIIIII$$ZO8DDDDDDDDDDDD8DDD8DDD7~~~~~~~~~~~~~" << endl <<
"$77777777IIIII???++++++++++++??7$ZO7?+++=+=++===+?77$ZO8DNNNDDDDDDDDDD88OOZ7III77$ZOO8DDDDD8DDDDDDDDDD8$=~~~~~~~~~~~~~~~" << endl <<
"OOOOOOOZZZZZ$$$77++++++?++++??7$Z87I??+++++=+++==+?I7ZO88DDDNDDDDDDDD8888OO$7II77$ZO888DD8888DDDDDDDD88$~~~~~~~~~~~~~~~~" << endl <<
"DDDD88888888OOOOZ+++++++++++?I$88$I++++=+?+++++++??I77II7ZO8888DDD88D88D888O$7II77ZZO88D88OO8DD88D888D8O~~~~~~~~~~~~~~~~" << endl <<
"DDDDDDDDDDDDD888O++++++++++??7O87????I??+++=+++++??II????I7$OOO8888888D8888OZ$IIII7$ZOOOZOOO88DDD8DDDD8O~~~~~~~~~~~~~~~~" << endl <<
"DDDDDDDDDDDDDDDDD?++++++++++I7O$+?IIII??+?+++===+++??++=+??I$$ZO88888888888ZZ$I??I7$ZOZZZZZO8DDDD88DDD88~~~~~~~~~~~~~~~~" << endl <<
"DDDDDDDDDDDDDDDDD$+++++++=++?I$$I7$ZZI???++=+=+===++++++++?II7$ZZOO8888D8DD8$I???II$$ZZZ$$OO88DDDDDDD888~~~~~~~~~~~~~~~~" << endl <<
"DDDDDDDDDDDDDDDDD8?++++++++++?I$7Z$IZ$ZO7I7777III???+++++?III77$ZZO88DD8DNMDI????I77$ZZZ$ZZO88DDDDDDD888===========~~~~~" << endl <<
"DDDDDDDDDDDDDDDDDD?++++++++++??I77I+?=+?I$88$7$$Z$$777$$$$ZZOO888DDDDMMMNNN8?+++??77$$ZZ$ZO88DDDDDDDDD88????++++++======" << endl <<
"DDDDDDDDDDDDDDDDD8Z?++++++++++?II7I++===+?I$NZ+I++?III7I$$ZOO88888MMMMNNDDDZ??++?II7$$ZZZZOO8DDDDDDDDD8877777IIII????+++" << endl <<
"DDDDDDDDDDDDD888888I?++++++++++??II+=====++??7DO$=I===+=+?7ZZ8NNMMNDD8888OOI+=++?I77$ZZZOOO88DDDDDDDDD8OZZZZZZ$$$7777III" << endl <<
"DDDDDDDDDDDDDDDDDD8O???+++++++++???+=======++??IZ$77$Z$?+$ODNN8Z$$ZZZZO8Z$7++==+?II$$ZZZOOO88DDDDDDDDD8OOOOOOOOOOZZZZ$$$" << endl <<
"DDDDDDDDDDDDDDDDDDDD7???++++++++??++====~==+++++??I77?IO$IIIII77$$$$Z88Z7I??+=++?I7$ZZZOOO88DDDDDDDDD88O88888888OOOOZZZ$" << endl <<
"NDDDDDDDDDDDDDDDDDDDD?+?++++++++++++=====~======~==+?+?++??III7$$$$O88ZI?????++?I7$ZZZZOO88DDDDDDDDDDD8NM8OOOOZZZZZ$$$77" << endl <<
"NNDDDDDDNDDDDDDDDDDDDO????+??++++++=====~====++====++=+++??II7$$ZO888ZI??III?++I7$OZOOOOO88DDDDDDDDDD8OOMMD$$$$77777III?" << endl <<
"NNNDDDDNNNDDDNDNDDNDDD7????+++++++==+===~===+++++++????IIII777$O8DD8$7???II7I??7$OOOOOOOO8DDDDDDDDDDD8OODMMM$7777IIIIII?" << endl <<
"NNNNNNNNNDDDDDDNDDDDDDDI????+++++++=======~===+?IIII7II777$$OO8888O$7I???7777I7$OOOOZZZOO8DDDDDDDDDDDOOZ8MMMD$777777IIII" << endl <<
"NNNNNNNNNDDDDDNDDDDDDDDDI????++++++==========+++??III$7$$$$ZOZZZZ$$II??I?7$$$$ZO88OZZZZZ8DDDDDDDDDDD8OZZ8MMMM8$$$$$$$777" << endl <<
"NNNNNNNNNNNNNDDDDDDDDDDD8I????+++++==+==========++????III777777$77I??I??I$ZOZ8888OO$$ZZO8DDDDDDDDDDDOOOODMMMMMN88888O888" << endl <<
"NNNNNNNNNNNNNNDDNDNDDDDDDO???????+++==~===~~=====+???+????II77IIII??++?I7$O88DDD8OZ$$ZO8DDDDDDDDDDD8OOOOMMMMMMMM88888888" << endl <<
"NNNNNNNNNNNNNNNNNNNDDDNNNNZ???+????++==========~=======?+?????I???++???I$O88DDD88ZZ$ZZO8DDDDDDDDDDDOOOO8MMMMMMMMMDOOOOOO" << endl <<
"NNNNNNNNNNNNNNNNNNNNNNNNNND7?I??????+======~~~~=~==~+==++??IIII??????II7Z8DDDDD8OZZZZO8DDDDDDDDDDD8OOOONMMMMMMMMMMNOOOOO" << endl <<
"NNNNNNNNNNNNNNNNNNNNNNNNNNNDII???????++===~==~====~~====+++IIIII?+?II77ZODDDDDD88OZZZ8DDDDDDDDDDD8OOZO8MMMMMMMMMMMMNOOOO" << endl <<
"NNNNNNNNNNNNDNDDNNNNNNNNNNNDNI????????+======~==~~==+++=++??IIIII?I7$ZZO8DDDNDD88OZO88DDDDDDDDDD8OOOOOMMMMMMMMMMMMMMM8OO" << endl <<
"NNNNNNNNNNNNNDDDNNNNNNNNNNDDDDI??I?????++==========+++++++?III77777ZZOO88DDDDDD88OO8O88DDDDDDDD8OOOO8NMMMMMMMMMMMMMMMMN8" << endl <<
"NNNNNNNNNNNNNNDDNNNNNNNNNNNDDN8I??+?+??I?+++====+=++++??+???7$$$$$ZO8888DDDDDDD88OOOO8DDDDDDDDOOOOOODMMMMMMMMMMMMMMMMMMM" << endl <<
"NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNI????+???II??++?++?++?????I77$$ZZOOO8D8DDDDDDD888O8OO8DDDDDDDDOOOOOO8MMMMMMMMMMMMMMMMMMMM" << endl <<
"NNNNNNNNNNNNNNNNNNNNNNNNNNNNNND~?????????IIII?????IIIIII77$$$ZOO88888DDDDDDD88OOOOO8DDDDDDD8OOOOOOOMMMMMMMMMMMMMMMMMMMMM" << endl <<
"NNNNNNNNNNNNNNNNNNNNNNNNNNNNNND~:?I??+?????II777777$$$$$ZZZZOO88888DDDDDD8DD8OOOO88DDDDDDDOOOOOOOO8MMMMMMMMMMMMMMMMMMMMM" << endl <<
"NNNNNNNNNNNNNNNNNNNNNNNNNNNNNND~:~????????+??I?I$ZOOOOOOOOOO8888DDDD88888888OOOO88DDDDD88OOOOOOOO8MMMMMMMMMMMMMMMMMMMMMM" << endl <<
"NNNNNNNNNNNNNNNNNNNNNNNNNNNNNND~::~??????????????III7$ZZZZZZOOOOOOO888OOOOOOOOO88DDDD88OOOOOOZOOOMMMMMMMMMMMMMMMMMMMMMMM" << endl <<
"NNNNNNNNNNNNNNNNNNNNNNNNNNNNNN8:::::+++????????????I7III77$$$ZZZZZZOOOOOZZOOOO8888888OOOOOOZZOOONMMMMMMMMMMMMMMMMMMMMMMM" << endl <<
"NNNNNNNNNNNNNNNNNNNNNNNNNNNNND$::::::++++??????+???IIIIII77$$$$$ZZZ$ZZ$ZZZOOO888888OOOOOZZZZZOODMMMMMMMMMMMMMMMMMMMMMMMM" << endl
<< COLOR_NORMAL;
}
