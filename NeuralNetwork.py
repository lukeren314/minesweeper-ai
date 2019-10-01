class NeuralNetwork:
    def __init__(self,dimensions,m,board=None):
        self.d=dimensions
        self.m=m
        self.fitness=fitness
        if board:
            self.board=board
        else:
            self.board=[]
            for i in range(self.d[0]):
                self.board[i]=[]
                for j in range(self.d[1]):
                    self.board[i][j]=0
        self.n=[]
        self.w=[[]]
        self.b=[]
    def feedforward(self,board_state):

    def mutate(self,learning_rate):

    def calculate_fitness(self,board_state):
        
    def mate(nn1,nn2):

    

