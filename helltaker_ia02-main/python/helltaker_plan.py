import sys
from helltaker_utils import grid_from_file, check_plan
from collections import namedtuple
from pprint import *

State = namedtuple('state', ('pusher','boxes','skeletons','chests','keys','hasKey','nbMove'))
MapRules = namedtuple('maprules', ('goals','waifu','walls','traps','evenTraps', 'oddTraps','max_move'))
actions = {d: d for d in 'hbdg'}


def insert_tail(s, l):
    l.append(s)
    return l

def remove_head(l):
    return l.pop(0), l

def remove_tail(l):
    return l.pop(), l

def remove2(l):
    return l.pop(), l

def insert2(s, l):
    return l.append(s)


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


def monsuperplanificateur(infos):
    def factory(grid, max_steps, debug = False):
        nb_allowed_move = max_steps #To read in file 
        walls = []    #Walls
        targets = []  #Waifu targets
        pusher = ()   #Initial position of the pusher
        boxes = []    #Initial coordinates of the boxes
        skeletons = []#Initial coordinates of the skeletons
        traps = []    #Non-moving traps in map
        chest = []
        key = []
        evenTraps = []
        oddTraps = []
        for i,elt in enumerate(grid):
            for j,case in enumerate(elt):
                if debug: print(i,j,case)
                if case == '#':
                    walls.append((i,j))
                elif case == 'H':
                    pusher = (i,j)
                elif case == "B":
                    boxes.append((i,j))
                elif case == "D":
                    targets.append((i,j))
                elif case == "M":
                    skeletons.append((i,j))
                elif case == "S":
                    traps.append((i,j))
                elif case == "O":
                    traps.append((i,j))
                    boxes.append((i,j))
                elif case == "L":
                    chest.append((i,j))
                elif case == "K":
                    key.append((i,j))
                elif case == "T":
                    if (max_steps %2) == 0:
                        oddTraps.append((i,j))
                    else:
                        evenTraps.append((i,j))
                elif case == "U":
                    if (max_steps %2) != 0:
                        oddTraps.append((i,j))
                    else:
                        evenTraps.append((i,j))
                # elif case == "P":
                #     boxes.append((i,j))
                #     if max_steps %2 == 0:
                #         oddTraps.append((i,j))
                #     else:
                #         evenTraps.append((i,j))
                # elif case == "Q":
                #     boxes.append((i,j))
                #     if max_steps %2 != 0:
                #         oddTraps.append((i,j))
                #     else:
                #         evenTraps.append((i,j))

        s0 = State( pusher, frozenset(boxes), frozenset(skeletons),frozenset(chest),frozenset(key), False, nb_allowed_move)
        
        
        end_positions = []
        for waifu in targets:
            if (waifu[0] + 1,waifu[1]) not in walls:
                end_positions.append((waifu[0] + 1,waifu[1]))
            if (waifu[0] - 1,waifu[1])  not in walls:
                end_positions.append((waifu[0] - 1,waifu[1]))
            if (waifu[0],waifu[1] + 1) not in walls:
                end_positions.append((waifu[0],waifu[1] + 1))
            if (waifu[0],waifu[1] - 1)  not in walls:
                end_positions.append((waifu[0],waifu[1] - 1))

        MR = MapRules(frozenset(end_positions), frozenset(targets), frozenset(walls), frozenset(traps), frozenset(evenTraps), frozenset(oddTraps), nb_allowed_move)   

        def on_evenTrap(position):
            return position in MR.evenTraps

        def on_oddTrap(position):
            return position in MR.oddTraps

        def on_waifu(position):
            return position in MR.waifu

        def free(position) :
            return not(position in MR.walls)

        def trapped(position):
            return position in MR.traps

        def goals(state) :
            return state.pusher in MR.goals and state.nbMove >= 0
        
        def succ(state) :
            l = [(do_fn(a,state),a) for a in actions.values()]
            return  {x : a for x,a in l if x}

        return s0, MR, free, goals, succ, trapped, on_waifu, on_evenTrap, on_oddTrap

    def one_step(position, direction) :
        i, j = position
        return {'d' : (i,j+1), 'g' : (i,j-1), 'h' : (i-1,j), 'b' : (i+1,j)}[direction]


    def do_fn(direction, state) :
        if state.nbMove <= 0:
            return None
        X0 = state.pusher
        boxes = state.boxes
        skeletons = state.skeletons
        keys = state.keys
        chests = state.chests
        X1 = one_step(X0, direction)
        X2 = one_step(X1, direction)

        penalty = 0
        if trapped(X0):
            penalty += 1
        if on_evenTrap(X1) and (state.nbMove%2==0):
            penalty += 1
        if on_oddTrap(X1) and (state.nbMove%2!=0):
            penalty += 1


        if free(X1) and not (X1 in boxes) and not(X1 in chests):
            if not (X1 in skeletons):
                if not (X1 in keys):
                    return State(X1, frozenset(boxes), frozenset(skeletons),frozenset(state.chests),frozenset(state.keys), state.hasKey, state.nbMove-1-penalty)
                else:
                    return State(X1, frozenset(boxes), frozenset(skeletons),frozenset(state.chests),frozenset(state.keys - {X1}), True, state.nbMove-1-penalty)

            else:
                if free(X2) and not (X2 in boxes) and not (X2 in chests):
                    if (on_evenTrap(X2) and state.nbMove%2==0) or (on_oddTrap(X2) and state.nbMove%2!=0):
                        return State(X0, frozenset(boxes), frozenset(skeletons - {X1}),frozenset(state.chests),frozenset(state.keys), state.hasKey, state.nbMove-1-penalty)
                    else:
                        return State(X0, frozenset(boxes), frozenset({X2} | skeletons - {X1}),frozenset(state.chests),frozenset(state.keys), state.hasKey, state.nbMove-1-penalty)
                else:
                    return State(X0, frozenset(boxes), frozenset(skeletons - {X1}),frozenset(state.chests),frozenset(state.keys), state.hasKey, state.nbMove-1-penalty)


        elif X1 in boxes and not(X1 in chests):
            if free(X2) and not (X2 in boxes) and not (X2 in skeletons) and not on_waifu(X2) and not (X2 in chests):
                return State(X0, frozenset({X2} | boxes - {X1}),frozenset(skeletons),frozenset(state.chests),frozenset(state.keys), state.hasKey, state.nbMove-1-penalty)

        elif (X1 in chests) and state.hasKey == True:
            return State(X1, frozenset(boxes), frozenset(skeletons),frozenset(state.chests - {X1}),frozenset(state.keys), state.hasKey, state.nbMove-1-penalty)


        elif free(X1):
            return State(X0, frozenset(boxes),frozenset(skeletons),frozenset(state.chests),frozenset(state.keys),state.hasKey, state.nbMove-1-penalty)
        else:
            return None

    s0, map_rules, free, goals, succ, trapped, on_waifu, on_evenTrap, on_oddTrap = factory(infos['grid'], infos['max_steps'])

    #print(map_rules)

    s_end, save = search_with_parent(s0, goals, succ, remove_head, insert_tail)

    #print(s_end)
    plan = ''.join([a for s,a in dict2path(s_end,save) if a])
    return plan


def main():
    # récupération du nom du fichier depuis la ligne de commande
    filename = sys.argv[1]

    # récupération de la grille et de toutes les infos
    infos = grid_from_file(filename)
    #print(infos['grid'])

    # calcul du plan
    plan = monsuperplanificateur(infos)

    # affichage du résultat
    if check_plan(plan):
        print("[OK]", plan)
    else:
        print("[Err]", plan, file=sys.stderr)
        sys.exit(2)


if __name__ == "__main__":
    main()