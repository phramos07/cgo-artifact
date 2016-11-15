#include <time.h>
#include <stdio.h>
#include <stdlib.h>

void prefix_sum_chal(int* v, int N) {
  int i, j;
  assume(N>0);
  for (i = 0; i < N; i++) {
    v[i] = 0;
    for (j = i + N; j < 2 * N; j++) {
      v[i] += v[j]; // Can we disambiguate pointers here?
    }
  }
} 
