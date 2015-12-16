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

struct SymbolTable;

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
  virtual std::string Generate3AC(std::vector< std::vector<std::string> >& vector );

  // Generate Graphviz Code:
  void GenerateGraphviz(const std::string& file_name) const;
  void GenerateGraphvizHelper(std::ofstream& fout) const;

  // SymbolTable setter
  static void SetSymbolTable(SymbolTable* table);
  static void PushFrame();
  static void PopFrame();

  // SetIdentifierType
  void SetFloating();

  static int* LINE;

protected:
  static std::map<std::string, int> name_count_;
  static std::list<std::map<std::string, std::string> > identifier_to_temporary_;
  static TicketCounter temp_int_counter_;
  static TicketCounter temp_float_counter_;
  static TicketCounter temp_label_counter_;
  static TicketCounter temp_int_address_counter_;
  static TicketCounter temp_float_address_counter_;
  std::string name_;
  std::string id_;
  std::vector<Node*> children_;
  int line_number_;
};
}

// Forward declare.
struct SymbolInfo;

#include "../symbol_table/SymbolTable.h"

namespace AST {
class AdditiveNode : public Node {
public:
  AdditiveNode(bool is_add);
  std::string Generate3AC(std::vector< std::vector<std::string> >& vector );
  
private:
  bool is_addition;
};

class AddressToValueNode : public Node {
public:
  AddressToValueNode();
  std::string Generate3AC(std::vector< std::vector<std::string> >& vector );
};

class AssignmentNode : public Node {
public:
   enum AssignmentType {
    EQUALS, MUL, DIV, MOD, ADD, SUB, LEFT, RIGHT, AND, XOR, OR
  };

  // Constructors 
  AssignmentNode(AssignmentType type);
std::string Generate3AC(std::vector< std::vector<std::string> >& vector );
private:
  AssignmentType type;

};

class ArrayAccessNode : public Node {
public:
  ArrayAccessNode(SymbolInfo* symbol_info);
  std::string Generate3AC(std::vector< std::vector<std::string> >& vector );

private:
  // this will hold information about the symbol so we can calculate offset.
  SymbolInfo *info;
};

class CompoundStatementNode : public Node {
public:
  CompoundStatementNode();
  std::string Generate3AC(std::vector< std::vector<std::string> >& three_address_code_vec);
};

class DeclarationNode : public Node {
public:
  // Constructors 
  DeclarationNode(const std::list<SymbolInfo*>& infos);
  std::string Generate3AC(std::vector< std::vector<std::string> >& vector );

private:
  // SymbolInfo of the declaration
  std::list<SymbolInfo*> Id_infos;
};

class DeclarationSpecifierNode : public Node {
public:
  DeclarationSpecifierNode();
  std::string Generate3AC(std::vector< std::vector<std::string> >& vector );

};

class EqualityNode : public Node {
public:
  enum RelationalType {
    EQ, NE, LESS, GREATER, LE, GE
  };
  EqualityNode(RelationalType t);
  std::string Generate3AC(std::vector< std::vector<std::string> >& vector );

private:
  RelationalType type;
};

class ExpressNode: public Node{
public:
  ExpressNode();
  ExpressNode(Node * child);
  std::string Generate3AC(std::vector< std::vector<std::string> >& vector );
};

class IdentifierNode: public Node{
public:
  // constructor
  IdentifierNode(SymbolInfo * id);
  std::string Generate3AC(std::vector< std::vector<std::string> >& vector );
  void SetFloating();

private:
  SymbolInfo* Id_info;
};

class IntegerConstantNode : public Node {
public:
  IntegerConstantNode(long long int val);
  std::string Generate3AC(std::vector< std::vector<std::string> >& vector );

private:
  long long int value;
};


class CharConstantNode : public Node {
public:
  CharConstantNode(char val);
  std::string Generate3AC(std::vector< std::vector<std::string> >& vector );

private:
  char value;
};


class FloatingConstantNode : public Node {
public:
  FloatingConstantNode(long double val);
  std::string Generate3AC(std::vector< std::vector<std::string> >& vector );

private:
  long double value;
};


class IterationNode : public Node {
public:
  IterationNode();
  IterationNode(bool post_check);
  std::string Generate3AC(std::vector< std::vector<std::string> >& vector );

private:
  bool is_post_check;
};

class SelectionNode : public Node {
public:
  SelectionNode();
  std::string Generate3AC(std::vector< std::vector<std::string> >& vector );
};

class FloatToIntNode : public Node {
public:
  FloatToIntNode(Node * node);
  std::string Generate3AC(std::vector< std::vector<std::string> >& vector );
};

class IntToFloatNode : public Node {
public:
  IntToFloatNode(Node * node);
  std::string Generate3AC(std::vector< std::vector<std::string> >& vector );
};

}
#endif // ABSTRACT_SYNTAX_TREE_NODE_H_
