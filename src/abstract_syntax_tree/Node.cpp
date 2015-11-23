#include <string>
#include <vector>
#include <iostream>
#include "Node.h"

#include <list>


#include "../helpers/TicketCounter.h"

using namespace AST;
using namespace std;

map<string, int> Node::name_count_;
map<string, string> Node::identifier_to_temporary_;
TicketCounter Node::temp_int_counter_("TI");

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

std::string Node::Generate3AC(std::vector<std::string>& vector ){
  for(auto node : children_){
    if (node != NULL ){
      Generate3AC(vector);
    }
    return "";
  }
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

AdditiveNode::AdditiveNode(bool is_add) 
  : Node("Additive_Expression"), is_addition(is_add) {}

std::string AdditiveNode::Generate3AC(std::vector<std::string>& vector){
  list<Node*>::iterator tempIter;
  tempIter = children_.begin();
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
std::string  AssignmentNode::Generate3AC(std::vector<std::string>& vector){
  if(type == EQUALS){
  string temp = "ASSIGN(equals), ";

  //should be variable or temporary from variable declaration
  temp += name_;
  temp += ", , ";
  string tempReg = temp_int_counter_.GenerateTicket();
  temp += tempReg;
  vector.push_back(temp);
  cout << temp << endl;
  return tempReg;
 }


}


ArrayAccessNode::ArrayAccessNode(SymbolInfo* symbol_info) 
  : Node("Array_Access"), info(symbol_info) {}

std::string  ArrayAccessNode::Generate3AC(std::vector<std::string>& vector){



}

DeclarationNode::DeclarationNode(const list<SymbolInfo*>& infos) 
  : Node("Declaration"), Id_infos(infos) {}

std::string DeclarationNode::Generate3AC(std::vector<std::string>& vector){



}

EqualityNode::EqualityNode(RelationalType t) : Node("EqualityNode"), type(t) {}

std::string  EqualityNode::Generate3AC(std::vector<std::string>& vector){



}


ExpressNode::ExpressNode() : Node("Expression") {}
ExpressNode::ExpressNode(Node * child) : Node("Expression", child) {}
std::string  ExpressNode::Generate3AC(std::vector<std::string>& vector){



}

IdentifierNode::IdentifierNode(SymbolInfo* id) 
  : Node("Identifier"), Id_info(id) {
    AddChild(new Node(id->identifier_name));
  }
std::string  IdentifierNode::Generate3AC(std::vector<std::string>& vector){
std::string tempReg, temp;

temp = "ASSIGN(id), ";
temp += Id_info->identifier_name;
temp += ", , ";
tempReg = temp_int_counter_.GenerateTicket();
temp += tempReg;
vector.push_back(temp);
 cout << temp << endl;
return tempReg;
}

IntegerConstantNode::IntegerConstantNode(long long int val) 
  : Node("Integer_Constant"), value(val) {
  }
std::string  IntegerConstantNode::Generate3AC(std::vector<std::string>& vector){



}

CharConstantNode::CharConstantNode(char val) 
  : Node("Char_Constant"), value(val) {
}
std::string  CharConstantNode::Generate3AC(std::vector<std::string>& vector){



}
FloatingConstantNode::FloatingConstantNode(long double val) 
  : Node("Floating_Constant"), value(val) {
  }
std::string FloatingConstantNode::Generate3AC(std::vector<std::string>& vector){



}

IterationNode::IterationNode(bool post_check) : Node("Iteration"),
is_post_check(post_check) {}

IterationNode::IterationNode() : IterationNode(false) {}
std::string  IterationNode::Generate3AC(std::vector<std::string>& vector){



}

SelectionNode::SelectionNode() : Node("Selection") {}
std::string  SelectionNode::Generate3AC(std::vector<std::string>& vector){



}


