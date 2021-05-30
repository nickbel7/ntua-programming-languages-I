#include <iostream>
#include <fstream>
#include <bits/stdc++.h>
#include <vector>

using namespace std;

int m, n, *arr, *arrDiff;
pair<int, int> *prefixDiff;

bool compare(const pair<int, int>& a, const pair<int, int>& b)
{
    if (a.first == b.first)
        return a.second < b.second;

    return a.first < b.first;
}

int main(int argc, char *argv[]) {
  // READ DATA FROM FILE
  ifstream inFile;
  // inFile.open("./test11.txt");
  inFile.open(argv[1]);
  if (!inFile) {
    cerr << "Error: could not read file";
    exit(1);
  }
  inFile >> m; //NUMBER OF DAYS
  inFile >> n; //NUMBER OF HOSPITALS
  arr = new int[m]; //HOSPITAL BEDS DAILY DIFFERENCE (f')
  arrDiff = new int[m+1]; //HOSPITAL TOTAL BEDS EVERY DAY (f)
  arrDiff[0] = 0; 
  vector<pair<int, int>> prefixDiff; //PREFIX ARRAY WITH INDEXES
  prefixDiff.push_back({0, 0});
  int sum = 0;

  for (int i=0 ; i<m ; i++) {
    inFile >> arr[i];
    arrDiff[i+1] = arr[i] + n;
    sum += arrDiff[i+1];
    prefixDiff.push_back({sum, i+1});
  }

  //SORT PREFIX ARRAY WITH INDEXES
  sort(prefixDiff.begin(), prefixDiff.end(), compare);
  int prefixParity[m+1] = {0};
  int maxLen = 0;
  int parityIndex = m; //POSITION OF FURTHEST SMALLER NUMBER 
  for (int i=m ; i>=0 ; i--) {
    maxLen = max(parityIndex - prefixDiff[i].second, maxLen);
    prefixParity[prefixDiff[i].second] = 1;
    while (prefixParity[parityIndex] == 1) {
      parityIndex --;
    }
  }
  cout << maxLen << endl;
  inFile.close();
}
