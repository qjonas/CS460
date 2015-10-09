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
using namespace std;

typedef int SymbolType;

class SymbolTable {
public:
	// Constructors
	SymbolTable();
	SymbolTable(const SymbolTable& other);
	SymbolTable(const string& file_name); // Construct from a file
	~SymbolTable();

	// Insert a new identifier into the symbol table
	bool InsertSymbol(const string& name, SymbolType value);

	// This will search for the symbol throughout the entire symbol table and return
	// an iterator to the symbol that is the closest to the top of the stack.
	map<string, SymbolType>::iterator SearchSymbol(const string& search_name);

	// This will take the symbol table and turn it into a form that will be able to
	// be read by the contruct from file constructor
	void OutputToFile(const string& file_name) const;

	// Creates a new stack frame.
	void PushFrame();

	// Removes a stack frame. Will return false if already at the global scope.
	bool PopFrame();

private:
	list< map<string, SymbolType> > table_;
};

#endif /* SYMBOLTABLE_H_ */
