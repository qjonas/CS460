int** MatrixMult(int **array_1, int **array_2, int row, int col) {
  int i, j;
  int **ret;
  for(i = 0; i < row; i++) {
    for(j = 0; j < col; j++) {
      ret[i][j] = array_1[i][j] * array_2[i][j];
    }
  }
  return ret;
}