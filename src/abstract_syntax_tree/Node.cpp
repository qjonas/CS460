#include <string>
#include <vector>
#include <iostream>
#include "Node.h"

#include <list>

#include "../helpers/TicketCounter.h"
#include "../symbol_table/SymbolInfoUtil.h"
#include "../symbol_table/SymbolTable.h"

using namespace AST;
using namespace std;

map<string, int> Node::name_count_;
list<map<string, string> > Node::identifier_to_temporary_ 
    = list<map<string, string> >({map<string, string>()});
TicketCounter Node::temp_int_counter_("TI");
TicketCounter Node::temp_float_counter_("TF");
TicketCounter Node::temp_label_counter_("TL");

Node::Node(const string& name) : name_(name) {
  // Add name to name count.
  if (name_count_.find(name) == name_count_.end()) {
    name_count_[name] = 1;
  } else {
    name_count_[name]++;
  }

  // Set id to name count.
  id_ = to_string(name_count_[name]);
}

Node::Node(const string& name, Node * child) : Node(name) {
  AddChild(child);
}

Node::~Node() {
  
}

void Node::AddChild(Node * node) {
  children_.push_back(node);
}


void Node::GenerateGraphviz(const string& file_name) const {
  // Create file stream.
  string dot_name(file_name);
  dot_name.append(".dot");
  ofstream fout(dot_name);

  // Create a digraph.
  fout << "digraph AST {" << endl;

  // Create edges.
  GenerateGraphvizHelper(fout);

  // Finish digraph.
  fout << "}";

  // Close the file.
  fout.close();

  // Create the png of the AST.
  string sys_call("dot -Tpng ");
  sys_call.append(dot_name);
  sys_call.append(" -o ");
  sys_call.append(file_name);
  sys_call.append(".png");
  system(sys_call.c_str());
  // system("rm AST.dot");
}

string Node::Generate3AC(vector<string>& vector){
  for(auto node : children_){
    if (node != NULL ){
      node->Generate3AC(vector);
    }
  }
  return "";
}
void Node::GenerateGraphvizHelper(ofstream& fout) const {
  // Generate a label for each node
  fout << name_ << "_" << id_ << "[label = \"" << name_ << "\"";
  fout << "]" << endl;

  // Recursively generate the graphviz of each child.
  for(auto child : children_) {
    if(child == NULL) continue;
    fout << name_ << "_" << id_ << " -> "; 
    fout << child->name_ << "_" << child->id_ << endl;
    child->GenerateGraphvizHelper(fout);
  }
}

void Node::PopFrame() {
  if (identifier_to_temporary_.size() > 1) {
    identifier_to_temporary_.pop_front();
  }
}

void Node::PushFrame() {
  identifier_to_temporary_.push_front(map<string,string>());
}

AdditiveNode::AdditiveNode(bool is_add) 
  : Node("Additive_Expression"), is_addition(is_add) {}

string AdditiveNode::Generate3AC(vector<string>& vector){
  auto tempIter = children_.begin();
  string temp, sourceOne, sourceTwo, tempReg;
  if(is_addition){temp = "ADD, ";}
  else{temp = "SUB, ";}
  sourceOne = (children_.front())->Generate3AC(vector); // segfault this ine
  tempIter++;
  //skip plus node
  tempIter++;
  sourceTwo = (*tempIter)->Generate3AC(vector);
  temp += sourceOne;
  temp += ", ";
  temp += sourceTwo;
  temp += ", ";
  tempReg = temp_int_counter_.GenerateTicket();
  temp += tempReg;
  vector.push_back(temp);
  cout << temp << endl;
  return tempReg;


}
AssignmentNode::AssignmentNode(AssignmentType type) : Node("Assignment") {
  this->type = type;
}
string AssignmentNode::Generate3AC(vector<string>& three_address_code_vec){
  if(type == EQUALS){
  string temp = "ASSIGN(equals), ";

  string tempReg = children_[0]->Generate3AC(three_address_code_vec);
  temp += tempReg;

  //should be variable or temporary from variable declaration
  temp += ", , ";

  temp += children_[1]->Generate3AC(three_address_code_vec);

  three_address_code_vec.push_back(temp);
  cout << temp << endl;
  return tempReg;
 }


}


