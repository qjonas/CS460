#include "Node.h"

#include <list>
#include <string>

using namespace AST;
using namespace std;

map<string, int> Node::name_count_;

Node::Node(const string& name) : name_(name) {
  if (name_count_.find(name) == name_count_.end()) {
    name_count_[name] = 1;
  } else {
    name_count_[name]++;
  }

  // There is probably a way better way to do this.
  int temp = name_count_[name];
  list<char> buffer;
  while (temp > 0) {
    buffer.push_front('1' + (temp % 10) - 1);
    temp /= 10;
  }
  for(char letter : buffer) {
    id_.push_back(letter);
  }
}

void Node::AddChild(Node * node) {
  children_.push_back(node);
}


void Node::GenerateGraphvizCode(ofstream& fout) const {
  fout << name_ << "_" << id_ << "[label = \"" << name_ << "\"";
  fout << "]" << endl;

  for(auto child : children_) {
    fout << name_ << "_" << id_ << " -> "; 
    fout << child->name_ << "_" << child->id_ << endl;
    child->GenerateGraphvizCode(fout);
  }
}
