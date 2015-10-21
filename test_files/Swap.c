int swap(int *i, int *j) {
  int temp;
  temp = *i;
  *i = *j;
  *j = temp;
}

int bubblesort(int arr[], int size) {
  int i, j, temp;
  for(i = 0; i < size - 1; i++) {
    for(j = 0; j < size - 1; j++) {
      if (arr[j] > arr[j+1]) {
        swap(&arr[j], &arr[j+1]);
      }
    }
  }
}