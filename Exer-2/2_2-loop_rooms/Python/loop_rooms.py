import sys

f = open(sys.argv[1], 'r')
n, m = map(int,f.readline().split())
arr = [[0 for k in range(m)] for _ in range(n)]
current=set()
exit=set()
nexit=set()
for i in range(n):
    c = list(f.readline())
    for j in range(m):
        curr = i*m + j
        s=c[j]
        if (s=='U'):
            if (i==0):
                arr[i][j]= -1
                exit.add((i,j))
            else: arr[i][j]= curr -m
        elif (s=='D'):
            if (i==n-1):
                arr[i][j]= -1
                exit.add((i,j))
            else: arr[i][j]= curr +m
        elif (s=='R'):
            if (j==m-1):
                arr[i][j]= -1
                exit.add((i,j))
            else: arr[i][j]= curr +1
        else:
            if (j==0):
                arr[i][j]= -1
                exit.add((i,j))
            else: arr[i][j]= curr -1

for k in range(n):
    for l in range(m):
        i,j = k,l
        current=set()
        while 1:
            if (i,j) in current :
                for (I,J) in current : nexit.add((I,J))
                break
            if (i,j) in exit :
                for (I,J) in current : exit.add((I,J))
                break
            if (i,j) in nexit :
                for (I,J) in current : nexit.add((I,J))
                break
            current.add((i,j))
            i,j = arr[i][j] // m , arr[i][j] % m
#print([x for x in nexit])
print(sum([1 for x in nexit]))