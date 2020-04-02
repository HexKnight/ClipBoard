"""
program: RL using Q-Learning and Temporal difference
using: Frozen Lake
author: Amine
version: 1
"""

from itertools import count
from random import randint


up, down, left, right = 0, 1, 2, 3

actions = up, down, left, right

width, height = 5, 4

init_pos = 0, 0

goal = 4, 3

obstacles = (2, 0), (0, 3)

traps = (3, 2), (1, 3)

# Initializing the enviroment
env = [[{"reward": 0, "sprite": " "} for j in range(height)] for i in range(width)]
# Limitting the available actions according to each tile's position
for x in range(width):
	for y in range(height):
		env[x][y]["actions"] = actions
		# Removing the actions that are adjacent to the edge
		if x == 0:
			env[x][y]["actions"] = up, down, right
		elif x == width-1:
			env[x][y]["actions"] = up, down, left
		if y == 0:
			env[x][y]["actions"] = down, left, right
		elif y == height-1:
			env[x][y]["actions"] = up, left, right
		# Removing the actions that are adjacent to obstacles
		pass
# Setting the sprite the agent
env[init_pos[0]][init_pos[1]]["sprite"] = "A"
# Setting the reward and the sprite the goal
env[goal[0]][goal[1]]["reward"] = 1
env[goal[0]][goal[1]]["sprite"] = "G"
# Setting the sprite of all the obstacles
for x, y in obstacles:
	env[x][y]["sprite"] = "#"
# Setting the reward and the sprite of all the traps
for x, y in traps:
	env[x][y]["reward"] = -1
	env[x][y]["sprite"] = "X"

# Initializing the Q table
Qtable = [[{action: 0.0 for action in env[x][y]["actions"]} for y in range(height)] for x in range(width)]
# Initializing the n field of the Q table
for x in range(width):
	for y in range(height):
		Qtable[x][y]["n"] = 0.0

# The function that shows the enviroment in the console
def show_env():
	print('+', ('-+'*width)[:-1], '+', sep='')
	for i in range(height):
		print('|', end='')
		for j in range(width):
			print(env[j][i]["sprite"], '|', sep='', end='')
		print('\n+', '-+'*width, sep='')

# The functions that access the Q table and returns the Q value
def Q(state_x, state_y, action):
	return Qtable[state_x][state_y][action]

# Updating the Q table with the Temporal difrenece equation
def update_Q():
	pass


show_env()

print(Qtable[0])