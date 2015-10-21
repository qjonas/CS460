int factorial(int i);
int factorial(int i) {
  if(i <= 1) return 1;
  return i * factorial(i-1);
}