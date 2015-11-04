#include "Node.h"

#include <list>
#include <string>

using namespace AST;
using namespace std;

map<string, int> Node::name_count_;

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


void Node::GenerateGraphviz() const {
  // Create file stream.
  ofstream fout("AST.dot");

  // Create a digraph.
  fout << "digraph AST {" << endl;

  // Create edges.
  GenerateGraphvizHelper(fout);

  // Finish digraph.
  fout << "}";

  // Close the file.
  fout.close();

  // Create the png of the AST.
  system("dot -Tpng AST.dot -o AST.png");
  // system("rm AST.dot");
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

AssignmentNode::AssignmentNode():Node("Assignment") {}

DeclarationNode::DeclarationNode():Node("Declaration") {}

ExpressNode::ExpressNode() : Node("Expression")

IterationNode::IterationNode(bool post_check) : Node("Iteration"),
is_post_check(post_check) {}

IterationNode::IterationNode() : IterationNode(false) {}

SelectionNode::SelectionNode() : Node("Selection") {}

IdentifierNode::IdentifierNode() : Node("Identifier"){}

