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
  }

  return (valid_data_types.find(symbol_info.type_specifier_list) 
          != valid_data_types.end());
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

ostream& operator <<(ostream &os, SymbolType symbol_type) {
  switch (symbol_type) {
    case STRUCT:
      os << "STRUCT"; break;
    case UNION:
      os << "UNION"; break;
    case ENUM:
      os << "ENUM"; break;
    case TYPEDEF_NAME:
      os << "TYPEDEF_NAME"; break;
    case SIGNED:
      os << "SIGNED"; break;
    case UNSIGNED:
      os << "UNSIGNED"; break;
    case SHORT:
      os << "SHORT"; break;
    case LONG:
      os << "LONG"; break;
    case CHAR:
      os << "CHAR"; break;
    case INT:
      os << "INT"; break;
    case FLOAT:
      os << "FLOAT"; break;
    case DOUBLE:
      os << "DOUBLE"; break;
    case STRING:
      os << "STRING"; break;
  }
  return os;
}

ostream& operator<<(ostream &os, SymbolTypes::StorageClassSpecifier storage_class_specifier) {
  switch (storage_class_specifier) {
    case NONE:
      os << "NONE"; break;
    case AUTO:
      os << "AUTO"; break;
    case REGISTER:
      os << "REGISTER"; break;
    case STATIC:
      os << "STATIC"; break;
    case EXTERN:
      os << "EXTERN"; break;
    case TYPEDEF:
      os << "TYPEDEF"; break;
  }
  return os;
}
ostream& operator<<(ostream &os, SymbolTypes::TypeQualifier type_qualifier) {
  switch (type_qualifier) {
    case CONST:
      os << "CONST"; break;
    case VOLATILE:
      os << "VOLATILE"; break;
  }
  return os;
}

