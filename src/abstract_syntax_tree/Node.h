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






class AssignmentNode : public Node {
public:
  // Constructors 
  AssignmentNode();
};

class DeclarationNode : public Node {
public:
  // Constructors 
  DeclarationNode();
};

class IterationNode : public Node {
public:
  IterationNode();
  IterationNode(bool post_check);

private:
  bool is_post_check;
};

class SelectionNode : public Node {
public:
  SelectionNode();
};

}



#endif // ABSTRACT_SYNTAX_TREE_NODE_H_
