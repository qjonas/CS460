#include "SymbolInfoUtil.h"

#include <algorithm>
#include <istream>
#include <list>
#include <ostream>
#include <set>
#include <climits>
#include <cfloat>

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


}

bool IsRelational(const SymbolInfo& symbol_info) {
  return IsDataTypeValidForIncDec(symbol_info);
}
