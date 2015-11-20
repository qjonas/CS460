#ifndef ABSTRACT_SYNTAX_TREE_NODE_H_
#define ABSTRACT_SYNTAX_TREE_NODE_H_

#include <fstream>
#include <list>
#include <map>
#include <iostream>
#include <ostream>
#include <string>
#include <vector>

#include "../helpers/TicketCounter.h"

namespace AST {
class Node {
public:
  // Constructors
  Node(const std::string& name);
  Node(const std::string& name, Node * child);
  ~Node();

  // Add a child to node
  void AddChild(Node * node);

  // Generate 3AC; The string returned is the temporary that it should return.
  virtual void Generate3AC(std::vector<std::string>& vector ){std::cout << "base";};

  // Generate Graphviz Code:
  void GenerateGraphviz(const std::string& file_name) const;
  void GenerateGraphvizHelper(std::ofstream& fout) const;

protected:
  static std::map<std::string, int> name_count_;
  static std::map<std::string, std::string> identifier_to_temporary_;
  static TicketCounter temp_int_counter_;
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
  void Generate3AC(std::vector<std::string>& vector );
  
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
void Generate3AC(std::vector<std::string>& vector );
private:
  AssignmentType type;

};

class ArrayAccessNode : public Node {
public:
  ArrayAccessNode(SymbolInfo* symbol_info);
  void Generate3AC(std::vector<std::string>& vector );

private:
  // this will hold information about the symbol so we can calculate offset.
  SymbolInfo* info;
};

class DeclarationNode : public Node {
public:
  // Constructors 
  DeclarationNode(const std::list<SymbolInfo*>& infos);
  void Generate3AC(std::vector<std::string>& vector );

private:
  // SymbolInfo of the declaration
  std::list<SymbolInfo*> Id_infos;
};

class DeclarationSpecifierNode : public Node {
public:
  DeclarationSpecifierNode();
  void Generate3AC(std::vector<std::string>& vector );

};

class EqualityNode : public Node {
public:
  enum RelationalType {
    EQ, NE, LESS, GREATER, LE, GE
  };
  EqualityNode(RelationalType t);
  void Generate3AC(std::vector<std::string>& vector );

private:
  RelationalType type;
};

class ExpressNode: public Node{
public:
  ExpressNode();
  ExpressNode(Node * child);
  void Generate3AC(std::vector<std::string>& vector );
};

class IdentifierNode: public Node{
public:
  // constructor
  IdentifierNode(SymbolInfo * id);
  void Generate3AC(std::vector<std::string>& vector );

private:
  SymbolInfo* Id_info;
};

class IntegerConstantNode : public Node {
public:
  IntegerConstantNode(long long int val);
  void Generate3AC(std::vector<std::string>& vector );

private:
  long long int value;
};


class CharConstantNode : public Node {
public:
  CharConstantNode(char val);
  void Generate3AC(std::vector<std::string>& vector );

private:
  char value;
};


class FloatingConstantNode : public Node {
public:
  FloatingConstantNode(long double val);
  void Generate3AC(std::vector<std::string>& vector );

private:
  long double value;
};


class IterationNode : public Node {
public:
  IterationNode();
  IterationNode(bool post_check);
  void Generate3AC(std::vector<std::string>& vector );

private:
  bool is_post_check;
};

class SelectionNode : public Node {
public:
  SelectionNode();
  void Generate3AC(std::vector<std::string>& vector );
};

}
#endif // ABSTRACT_SYNTAX_TREE_NODE_H_
