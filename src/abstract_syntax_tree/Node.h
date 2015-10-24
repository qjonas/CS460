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
  ~Node();

  // Add a child to node
  void AddChild(Node * node);

  // Generate 3AC;
  void Generate3AC(std::ostream& os) const;

  // Generate Graphviz Code:
  void GenerateGraphvizCode(std::ofstream& fout) const;

private:
  static std::map<std::string, int> name_count_;
  std::string name_;
  std::string id_;
  std::list<Node*> children_;
};
}

#endif // ABSTRACT_SYNTAX_TREE_NODE_H_
