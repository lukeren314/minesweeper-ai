from NeuralNetwork import NeuralNetwork
import random, time
class Game:
    def __init__(self,dimensions,mines,ai=False,nn=None):
        self.d=dimensions
        self.m=mines
        self.complete=False
        self.ai=ai
        self.board=[]
        for i in range(dimensions[0]):
                self.board[i]=[]
                for j in range(dimensions[1]):
                    self.board[i][j]=-1
        self.mines=[]
        random.seed(time.time())
        for mine in range(mines):
            coordinate = (random.randint(0,dimensions[0]),random.randrange(0,dimensions[1]))
            while coordinate in self.mines:
                coordinate = (random.randint(0,dimensions[0]),random.randrange(0,dimensions[1]))
            self.mines.append(coordinate)
        
        if nn:
            self.nn=nn
        else:
            nn=NeuralNetwork(dimensions,mines,self.board)
    def pick(self,coordinate):
        if coordinate in self.mines:
            self.complete=True
            #lose
        elif self.board[coordinate[0]][coordinate[1]] > -1:
            None
            #picked revealed tile
        else:
            self.clear(coordinate)
            count = 0
            for row in self.board:
                for column in row:
                    if column == -1:
                        count += 1
            if count == len(self.mines):
                self.complete=True
                #win
            else:
                None
                #picked new tile
    def clear(self,coordinate):
        x,y = coordinate
        if coordinate not in self.mines and x > -1 and x < self.d[0] and y > -1 and y < self.d[1]:
            if self.board[x][y] < 0:
                x = min(x,self.d[0]-1)
                x = max(x,0)
                y = min(y,self.d[1]-1)
                y = max(y,0)
                num = 0
                for a in range(3):
                    for b in range(3):
                        if (x+a-1,y+b-1) in self.mines:
                            num+=1
                self.board[x][y] = num
                if num == 0:
                    for a in range(3):
                        for b in range(3):
                            self.clear((x+a-1,y+b-1))
    def move_mine(self,coordinate):
        new = (random.randint(0,self.d[0]),random.randint(0,self.d[1]))
        while new in self.mines and new == coordinate:
            new = (random.randint(0,self.d[0]),random.randint(0,self.d[1]))
        self.mines.remove(coordinate)
        self.mines.append(new)
    def new_board(self):
        self.board=[]
        for i in range(self.d[0]):
                self.board[i]=[]
                for j in range(self.d[1]):
                    self.board[i][j]=-1
        self.mines=[]
        random.seed(time.time())
        for mine in range(self.m):
            coordinate = (random.randint(0,self.d[0]),random.randrange(0,self.d[1]))
            while coordinate in self.mines:
                coordinate = (random.randint(0,self.d[0]),random.randrange(0,self.d[1]))
            self.mines.append(coordinate)
    def next(self,user=(0,0)):
        if self.ai:
            self.pick(self.nn.feedforward(self.board))
        else:
            self.pick(user)
            #GUI stuff