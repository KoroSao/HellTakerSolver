from collections import namedtuple
from pprint import *

Action = namedtuple('action',('verb','direction'))
State = namedtuple('state', ('pusher','boxes'))
MapRules = namedtuple('maprules', ('goals','walls'))

actions = {d : Action('move',d) for d in 'udrl'} | {d.upper() : Action('push',d) for d in 'udrl'}

def mapReader(filename, debug = False):
    with open(filename, "r") as f:
        data = f.readlines()
    if debug:
        print(data)
    
    walls = []    #Walls
    targets = []  #Boxes targets
    pusher = []   #Initial position of the pusher
    boxes = []    #Initial coordinates of the boxes
    for i,elt in enumerate(data):
        for j,case in enumerate(elt):
            if debug: print(i,j,case)
            if case == '#':
                walls.append((i,j))
            elif case == '@':
                pusher = (i,j)
            elif case == "$":
                boxes.append((i,j))
            elif case == "*":
                targets.append((i,j))
            elif case == "%":
                boxes.append((i,j))
                targets.append((i,j))
    
    MR = MapRules(set(targets), frozenset(walls))   
    s0 = State( pusher, frozenset(boxes))
    
    def free(position) :
        return not(position in map_rules.walls)
    
    def goals(state) :
        return state.boxes == MR.goals
    
    def succ(state) :
        l = [(do_fn(actions[a],state),a) for a in actions]
        return {x : a for x,a in l if x}

    return s0, MR, free, goals, succ

def one_step(position, direction) :
    i, j = position
    return {'r' : (i,j+1), 'l' : (i,j-1), 'u' : (i-1,j), 'd' : (i+1,j)}[direction]


def do_fn(action, state) :
    X0 = state.pusher
    boxes = state.boxes
    X1 = one_step(X0, action.direction)
    if action.verb == 'move' :
        if free(X1) and not (X1 in boxes) :
            return State( X1, frozenset(boxes))
        else :
            return None
    if action.verb == 'push' :
        X2 = one_step(X1, action.direction)
        if X1 in boxes and free(X2) and not (X2 in boxes) :
            return State(X1, frozenset({X2} | boxes - {X1}))
        else :
            return None
    return None



def insert_tail(s, l):
    l.append(s)
    return l

def remove_head(l):
    return l.pop(0), l

def remove_tail(l):
    return l.pop(), l

def dict2path(s, d):
    l = [(s,None)]
    while not d[s] is None:
        parent, a = d[s]
        l.append((parent,a))
        s = parent
    l.reverse()
    return l

def search_with_parent(s0, goals, succ, remove, insert, debug=False) :
    l = [s0]
    save = {s0: None}
    s = s0
    while l:
        if debug:
            print("l =", l)
        s, l = remove(l)
        for s2,a in succ(s).items():
            if not s2 in save:
                save[s2] = (s,a)
                if goals(s2):
                    return s2, save
                insert(s2, l)
    return None, save

s0, map_rules, free, goals, succ = mapReader("map.txt")

s_end, save = search_with_parent(s0, goals, succ, remove_head, insert_tail)

plan = ''.join([a for s,a in dict2path(s_end,save) if a])

print(plan)