ArrayAccessNode::ArrayAccessNode(SymbolInfo* symbol_info) 
  : Node("Array_Access") {
    info = new SymbolInfo(*symbol_info);
  }

string  ArrayAccessNode::Generate3AC(vector<string>& three_address_code_vec){

  string three_address_code = "MULT, ";
  three_address_code += to_string(ArrayAccessSizeOf(*info));
  three_address_code += ", ";

  three_address_code += children_[1]->Generate3AC(three_address_code_vec);
  three_address_code += ", ";

  string offset_register = temp_int_counter_.GenerateTicket();

  three_address_code += offset_register;
  three_address_code_vec.push_back(three_address_code);
  cout << three_address_code << endl;

  three_address_code = string("ADDROFFSET, ");

  three_address_code += children_[0]->Generate3AC(three_address_code_vec);
  three_address_code += ", ";

  three_address_code += offset_register;
  three_address_code += ", ";

  string temp_register = temp_int_counter_.GenerateTicket();
  three_address_code += temp_register;

  cout << three_address_code << endl;

  return temp_register;
}

DeclarationNode::DeclarationNode(const list<SymbolInfo*>& infos) 
  : Node("Declaration"), Id_infos(infos) {}

string DeclarationNode::Generate3AC(vector<string>& vector){



}

EqualityNode::EqualityNode(RelationalType t) : Node("EqualityNode"), type(t) {}

string  EqualityNode::Generate3AC(vector<string>& three_address_code_vec){

  string three_address_code;
  switch(type) {
    case RelationalType::EQ:
    three_address_code += "EQ, ";
    break;
    case RelationalType::NE:
    three_address_code += "NEQ, ";
    break;
    case RelationalType::LESS:
    three_address_code += "LESS, ";
    break;
    case RelationalType::GREATER:
    three_address_code += "GREATER, ";
    break;
    case RelationalType::LE:
    three_address_code += "LE, ";
    break;
    case RelationalType::GE:
    three_address_code += "GE, ";
    break;
  }

  three_address_code += children_[0]->Generate3AC(three_address_code_vec);
  three_address_code += ", ";

  three_address_code += children_[2]->Generate3AC(three_address_code_vec);
  three_address_code += ", ";

  string temp_register = temp_int_counter_.GenerateTicket();
  three_address_code += temp_register;

  cout << three_address_code << endl;

  return temp_register;
}


ExpressNode::ExpressNode() : Node("Expression") {}
ExpressNode::ExpressNode(Node * child) : Node("Expression", child) {}
string ExpressNode::Generate3AC(vector<string>& vector){
  return children_[0]->Generate3AC(vector);
}

IdentifierNode::IdentifierNode(SymbolInfo* id) 
  : Node("Identifier") {
    Id_info = new SymbolInfo(*id);
    AddChild(new Node(id->identifier_name));
  }
string  IdentifierNode::Generate3AC(vector<string>& vector){

  for(auto frame_map : identifier_to_temporary_) {
    map<string, string>::iterator tempIter;
    tempIter = frame_map.find(Id_info->identifier_name);
    if(tempIter != frame_map.end()) {
      return tempIter->second;
    } 
  }

  string tempReg, temp;
  tempReg = temp_int_counter_.GenerateTicket();
  temp = "ASSIGN(id), ";
  temp += Id_info->identifier_name;
  temp += ", , ";
  temp += tempReg;
  identifier_to_temporary_.front()[Id_info->identifier_name] = tempReg;
  vector.push_back(temp);
  cout << temp << endl;
  return tempReg;
}

