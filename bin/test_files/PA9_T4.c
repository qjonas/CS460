// This shows three address matrix addition;

int main() {
  float i[100][100][100];
  float n[100][100][100];

  int j;
  int k;
  int l;
  for(j = 1; j < 100; j = j +1) {
    for(k = 1; k < 100; k = k +1) {
      for(l = 1; l < 100; l = l +1) {
        n[j][k][l] = i[j][k][l] + n[j][k][l];
      }
    }
  }
}