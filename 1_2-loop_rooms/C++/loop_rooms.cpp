#include <iostream>
#include <cstdio>
using namespace std;

int **arr;
bool *b;
int *newarr;
int newc=0, count=0, l=0;

// INPUT DATA READ
int main(int argc, char *argv[]) {
  FILE *f;
  if ((f = fopen(argv[1], "rt")) == nullptr) return 1;
  //N M
  int n, m;
  fscanf(f, "%d %d", &n, &m);
  //ARRAY OF N*M ELEMENTS
  arr = new int*[n];
  for(int i=0; i<n; ++i)
    {
        arr[i] = new int[m];
    }
  b = new bool[n*m];
  newarr = new int[n*m];
  char c;
  for (int i =0 ; i<n ; i++){
    for (int j=0 ; j<m ; j++){
      int curr= i*m +j;
      if ((c = fgetc(f)) == '\n') c = fgetc(f);
      switch(c) {
        case 'U' : {
            if(i==0) arr[i][j] = -1;
            else arr[i][j] = curr -m ;
            break;
        }
        case 'D' : {
            if (i==n-1) arr[i][j] = -1;
            else arr[i][j] = curr + m;
            break;
          }
        case 'R' : {
            if (j==m-1) arr[i][j] = -1;
            else arr[i][j] = curr + 1;
            break;
          }
        case 'L' : {
            if (j==0) arr[i][j] = -1;
            else arr[i][j] = curr -1;
            break;
          }
      }
    }
  }

  int ol = m*n ;
  for (int i =0 ; i<n ; i++){
    for (int j=0 ; j<m ; j++){
      newarr[newc] = arr[i][j];
      b[newc] = false;
      newc++;
    }
  }

  int k = ol - 1;
  bool check;

  do {
    check = false;
    l = 0;
    k = ol - 1;
    while(l<ol) {
        if(newarr[l]==-1 && b[l]==false){
          b[l]=true;
          l++;
          continue;
        }
        if(newarr[newarr[l]] == -1){
          check = true;
          newarr[l]=-1;
        }
        l++;
    }
    while(k>-1) {
        if(newarr[k]==-1 && b[k]==false){
          b[k]=true;
          k--;
          continue;
        }
        if(newarr[newarr[k]] == -1){
          check = true;
          newarr[k]=-1;
        }
        k--;
    }
  }
  while(check);

  for(int i=0; i<ol;i++){
    if(b[i]==true) count++;
    else continue;
  }
  cout << ol-count << endl;
  return 0;
}