IntegerConstantNode::IntegerConstantNode(long long int val) 
  : Node("Integer_Constant"), value(val) {
  }

string  IntegerConstantNode::Generate3AC(vector<string>& vector){
  string temp, tempReg;

  return to_string(value);
}

CharConstantNode::CharConstantNode(char val) 
  : Node("Char_Constant"), value(val) {
}
string  CharConstantNode::Generate3AC(vector<string>& vector){

  return to_string((int)value);
}
FloatingConstantNode::FloatingConstantNode(long double val) 
  : Node("Floating_Constant"), value(val) {
  }

string FloatingConstantNode::Generate3AC(vector<string>& vector){
  string float_register = temp_float_counter_.GenerateTicket();

  string three_address_code = "ASSIGN(id), ";
  three_address_code += to_string(value);

  three_address_code += ", , ";
  three_address_code += float_register;

  return float_register;
}

IterationNode::IterationNode(bool post_check) : Node("Iteration"),
is_post_check(post_check) {}

IterationNode::IterationNode() : IterationNode(false) {}
string  IterationNode::Generate3AC(vector<string>& three_address_code_vec){
  string start_of_loop_label = temp_label_counter_.GenerateTicket();
  string end_label = temp_label_counter_.GenerateTicket();

  // Generate code for intiializer
  if(children_[0] != NULL) {
    children_[0]->Generate3AC(three_address_code_vec);
  }

  // Generate start of loop label
  string three_address_code = string("LABEL, ") + start_of_loop_label + ", ,";
  cout << three_address_code << endl;
  three_address_code_vec.push_back(three_address_code);

  // Generate code for check
  if(!is_post_check && children_[1] != NULL) {
    three_address_code = string("BREQ, 0, ");
    three_address_code += children_[1]->Generate3AC(three_address_code_vec);
    three_address_code += ", ";
    three_address_code += end_label;

    cout << three_address_code << endl;

    three_address_code_vec.push_back(three_address_code);
  }

  // Generate Statements 3AC
  if(children_[3] != NULL) {
    children_[3]->Generate3AC(three_address_code_vec);
  }

  // Generate Incrementer 3AC
  if(children_[2] != NULL) {
    children_[2]->Generate3AC(three_address_code_vec);
  }

  three_address_code = string("BRANCH, , , ") + start_of_loop_label;
  cout << three_address_code << endl;

  three_address_code_vec.push_back(three_address_code);

  // Generate end label
  three_address_code = string("LABEL, ") + end_label + ", ,";
  cout << three_address_code << endl;
  three_address_code_vec.push_back(three_address_code);

  return "";
}

SelectionNode::SelectionNode() : Node("Selection") {}
string  SelectionNode::Generate3AC(vector<string>& three_address_code_vec){

  string false_label = temp_label_counter_.GenerateTicket();
  string end_label = temp_label_counter_.GenerateTicket();

  // Branch if the expression is equal to 0;
  string three_address_code = "BREQ, 0, ";
  three_address_code += children_[0]->Generate3AC(three_address_code_vec);
  three_address_code += ", ";
  three_address_code += false_label;

  cout << three_address_code << endl;
  three_address_code_vec.push_back(three_address_code);

  if(children_.size() > 1) {
    children_[1]->Generate3AC(three_address_code_vec);
    three_address_code = string("BRANCH, , , ") + end_label;
    cout << three_address_code << endl;
    three_address_code_vec.push_back(three_address_code);
  }

  // Generate false label
  three_address_code = string("LABEL, ") + false_label + ", ,";
  cout << three_address_code << endl;
  three_address_code_vec.push_back(three_address_code);

  if(children_.size() > 2) {
    children_[2]->Generate3AC(three_address_code_vec);
  }

  // Generate false label
  three_address_code = string("LABEL, ") + end_label + ", ,";
  cout << three_address_code << endl;
  three_address_code_vec.push_back(three_address_code);

  return "";
}


