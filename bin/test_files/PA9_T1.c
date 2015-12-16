// This file shows phases
// 1) declaring constants/types and variables, including arrays
// 2) simple assignments
// 5) generating code for the array accesses and operations
// This file will also show type cohersion.
int i;
int j[10][10];


int main() {
  i = 20;
  j[1][1] = i;
  i = j[0][0];
}