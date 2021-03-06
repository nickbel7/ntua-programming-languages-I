m: ημερες
n: nosokomeia

min_rate = n*m

m = 5
n = 2
k = 2
n*k = 4
|sum| = [-3, |-2, -1|, 1, 2]

//paradeigma
m = 11
n = 3
----------
k = 5
n*k = 5*3 = 15
f' = [42, -10, 8, 1, 11, -6, -12, 16, -15, -11, 13]
fd'= [42,  -7,11, 4, 14, -3,  -9, 19, -12,  -8, 16]

// Step #1
//prefix sum (f) O(n)
f = [42, 32, 40, 41, 52, 46, 34, 50, 35, 24, 37] 0(n)
fd= [42, 35, 46, 50, 64, 61, 52, 71, 59, 51, 67]
i = [ 0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10]

fd_sorted = [35, 42, 46, 50, 51, 52, 59, 61, 64, 67, 71] 0(nlogn)
fd_index  = [ 2,  1,  3,  4, 10,  7,  9,  6,  5, 11,  8]

            [ 0,  0,  0,  0,  1,  0,  0,  1,  0,  0,  1]
k = 11-8 = 3
k = 10-5 = 5
// Step #2
// sort by prefix sum, index O(nlogn)
f = [24, 32, 34, 35, 37, 40, 41, 42, 46, 50, 52]
i = [ 9,  1,  6,  8, 10,  2,  3,  0,  5,  7,  4]

// Step #3
// minimum index value in range [0..i] O(n)
minInd = [9, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0]
// OR
maxInd = []

f = [42, 32, 40, 41, 52, 46, 34, 50, 35, 24, 37]




// What do we want
-sum[i, i+k] >= n*k

sum f'[a-b] = f[b]-f[a]
[1, 2, 1, 1, 1, |2, 3, 1, 1, ]

O(nlogn) -> logn -> binary search
Έστω οτι έχεις ένα array [1,10] -> άρα το max k είναι 10 και το min είναι 1
θα κάνουμε binary search στο k
δλδ ...
Έστω οτι k=5
k=7
k=6
