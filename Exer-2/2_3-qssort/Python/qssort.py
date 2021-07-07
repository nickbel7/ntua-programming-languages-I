import sys
from collections import deque

# READ INPUT FROM FILE
# fileName = sys.argv[1]Σειρές_ασκήσεων\2_3-qssort\Python
fileName = 'qssort.in1'
arr = []
with open(fileName) as f:
    next(f)
    arr = [int(x) for x in next(f).split()]

print(arr)
arr_sorted = arr.copy()
arr_sorted.sort()

# INITIAL CONFIGURATION
# config(list, stack, path)
init = arr, [], []

# MOVES GENERATORS
# -------------------
# POP MOVE
def move_Q(old_config):
    first_elem = old_config[0][0] #take first element of list
    new_list = old_config[0][1:] #take stack and add first element
    new_stack = old_config[1] + [first_elem] #add letter to path
    new_path = old_config[2] + ['Q']
    new_config = (new_list, new_stack, new_path)
    yield (new_config)

# PUSH MOVE
def move_S(old_config):
    first_elem = old_config[1][-1] #take last element from stack
    new_list = old_config[0] + [first_elem] #take list and add popped element
    new_stack = old_config[1][:-1] #add letter to path
    new_path = old_config[2] + ['S']
    new_config = (new_list, new_stack, new_path)
    yield(new_config)

# PERFORM BFS TO FIND AN ELIGIBLE STATE
StateArr = deque([init]) #Initialize state array
# prev = {init : None} # Dictionary of visited states
solved = False
while StateArr:
    state = StateArr.popleft()
    if (state[0] == arr_sorted):
        solved = True
        print('found it')
        break
    else:
        if len(state[0]):
            for s in move_Q(state):
                StateArr.append(s)
        if (len(state[1])):
            if (len(state[0]) and state[0][0] == state[1][-1]):
                continue
            for s in move_S(state):
                StateArr.append(s)

if solved:
    print(''.join(state[2]))
