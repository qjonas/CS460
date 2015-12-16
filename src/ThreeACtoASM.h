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
#include "Node.h"




using namespace std;
// register 0, has value zero
// 8-15
// 24-25 Free temps
class ThreeACtoASM{
public:
	// types of registers for use:
	enum RegType{ integer, floating };

	//convert 
	vector<string> Convert(Vector<vector>string 3AC);

	// get the next free register
	string getReg(string var);

	// Queue of available integer registers
	queue<string> INT_LRU (10);

	//Queue of available float registers
	queue<string> FLOAT_LRU(10);

	// Where is the value of a variable being stored.
	Map <string, string> addressTable;

	//intializes MIPS program to be run
	void init();

private:
	//Output Vector
	vector<string> text_code;


};

#endif // THREE_AC_TO_ASM_H_
