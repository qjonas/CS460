//Three AC to ASM
#include <string>
#include <queue>
#include <vector>
#include <iostream>
#include "ThreeACtoASM.h"

using namespace std;

string ThreeACtoASM::getReg(string var){
		// // check if already in a register
		 if(addressTable[var] == ""){	
			if(var[1] == 'I'){
		 		string temp = INT_LRU.front();
				INT_LRU.pop_front();

		 		addressTable[var] = temp;
		 		// add MIPS code for loading value into register
					
		 		INT_LRU.push_back(temp);
		 		return temp;
		 	}
		 	else{
		 		string temp = FLOAT_LRU.front();
		 		FLOAT_LRU.pop_front();
				addressTable[var] = temp;
		 		// add MIPS code for loading value into register

		 		FLOAT_LRU.push_back(temp);
		 		return temp;
		 	}
		 }
		 // variable is already loaded into a register
		 else{
		 	return addressTable[var];
		 }
	return var;
}

void ThreeACtoASM::init(){
	//first load LRUs with actual register names
	//init INT_LRU
	INT_LRU.clear();
	FLOAT_LRU.clear();
	text_code.clear();
	data_code.clear();

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
	data_code.push_back("	.data");
	text_code.push_back("	.text");
	text_code.push_back("main:");
}

vector<string> ThreeACtoASM::Convert( vector< vector<string> > three_address_code) {
  init();
  for(auto str : three_address_code) {
    if(str.size() != 4) {
      text_code.push_back(str[0]);
    } else {
      string operation = str[0];
      string op_one = str[1];
      string op_two = str[2];
      string op_three = str[3];

      string machine_code;
      string data_code_;
      if (operation == "ADD") {
        machine_code += "add ";
        machine_code += getReg(op_three);
        machine_code += ", ";
        machine_code += wrapOffsetIfAddress(getReg(op_one));
        machine_code += ", ";
        machine_code += wrapOffsetIfAddress(getReg(op_two));
      } else if (operation == "ADDROFFSET") {
        machine_code += "add ";
        machine_code += getReg(op_three);
        machine_code += ", ";
        machine_code += getReg(op_one);
        machine_code += ", ";
        machine_code += getReg(op_two);
      } else if (operation == "ASSIGN") {
        machine_code += "sw ";
        machine_code += getReg(op_three);
        machine_code += getReg(op_one);
      } else if (operation == "BRANCH") {
        machine_code += "b ";
        machine_code += op_three;
      } else if (operation == "BREQ") {
        machine_code += "breq ";
        machine_code += wrapOffsetIfAddress(getReg(op_one));
        machine_code += ", ";
        machine_code += wrapOffsetIfAddress(getReg(op_two));
        machine_code += ", ";
        machine_code += op_three;
      } else if (operation == "EQ") {
        machine_code += "seq ";
        machine_code += getReg(op_three);
        machine_code += ", ";
        machine_code += wrapOffsetIfAddress(getReg(op_one));
        machine_code += ", ";
        machine_code += wrapOffsetIfAddress(getReg(op_two));
      } else if (operation == "GE") {
        machine_code += "sge ";
        machine_code += getReg(op_three);
        machine_code += ", ";
        machine_code += wrapOffsetIfAddress(getReg(op_one));
        machine_code += ", ";
        machine_code += wrapOffsetIfAddress(getReg(op_two));
      } else if (operation == "GREATER") {
        machine_code += "sgt ";
        machine_code += getReg(op_three);
        machine_code += ", ";
        machine_code += wrapOffsetIfAddress(getReg(op_one));
        machine_code += ", ";
        machine_code += wrapOffsetIfAddress(getReg(op_two));
      } else if (operation == "IDTOTEMP") {
        machine_code += "la ";
        machine_code += getReg(op_three);
        machine_code += ", ";
        machine_code += op_one;
      } else if (operation == "LABEL") {
        machine_code += op_one;
        machine_code += ':';
      } else if (operation == "LE") {
        machine_code += "sle ";
        machine_code += getReg(op_three);
        machine_code += ", ";
        machine_code += wrapOffsetIfAddress(getReg(op_one));
        machine_code += ", ";
        machine_code += wrapOffsetIfAddress(getReg(op_two));
      } else if (operation == "LESS") {
        machine_code += "slt ";
        machine_code += getReg(op_three);
        machine_code += ", ";
        machine_code += wrapOffsetIfAddress(getReg(op_one));
        machine_code += ", ";
        machine_code += wrapOffsetIfAddress(getReg(op_two));
      } else if (operation == "MULT") {
        machine_code += "mult ";
        machine_code += wrapOffsetIfAddress(getReg(op_one));
        machine_code += ", ";
        machine_code += wrapOffsetIfAddress(getReg(op_two));
      } else if (operation == "NEQ") {
        machine_code += "sne ";
        machine_code += getReg(op_three);
        machine_code += ", ";
        machine_code += wrapOffsetIfAddress(getReg(op_one));
        machine_code += ", ";
        machine_code += wrapOffsetIfAddress(getReg(op_two));
      } else if (operation == "NEWID") {
        data_code_ += op_one;
        data_code_ += ":\t .word ";
        data_code_ += op_two;
      } else if (operation == "SET") {
        machine_code += "li";
        machine_code += getReg(op_three);
        machine_code += ", ";
        machine_code += op_one;
      } else if (operation == "SUB") {
        machine_code += "sub ";
        machine_code += getReg(op_three);
        machine_code += ", ";
        machine_code += wrapOffsetIfAddress(getReg(op_one));
        machine_code += ", ";
        machine_code += wrapOffsetIfAddress(getReg(op_two));
      }

      if (!machine_code.empty()) {
        text_code.push_back(machine_code);
      }
      if (data_code.empty()) {
        data_code.push_back(data_code_);
      }
    }
  }
  vector<string> mips = data_code;
  mips.insert(mips.end(), text_code.begin(), text_code.end());
  return mips;
}

string ThreeACtoASM::wrapOffsetIfAddress(const string& str) {
  string temp = str;
  if (str[2] == 'A') {
    temp = string("0(")+temp+string(")");
  }
  return temp;
}