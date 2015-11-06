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
  void GenerateGraphviz(const std::string& file_name) const;
  void GenerateGraphvizHelper(std::ofstream& fout) const;

protected:
  static std::map<std::string, int> name_count_;
  std::string name_;
  std::string id_;
  std::list<Node*> children_;
};
}

// Forward declare.
struct SymbolInfo;

#include "../symbol_table/SymbolTable.h"

namespace AST {
class AdditiveNode : public Node {
public:
  AdditiveNode(bool is_add);

private:
  bool is_addition;
};

class AssignmentNode : public Node {
public:
   enum AssignmentType {
    EQUALS, MUL, DIV, MOD, ADD, SUB, LEFT, RIGHT, AND, XOR, OR
  };

  // Constructors 
  AssignmentNode(AssignmentType type);

private:
  AssignmentType type;

};

class ArrayAccessNode : public Node {
public:
  ArrayAccessNode(SymbolInfo* symbol_info);
private:
  // this will hold information about the symbol so we can calculate offset.
  SymbolInfo* info;
};

class DeclarationNode : public Node {
public:
  // Constructors 
  DeclarationNode(const std::list<SymbolInfo*>& infos);

private:
  // SymbolInfo of the declaration
  std::list<SymbolInfo*> Id_infos;
};

class DeclarationSpecifierNode : public Node {
public:
  DeclarationSpecifierNode();

};

class ExpressNode: public Node{
public:
  ExpressNode();
  ExpressNode(Node * child);
};

class IdentifierNode: public Node{
public:
  // constructor
  IdentifierNode(SymbolInfo * id);

private:
  SymbolInfo* Id_info;
};

class IntegerConstantNode : public Node {
public:
  IntegerConstantNode(long long int val);

private:
  long long int value;
};


class CharConstantNode : public Node {
public:
  CharConstantNode(char val);

private:
  char value;
};


class FloatingConstantNode : public Node {
public:
  FloatingConstantNode(long double val);

private:
  long double value;
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
