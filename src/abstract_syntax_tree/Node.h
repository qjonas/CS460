#ifndef ABSTRACT_SYNTAX_TREE_NODE_H_
#define ABSTRACT_SYNTAX_TREE_NODE_H_

#include <fstream>
#include <list>
#include <map>
#include <ostream>
#include <string>

namespace AST {
class Node {
public:
  // Constructors
  Node(const std::string& name);
  Node(const std::string& name, Node * child);
  ~Node();

  // Add a child to node
  void AddChild(Node * node);

  // Generate 3AC;
  void Generate3AC(std::ostream& os) const;

  // Generate Graphviz Code:
  void GenerateGraphviz() const;
  void GenerateGraphvizHelper(std::ofstream& fout) const;

private:
  static std::map<std::string, int> name_count_;
  std::string name_;
  std::string id_;
  std::list<Node*> children_;
};

class AssignmentNode: public Node{
public:
  AssignmentNode();
};

class DeclarationNode: public Node{
public:
  DeclarationNode();
};

class SelectionNode : public Node {
public:
  SelectionNode();
};

class IdentifierNode: public Node{
public:
  // constructor
  IdentifierNode();

private:
  SymbolInfo* Id_info;
};

class ExpressNode: public Node{
public:
  ExpressNode();
};




}
#endif // ABSTRACT_SYNTAX_TREE_NODE_H_
