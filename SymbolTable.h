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

class SymbolTable {
public:
	// Singleton getter
	static SymbolTable& GetInstance();

	// Insert a new identifier into the symbol table
	bool InsertSymbol(const std::string& name, SymbolInfo value);

	// This will search for the symbol throughout the entire symbol table and return
	// an iterator to the symbol that is the closest to the top of the stack.
	SymbolInfo* GetMostRecentSymbolInfo(const std::string& search_name);

	bool HasShadowing(const std::string& search_name) const;

	bool HasInScope(const std::string& search_name) const;

	// This will search for the symbol throughout the entire symbol table and 
	// return true if the name is in the symbol table somewhere.
	bool Has(const std::string& search_name) const;

	// This will take the symbol table and turn it into a form that will be able to
	// be read by the contruct from file constructor
	void OutputToFile(const std::string& file_name) const;

	void Print() const;

	// Creates a new stack frame.
	void PushFrame();
	
	// Removes a stack frame. Will return false if already at the global scope.
	bool PopFrame();

	// Makes it such that the instance is like it is freshly instantiated.
	void Reset();

	// Copies the output of a previous symbol table.
	void CopyFromFile(const std::string& file_name);

private:
	// Constructors
	SymbolTable();
	std::list< std::map<std::string, SymbolInfo> > table_;
};

#endif /* SYMBOLTABLE_H_ */
