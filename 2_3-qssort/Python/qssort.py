import sys
from collections import deque

# READ INPUT FROM FILE
fileName = sys.argv[1]

arr = []
with open(fileName) as f:
    next(f).split()
    arr = ([int(x) for x in next(f).split()])

print(arr)
arr_sorted = arr.copy()
arr_sorted.sort()

init = (arr, [])

# move_options = frozenset({'Q', 'S'})
# for option in move_options:
#     print(option)

# config(list, stack, path)
# MOVES GENERATORS
# POP MOVE
def move_Q(old_config):
    first_elem = old_config[0][0] #take first element of list
    new_list = old_config[0][1:] #take stack and add first element
    new_stack = old_config[1] + [first_elem] #add letter to path
    new_path = old_config[2] + ['Q']
    new_config = (new_list, new_stack, new_path)
    yield(new_config)

# PUSH MOVE
def move_S(s):
    first_elem = old_config[1][-1] #take last element from stack
    new_list = old_config[0] + [first_elem] #take list and add popped element
    new_stack = old_config[1][:-1] #add letter to path
    new_path = old_config[2] + ['S']
    new_config = (new_list, new_stack, new_path)
    yield(new_config)

StateArr = deque([init]) #Initialize state array
prev = {} # Dictionary of visited states

solved = False
print(arr)
print(arr_sorted)
if (arr == arr_sorted):
    print('empty')
else:
    print('still works')





# init =
