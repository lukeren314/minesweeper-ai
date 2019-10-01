import random, time, math
class Matrix:
    def __init__(self,dimensions,array=None,zero=True)
        self.d = dimensions
        if array:
            self.a=array
        else:
            for i in range(self.d[0]):
                self.a[i]=[]
                for j in range(self.d[1]):
                    if zero:
                        self.a[i][j]=0
                    else:
                        self.a[i][j]=random.random()
    def add(m1,m2):
        if isinstance(m2,Matrix):
            new_m = []
            if m1.d==m2.d:
                for i in range(m1.d[0]):
                    new_m[i]=[]
                    for j in range(m1.d[1]):
                        new_m[i][j]=m1.a[i][j]+m2.a[i][j]
            else:
                print("ERROR: {}" % "dimension mismatch")
            return Matrix(m1.d,new_m)
        else:
            new_m = []
            for i in range(m1.d[0]):
                    new_m[i]=[]
                    for j in range(m1.d[1]):
                        new_m[i][j]=m1.a[i][j]+m2
            return Matrix(m1.d,new_m)
    def multiply(m1,m2):
        if isinstance(m2,Matrix):
            new_m = []
            if m1.d==m2.d:
                for i in range(m1.d[0]):
                    new_m[i]=[]
                    for j in range(m1.d[1]):
                        new_m[i][j]=m1.a[i][j]*m2.a[i][j]
            else:
                print("ERROR: {}" % "dimension mismatch")
            return Matrix(m1.d,new_m)
        else:
            new_m = []
            for i in range(m1.d[0]):
                    new_m[i]=[]
                    for j in range(m1.d[1]):
                        new_m[i][j]=m1.a[i][j]*m2
            return Matrix(m1.d,new_m)
    def sigmoid(m):
        new_m = []
        for i in range(m1.d[0]):
            new_m[i]=[]
            for j in range(m1.d[1]):
                new_m[i][j]=1/(1+math.exp(-m1.a[i][j]))
        return(Matrix(m.d,new_m))
    def transpose(m):
        new_m = []
        for i in range(m.d[1]):
            new_m[i]=[]
            for j in range(m.d[0]):
                new_m[i][j]=m[j][i]
        return(Matrix((m.d[1],m.d[0]),new_m))
    def mm(m1,m2):
        if m1.d[0]==m2.d[1]:
            new_m = []
            for i in range(m2.d[0]):
                new_m[i] = []
                for j in range(m1.d[1]):
                    new_m[i][j] = m1.a[i][j]*m2.a[j][i]
            return(Matrix((m2.d[0],m1.d[1]),new_m))
        else:
            print("ERROR: {}" % "dimension mismatch")
        