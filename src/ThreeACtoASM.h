#ifndef THREE_AC_TO_ASM_H
#define THREE_AC_TO_ASM_H
 /*
 * ThreeACtoASM.h
 *
 *  Created on: DEFINITELY NOT THE NIGHT BEFORE
 *      Author: ernestlandorito
 */

// in: a vector of vectors
// manage: register allocation
// manage: current address of variables
// vector of register values
// vector of variables this is from the symbol table
// check getReg(I)

#include <iostream>
#include <vector>
#include <map>
#include <string>
#include <queue>
#include "abstract_syntax_tree/Node.h"

// register 0, has value zero
// 8-15
// 24-25 Free temps
class ThreeACtoASM{
public:
	// types of registers for use:
	enum RegType{ integer, floating };

	//convert 
	std::vector<std::string> Convert(std::vector<std::vector<std::string> > three_address_code);

	// get the next free register
	std::string getReg(std::string var);

	// Queue of available integer registers
	std::queue<std::string> INT_LRU;

	//Queue of available float registers
	std::queue<std::string> FLOAT_LRU;

	// Where is the value of a variable being stored.
	std::map <std::string, std::string> addressTable;

	//intializes MIPS program to be run
	void init();

	std::string wrapOffsetIfAddress(const std::string& str, int offset);

private:
	//Output Vector
	std::vector<std::string> text_code;
	std::vector<std::string> data_code;

};

#endif // THREE_AC_TO_ASM_H_
