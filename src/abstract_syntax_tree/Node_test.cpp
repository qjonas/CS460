#include <fstream>

#include "Node.h"

using namespace std;
using namespace AST;

int main() {
  // Testing if graphiz graph works.
  Node* node_1 = new Node("token_a");
  Node* node_2 = new Node("token_b");
  Node* node_3 = new Node("token_c");
  Node* node_5 = new Node("token_a");
  Node* node_4 = new Node("token_a");
  Node* node_6 = new Node("token_a");
  Node* node_7 = new Node("token_a");
  Node* node_8 = new Node("token_a");
  Node* node_9 = new Node("token_a");
  Node* node_10 = new Node("token_a");
  Node* node_11 = new Node("token_a");
  Node* node_12 = new Node("token_a");
  Node* node_13 = new Node("token_a");
  Node* node_14 = new Node("token_a");

  node_1->AddChild(node_2);
  node_1->AddChild(node_3);
  node_3->AddChild(node_4);
  node_1->AddChild(node_5);
  node_5->AddChild(node_6);
  node_6->AddChild(node_7);
  node_7->AddChild(node_8);
  node_8->AddChild(node_9);
  node_9->AddChild(node_10);
  node_10->AddChild(node_11);
  node_11->AddChild(node_12);
  node_12->AddChild(node_13);
  node_9->AddChild(node_14);


  ofstream fout("AST.dot");

  fout << "digraph AST {" << endl;

  node_1->GenerateGraphvizCode(fout);

  fout << "}";

  // system("rm AST.dot");

  fout.close();
}