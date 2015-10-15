/*
 * SymbolTable.h
 *
 *  Created on: Sep 21, 2015
 *      Author: ernestlandrito
 */

#ifndef SYMBOLTABLE_H_
#define SYMBOLTABLE_H_

#include <iterator>
#include <list>
#include <map>
#include <stack>
#include <string>

#include "SymbolType.h"

using namespace std;

class SymbolTable {
public:
	// Singleton getter
	static SymbolTable& GetInstance();

	// Insert a new identifier into the symbol table
	bool InsertSymbol(const string& name, SymbolInfo value);

	// This will search for the symbol throughout the entire symbol table and return
	// an iterator to the symbol that is the closest to the top of the stack.
	map<string, SymbolInfo>::iterator SearchSymbol(const string& search_name);

	// This will search for the symbol throughout the entire symbol table and 
	// return true if the name is in the symbol table somewhere.
	bool Has(const string& search_name);

	// This will take the symbol table and turn it into a form that will be able to
	// be read by the contruct from file constructor
	void OutputToFile(const string& file_name) const;

	// Creates a new stack frame.
	void PushFrame();

	// Removes a stack frame. Will return false if already at the global scope.
	bool PopFrame();

	// Makes it such that the instance is like it is freshly instantiated.
	void Reset();

	// Copies the output of a previous symbol table.
	void CopyFromFile(const string& file_name);

private:
	// Constructors
	SymbolTable();
	list< map<string, SymbolInfo> > table_;
};

#endif /* SYMBOLTABLE_H_ */
