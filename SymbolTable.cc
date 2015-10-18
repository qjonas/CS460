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

using namespace std;
using namespace SymbolTypes;

SymbolTable::SymbolTable() {
	PushFrame();
}

bool SymbolTable::InsertSymbol(const string& name, SymbolInfo value) {
	if(table_.front().find(name) == table_.front().end()){
		table_.front()[name] = value;
		cout << table_.front()[name].identifier_name 
				 << " is now in the SymbolTable" << endl;
		return true;
	}
	return false;
}

SymbolInfo* SymbolTable::GetMostRecentSymbolInfo(
		const string& search_name) {
	for(auto map_iter : table_) {
		map<string, SymbolInfo>::iterator search_iter =
				map_iter.find(search_name);
		if(search_iter != map_iter.end()){ 
			return &(search_iter->second);
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
			for(auto type_specifier : ident_tuple.second.type_specifier_list) {
				cout << type_specifier << " ";
			}
			cout << endl;
			cout << "\t\tstorage_class_specifier: " << ident_tuple.second.storage_class_specifier << endl;
			cout << "\t\ttype_qualifier_list: ";
			for(auto qualifier: ident_tuple.second.type_qualifier_list) {
				cout << qualifier << " ";
			}
			cout << endl;
			cout << "\t\ttypedef_name: " << ident_tuple.second.typedef_name << endl;
			cout << "\t\tis_function: " << ident_tuple.second.is_function << endl;
			cout << "\t}" << endl;
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
	data_is_valid(false), pointer_count(0) {}