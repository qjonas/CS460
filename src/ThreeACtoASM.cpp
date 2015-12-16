//Three AC to ASM
#include <string>
#include <queue>
#include <vector>
#include <iostream>
#include "ThreeACtoASM.h"

using namespace std;

string ThreeACtoASM::getReg(string var){
		// check if already in a register
		if(addressTable[var] == NULL){	
			if(var[1] == 'I'){
				string temp = INT_LRU.pop();
				adressTable[var] = temp;
				// add MIPS code for loading value into register
					
				INT_LRU.push_back(temp);
				return temp;
			}
			else{
				string temp = FLOAT_LRU.pop();
				adressTable[var] = temp;
				// add MIPS code for loading value into register

				FLOAT_LRU.push_back(temp);
				return temp;
			}
		}
		// variable is already loaded into a register
		else{
			return addressTable[var];
		}
}

ThreeACtoASM::init(){
	//first load LRUs with actual register names
	//init INT_LRU
	int counter = 8;
	for(;counter < 16;counter++)
	{
		string temp = "$" + to_string(counter);
		INT_LRU.push_back(temp);
	}
	//don't forget last 2
	INT_LRU.push_back("$24");
	INT_LRU.push_back("$25");

	//load fLRU
	for(counter = 4; counter < 11; counter++)
	{
		string temp = "$f" + to_string(counter);
		FLOAT_LRU.push_back(temp);
	}

	FLOAT_LRU.push_back("$f16");
	FLOAT_LRU.push_back("$f17");
	FLOAT_LRU.push_back("$f18");


	// load text_code with headers
	text_code.push_back("	.data");
	text_code.push_back("	.text");
	text_code.push_back("main:")
}