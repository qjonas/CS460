/*
 * SymbolTable.cpp
 *
 *  Created on: Sep 21, 2015
 *      Author: ernestlandrito
 */

#include "SymbolTable.h"

#include <fstream>
#include <iostream>
#include <iterator>
#include <list>
#include <map>
#include <stack>
#include <string>

#include "../helpers/Escape_Sequences_Colors.h"

using namespace std;
using namespace SymbolTypes;

SymbolTable::SymbolTable() {
	PushFrame();
}

bool SymbolTable::InsertSymbol(const string& name, SymbolInfo value) {
	if(table_.front().find(name) == table_.front().end()){
		table_.front()[name] = value;
		return true;
	}
	return false;
}

SymbolInfo* SymbolTable::GetMostRecentSymbolInfo(
		const string& search_name) {
	for(list<map<string, SymbolInfo>>::iterator list_iter = table_.begin();
			list_iter != table_.end(); list_iter++) {
		if(list_iter->find(search_name) != list_iter->end()) {
			return &((*list_iter)[search_name]);
		}
	}
	return NULL;
}

bool SymbolTable::HasInScope(const string& search_name) const {
	return !(table_.front().find(search_name) == table_.front().end());
}

bool SymbolTable::HasShadowing(const string& search_name) const {
	list<map<string,SymbolInfo>>::const_iterator iter = table_.begin();
	iter++;
	while(iter != table_.end()) {
		map<string, SymbolInfo>::const_iterator search_iter =
				iter->find(search_name);
		if(search_iter != iter->end()){
			return true;
		}
		iter++;
	}
	return false;
}

bool SymbolTable::Has(const string& search_name) const {
	for(auto map_iter : table_) {
		map<string, SymbolInfo>::iterator search_iter =
				map_iter.find(search_name);
		if(search_iter != map_iter.end()){
			return true;
		}
	}
	return false;
}

void SymbolTable::OutputToFile(const string& file_name) const {

}

void SymbolTable::Print() const {
	cout << "Number of stack frames: " << table_.size() << endl;
	int stack_frames = table_.size() - 1;
	for(auto table_map : table_) {
		cout << "Stack Frame: " << stack_frames-- << endl;
		cout << "\tNumber of identifiers: " << table_map.size() << endl;
		for(auto ident_tuple : table_map) {
			cout << "\t{" << endl;
			cout << "\t\tidentifier_name: " << ident_tuple.second.identifier_name << endl;
			cout << "\t\ttype_specifier: ";
			for(SymbolTypes::SymbolType type_specifier : ident_tuple.second.type_specifier_list) {
				cout << type_specifier << " ";
			}
			cout << endl;
			cout << "\t\tstorage_class_specifier: " << ident_tuple.second.storage_class_specifier << endl;
			cout << "\t\ttype_qualifier_list: ";
			for(auto qualifier: ident_tuple.second.type_qualifier_list) {
				cout << qualifier << " ";
			}
			cout << endl;
      cout << "\t\tdata_value: " << ident_tuple.second.data_value.long_long_val << endl;
      cout << "\t\tdata_is_valid: " << ident_tuple.second.data_is_valid << endl;
			cout << "\t\ttypedef_name: " << ident_tuple.second.typedef_name << endl;
			cout << "\t\tis_function: " << ident_tuple.second.is_function << endl;
			cout << "\t\tparameters_types: " << endl;
			for(auto list_ : ident_tuple.second.parameters_types) {
				cout << "\t\t\t{ " << endl;
        cout << "\t\t\ttype_specifier_list: ";
				for(auto type : list_.type_specifier_list) {
					cout << type << " ";
				}
        cout << endl;
        cout << "\t\t\tstorage_class_specifier: " << list_.storage_class_specifier;
        cout << endl;
        cout << "\t\t\ttype_qualifier_list: ";
        for(auto type : list_.type_qualifier_list) {
          cout << type << " ";
        }
        cout << endl;
        cout << "\t\t\tarray_sizes: ";
        for(auto size : list_.array_sizes) {
          cout << size << " ";
        }
        cout << endl;
				cout << "\t\t\t} ";
        cout << endl;
			}
			cout << endl;
			cout << "\t\tarray_sizes: ";
			for(auto size : ident_tuple.second.array_sizes) {
				cout << size << " ";
			}
			cout << endl;
			cout << "\t}" << endl;
		}
	}
}

void SymbolTable::DriverPrint() const {
  cout << COLOR_GREEN_NORMAL << "Symbol Table" << COLOR_NORMAL << endl;
  cout << COLOR_GREEN_NORMAL << "============" << COLOR_NORMAL << endl;

  cout << "Number of stack frames: " << table_.size() << endl;
  int stack_frames = table_.size() - 1;
  for(auto table_map : table_) {
    cout << "Stack Frame: " << stack_frames-- << endl;
    cout << "\tNumber of identifiers: " << table_map.size() << endl;
    for(auto ident_tuple : table_map) {
      cout << "\t\tidentifier_name: " << ident_tuple.second.identifier_name << endl;
    }
  }
}

void SymbolTable::PushFrame() {
	table_.push_front(*(new map<string, SymbolInfo>));
}

bool SymbolTable::PopFrame() {
	if(table_.size() > 1) {
		table_.pop_front();
		return true;
	}
	return false;
}

void SymbolTable::Reset() {
	while(!table_.empty()) {
		table_.front().clear();
		table_.pop_front();
	}
	PushFrame();
}

void SymbolTable::CopyFromFile(const string& file_name) {

}

SymbolInfo::SymbolInfo() : storage_class_specifier(NONE), is_function(false),
	data_is_valid(false), range_start(-1), postfix_increment(0), 
  function_defined(false) 
  {}

SymbolInfo::SymbolInfo(const SymbolInfo& other) : identifier_name(other.identifier_name),
data_value(other.data_value),
data_is_valid(other.data_is_valid), 
type_specifier_list(other.type_specifier_list),
storage_class_specifier(other.storage_class_specifier),
type_qualifier_list(other.type_qualifier_list),
typedef_name(other.typedef_name), 
struct_or_union_values(other.struct_or_union_values),
array_sizes(other.array_sizes),
is_function(other.is_function),
function_defined(other.function_defined),
parameters_types(other.parameters_types),
range_start(other.range_start),
postfix_increment(other.postfix_increment){}


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

