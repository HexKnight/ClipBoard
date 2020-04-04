"""
program: RL using Q-Learning and Temporal difference
using: Frozen Lake
author: Amine
version: 1
"""

from random import random, choice
from time import sleep
from math import exp
from os import system


up, down, left, right = 0, 1, 2, 3

actions = up, down, left, right

width, height = 10, 5

init_pos = 0, 0

state = list(init_pos)

goals = (9, 3),

obstacles = (2, 0), (0, 3), (5, 1), (5, 0), (4, 4), (4, 0),

traps = (5, 2), (1, 3), (7, 4), (4, 1),

alpha = lambda x: 0 if x >= 500 else 2 / (1 + exp(x / 3)) # leaning rate function

gamma = lambda : 1#x: 2 / (1 + exp(x)) # discount rate function

nu = lambda x: random() >= 2 / (1 + exp(x * 500)) # exploration exploitation trade off function (bigger == more exploitation)


# Initializing the enviroment
env = [[{"reward": 0, "sprite": " "} for j in range(height)] for i in range(width)]

# Removing the actions that are adjacent to the edge
for x in range(width):
	for y in range(height):
		env[x][y]["actions"] = list(actions)
		if x == 0:
			env[x][y]["actions"].remove(left)
		elif x == width-1:
			env[x][y]["actions"].remove(right)
		if y == 0:
			env[x][y]["actions"].remove(up)
		elif y == height-1:
			env[x][y]["actions"].remove(down)
# Removing the actions that are adjacent to obstacles
for x, y in obstacles:
	env[x][y]["actions"] = []
	try:
		env[x-1][y]["actions"].remove(right)
	except (Exception):
		pass
	try:
		env[x+1][y]["actions"].remove(left)
	except Exception:
		pass
	try:
		env[x][y+1]["actions"].remove(up)
	except Exception:
		pass
	try:
		env[x][y-1]["actions"].remove(down)
	except Exception:
		pass

# Setting the sprite of the agent
env[init_pos[0]][init_pos[1]]["sprite"] = "▮"
# Setting the reward and the sprite all the goals
for x, y in goals:
	env[x][y]["reward"] = 1
	env[x][y]["sprite"] = "G"
# Setting the sprite of all the obstacles
for x, y in obstacles:
	env[x][y]["sprite"] = "#"
# Setting the penalty and the sprite of all the traps
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

# Clear the enviroment
def clear_env():
	env[init_pos[0]][init_pos[1]]["sprite"] = "■"
	for x, y in goals:
		env[x][y]["sprite"] = "G"
	for x, y in traps:
		env[x][y]["sprite"] = "X"


# The functions that access the Q table and returns the Q value
def Q(state_x, state_y, action):
	return Qtable[state_x][state_y][action]


# Updating the Q table with the Temporal difrenece equation
def update_Q(pre_state, action):
	Q_value = Qtable[pre_state[0]][pre_state[1]][action] # current Q-value
	n = Qtable[pre_state[0]][pre_state[1]]["n"] # times state visited
	reward = env[state[0]][state[1]]["reward"] # the reward of the new state observed by the agent
	max_next = Qtable[state[0]][state[1]][best_action()] # maximum estimated Q-value in the new state
	# Temporal Difference algorithm
	Q_value += alpha(n) * (reward + gamma() * max_next - Q_value)
	# update the Q-table
	Qtable[pre_state[0]][pre_state[1]][action] = Q_value


# A function that returns the best action at current state
def best_action():
	action = 0
	action_q = 0
	for i in env[state[0]][state[1]]["actions"]:
			if Q(state[0], state[1], i) >= action_q:
				action = i
				action_q = Q(state[0], state[1], i)
	return action

# Returns whether is the current state terminal or not
def is_state_terminal():
	return env[state[0]][state[1]]["reward"] != 0


# Move the Agent according to exp-exp trade off and retun the action
def move():
	action = 0

	n = 0.0
	for a in env[state[0]][state[1]]["actions"]:
		n += abs(Qtable[state[0]][state[1]][a])
	n /= len(env[state[0]][state[1]]["actions"])

	if nu(n): # take the action with the highest Q value
		action = best_action()
	else: # take a random action 
		action = choice(env[state[0]][state[1]]["actions"])
	# remove the agent from old state
	env[state[0]][state[1]]["sprite"] = "S" if tuple(state) == init_pos else " "
	# follow the action and go to new state
	if action == up:
		state[1] -= 1
	elif action == down:
		state[1] += 1
	elif action == left:
		state[0] -= 1
	elif action == right:
		state[0] += 1
	# increase n
	Qtable[state[0]][state[1]]["n"] += 1
	# put the agent to the new state
	env[state[0]][state[1]]["sprite"] = "■"

	return action


""" The Implementation: """

pre_state = []
action = 0
learning_time = 0

while True:

	system('clear')
	show_env()

	if is_state_terminal():
		print("Agent has ", "WON" if env[state[0]][state[1]]["reward"] > 0 else "LOST")
		print("Starting a new episode..")
		learning_time -= 1
		state = list(init_pos)
		clear_env()
		sleep(.4)

	system('clear')
	show_env()

	pre_state = list(state)

	action = move()

	update_Q(pre_state, action)

	if learning_time <= 0:
		try:
			learning_time = int(input('Enter how many time should the A.I learn!\nOr just press ENTER to continue!\n[in]: '))
		except Exception:
			pass

