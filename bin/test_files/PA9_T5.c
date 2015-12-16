// This shows bubble sort!
int main() {
  int arr[100];
  int size;
  int i;
  int j;
  int temp;
  size = 100;
  for(i = 0; i < size; i = i + 1) {
    for(j = 0; j < size - 1; j = j + 1) {
      if (arr[j] > arr[j + 1]) {
        temp = arr[j];
        arr[j] = arr[j+1];
        arr[j+1] = temp;
      }
    }
  }
}
