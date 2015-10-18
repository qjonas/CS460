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

#include "SymbolType.h"

using namespace std;

SymbolTable& SymbolTable::GetInstance() {
	static SymbolTable instance;
	return instance;
}

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
	ofstream ofs(file_name);
	for(auto table_map : table_) {
		ofs << table_map.size() << " ";
		for(auto map_value : table_map) {
			ofs << map_value.first << " " << map_value.second << " ";
		}
		ofs << "\n";
	}
	ofs.close();
}

void SymbolTable::Print() const {
	cout << "Number of stack frames: " << table_.size() << endl;
	cout << "{" << endl;
	for(auto table_map : table_) {
		cout << "\tNumber of identifiers: " << table_map.size();
		for(auto ident_tuple : table_map) {
			cout << "\t{" << endl;
			cout << "\t\tidentifier_name: " << ident_tuple.second.identifier_name << endl;
			cout << "\t\ttype_specifier: ";
			for(auto type_specifier : ident_tuple.second.type_specifier_list) {
				cout << type_specifier << " ";
			}
			cout << endl;
			cout << "\t\tstorage_class_specifier: " << ident_tuple.second.storage_class_specifier;
			cout << "\t\ttype_qualifier_list: ";
			for(auto qualifier: ident_tuple.second.type_qualifier_list) {
				cout << qualifier << " ";
			}
			cout << endl;
			cout << "\t\ttypedef_name: " << ident_tuple.second.typedef_name;
			cout << "\t\tis_function: " << ident_tuple.second.is_function;
		}
	}
}


void SymbolTable::PushFrame() {
	table_.push_front(*(new map<string, SymbolInfo>));
	cout << "New frame has been pushed. The stack now has " << table_.size()
			 << " frame(s)." << endl;
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
	Reset();
	ifstream fin(file_name);
	int num_identifiers_in_stack;
	fin >> num_identifiers_in_stack;
	while(fin.good()) {
		table_.push_back(*(new map<string, SymbolInfo>()));
		for(int i = 0; i < num_identifiers_in_stack; i++) {
			string identifier_name;
			SymbolInfo value;
			fin >> identifier_name;
			fin >> value;
			table_.back()[identifier_name] = value;
		}
		fin >> num_identifiers_in_stack;
	}
	fin.close();
}