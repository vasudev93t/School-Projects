import random
#Create the board
board = [x for x in range(0,9)]
def show():
    print(board[0],'|',board[1],'|', board[2])
    print('---------')
    print(board[3],'|',board[4],'|', board[5])
    print('---------')
    print(board[6],'|',board[7],'|', board[8])
    


#Check Winning Condition

def check():
    char = 'X'
    c = 0
    while c<2:
        for h in range(0,9,3):
            if (board[h] == char and board[h+1] == char and board[h+2] == char):
                print(char , 'wins')
                return True
        for v in range(0,3):
            if (board[v] == char and board[v+3] == char and board[v+6] == char):
                print(char , 'wins')
                return True
        for d in range(0,3,2):
            if d==0 and (board[d] == char and board[d+4] == char and board[d+8] == char):
                print(char , 'wins')
                return True
            if d==2 and (board[d] == char and board[d+2] == char and board[d+4] == char):
                print(char , 'wins')
                return True
        char = 'O'
        c += 1
        
#Get User Input
def user():
    global counter
    while True:
        a = int(input('Please input a number between 0 to 8:'))
        if board[a] != 'X' and board[a] != 'O':
            board[a] = 'X'
            counter += 1
            break
        else:
            print('Space is taken try again')

#Computers Turn
def computer():
    global counter
    while True:
        b = random.randint(0,8)
        if board[b] != 'X' and board[b] != 'O':
            board[b] = 'O'
            counter += 1
            print(counter,'moves')
            break
        

#Draw Check
def draw():
    if counter == 9:
        print('Game is a draw')
        return True
    
        
# The game

counter = 0
while True:
    show()
    user()
    if draw()== True:
        show()
        break
    computer()
    if check() == True:
        show()
        break
        
    



    

