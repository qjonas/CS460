// This file shows phases
// 1) declaring constants/types and variables, including arrays
// 2) simple assignments
// 5) generating code for the array accesses and operations
// This file will also show type cohersion.
int main() {
  int i;
  float j;
  int k[100][20][5];
  i = i + j;
  j = j - i;

  k[10] = k[i];
  k[10][i] = k[i][10];
  k[12][2][3] = k[1][3][5];

}