import sys
import resource
import time
from collections import namedtuple
from helltaker_utils import grid_from_file, check_plan


State = namedtuple(
    "state", ("pusher", "boxes", "skeletons", "chests", "keys", "hasKey", "nbMove", "t")
)
MapRules = namedtuple(
    "maprules",
    ("goals", "waifu", "walls", "traps", "even_traps", "odd_traps", "max_move"),
)
actions = {d: d for d in "hbdg"}


def insert_tail(s, l):
    """Insert en fin de liste"""
    l.append(s)
    return l


def remove_head(l):
    """Retire en tête de liste"""
    return l.pop(0), l


def remove_tail(l):
    """Retire en fin de liste"""
    return l.pop(), l


def dict2path(s, d):
    """Transforme un dictionnaire en une liste de mouvements"""
    l = [(s, None)]
    while not d[s] is None:
        parent, a = d[s]
        l.append((parent, a))
        s = parent
    l.reverse()
    return l


def search_with_parent(s_0, goals, succ, remove, insert):
    """Recherche dans un espace d'etat avec sauvegarde des etats parents"""
    i = 0
    l = [s_0]
    save = {s_0: None}
    s = s_0
    while l:
        s, l = remove(l)
        for s_2, a in succ(s).items():
            i += 1
            if not s_2 in save:
                save[s_2] = (s, a)
                if goals(s_2):
                    print(f"Wow, {i} etats parcourus !")
                    return s_2, save
                insert(s_2, l)

    print(f"Wow, {i} etats parcourus !")
    return None, save

def manhattan(a, b):
    return sum(abs(val1-val2) for val1, val2 in zip(a,b))



def monsuperplanificateur(infos):
    """Planificateur de l'IA"""

    def factory(grid, max_steps):
        """
        Design pattern Factory
        Lit la grille et retourne les règles de la grille
        Retourne les méthodes succ, goals, walls, traps, even_traps, odd_traps
        """
        walls = []  # Walls
        targets = []  # Waifu targets
        pusher = ()  # Initial position of the pusher
        boxes = []  # Initial coordinates of the boxes
        skeletons = []  # Initial coordinates of the skeletons
        traps = []  # Non-moving traps in map
        chest = []
        key = []
        even_traps = []
        odd_traps = []
        for i, elt in enumerate(grid):
            for j, case in enumerate(elt):
                if case == "#":
                    walls.append((i, j))
                elif case == "H":
                    pusher = (i, j)
                elif case == "B":
                    boxes.append((i, j))
                elif case == "D":
                    targets.append((i, j))
                elif case == "M":
                    skeletons.append((i, j))
                elif case == "S":
                    traps.append((i, j))
                elif case == "O":
                    traps.append((i, j))
                    boxes.append((i, j))
                elif case == "L":
                    chest.append((i, j))
                elif case == "K":
                    key.append((i, j))
                elif case == "T":
                    if (max_steps % 2) == 0:
                        odd_traps.append((i, j))
                    else:
                        even_traps.append((i, j))
                elif case == "U":
                    if (max_steps % 2) != 0:
                        odd_traps.append((i, j))
                    else:
                        even_traps.append((i, j))
                elif case == "P":
                    boxes.append((i, j))
                    if max_steps % 2 == 0:
                        odd_traps.append((i, j))
                    else:
                        even_traps.append((i, j))
                elif case == "Q":
                    boxes.append((i, j))
                    if max_steps % 2 != 0:
                        odd_traps.append((i, j))
                    else:
                        even_traps.append((i, j))

        s_0 = State(
            pusher,
            frozenset(boxes),
            frozenset(skeletons),
            frozenset(chest),
            frozenset(key),
            False,
            max_steps,
            0,
        )

        if len(key) == 0:
            key_position = [end_positions[0]]
        else:
            key_position = key[0]

        end_positions = []
        for waifu in targets:
            if (waifu[0] + 1, waifu[1]) not in walls:
                end_positions.append((waifu[0] + 1, waifu[1]))
            if (waifu[0] - 1, waifu[1]) not in walls:
                end_positions.append((waifu[0] - 1, waifu[1]))
            if (waifu[0], waifu[1] + 1) not in walls:
                end_positions.append((waifu[0], waifu[1] + 1))
            if (waifu[0], waifu[1] - 1) not in walls:
                end_positions.append((waifu[0], waifu[1] - 1))

        map_rules = MapRules(
            frozenset(end_positions),
            frozenset(targets),
            frozenset(walls),
            frozenset(traps),
            frozenset(even_traps),
            frozenset(odd_traps),
            max_steps,
        )



        def on_even_trap(position):
            """Retourne vrai si la position est un trap paire"""
            return position in map_rules.even_traps

        def on_odd_trap(position):
            """Retourne vrai si la position est un trap impaire"""
            return position in map_rules.odd_traps

        def on_waifu(position):
            """Retourne vrai si la position est une waifu"""
            return position in map_rules.waifu

        def free(position):
            """Retourne vrai si la position est libre"""
            return not position in map_rules.walls

        def trapped(position):
            """Retourne vrai si la position est un trap"""
            return position in map_rules.traps

        def goals(state):
            """Retourne vrai si la position est une cible"""
            return state.pusher in map_rules.goals and state.nbMove >= 0

        def succ(state):
            """Retourne les successeurs d'un état"""
            l = [(do_fn(a, state), a) for a in actions.values()]
            return {x: a for x, a in l if x}

        def search_with_parent_heuristic(s_0, goals, succ, remove, insert):
            """Recherche dans un espace d'etat avec sauvegarde des etats parents"""
            i = 0
            save = {s_0: None}
            s_0 = (s_0, manhattan(s_0.pusher, end_positions[0]))
            l = [s_0]
            s = s_0
            while l:
                l.sort(key=lambda x: x[1])
                s, l = remove(l)
                for s_2, a in succ(s[0]).items():
                    i += 1
                    if not s_2 in save:
                        save[s_2] = (s[0], a)
                        if goals(s_2):
                            print(f"Wow, {i} etats parcourus !")
                            return s_2, save
                        insert((s_2, manhattan(s_2.pusher, end_positions[0])), l)

            print(f"Wow, {i} etats parcourus !")
            return None, save


        return s_0, free, goals, succ, trapped, on_waifu, on_even_trap, on_odd_trap, search_with_parent_heuristic, key_position

    def one_step(position, direction):
        """Retourne la position d'une case à partir d'une position et d'une direction"""
        i, j = position
        return {"d": (i, j + 1), "g": (i, j - 1), "h": (i - 1, j), "b": (i + 1, j)}[
            direction
        ]

    def do_fn(direction, state):
        """Calcule les successeurs valides d'un état"""
        if state.nbMove <= 0:
            return None
        x_0 = state.pusher
        boxes = state.boxes
        skeletons = state.skeletons
        keys = state.keys
        chests = state.chests
        t = state.t
        x_1 = one_step(x_0, direction)
        x_2 = one_step(x_1, direction)

        penalty = 0
        if trapped(x_0):
            penalty += 1
        if on_even_trap(x_1) and (t % 2 != 0):
            penalty += 1
        if on_odd_trap(x_1) and (t % 2 == 0):
            penalty += 1

        if free(x_1) and not x_1 in boxes and not x_1 in chests:
            if not x_1 in skeletons:
                if not x_1 in keys:
                    return State(
                        x_1,
                        frozenset(boxes),
                        frozenset(skeletons),
                        frozenset(state.chests),
                        frozenset(state.keys),
                        state.hasKey,
                        state.nbMove - 1 - penalty,
                        t + 1,
                    )

                return State(
                    x_1,
                    frozenset(boxes),
                    frozenset(skeletons),
                    frozenset(state.chests),
                    frozenset(state.keys - {x_1}),
                    True,
                    state.nbMove - 1 - penalty,
                    t + 1,
                )

            if free(x_2) and not x_2 in boxes and not x_2 in chests:
                if (on_even_trap(x_2) and t % 2 == 0) or (
                    on_odd_trap(x_2) and t % 2 != 0
                ):
                    return State(
                        x_0,
                        frozenset(boxes),
                        frozenset(skeletons - {x_1}),
                        frozenset(state.chests),
                        frozenset(state.keys),
                        state.hasKey,
                        state.nbMove - 1 - penalty,
                        t + 1,
                    )

                return State(
                    x_0,
                    frozenset(boxes),
                    frozenset({x_2} | skeletons - {x_1}),
                    frozenset(state.chests),
                    frozenset(state.keys),
                    state.hasKey,
                    state.nbMove - 1 - penalty,
                    t + 1,
                )

            return State(
                x_0,
                frozenset(boxes),
                frozenset(skeletons - {x_1}),
                frozenset(state.chests),
                frozenset(state.keys),
                state.hasKey,
                state.nbMove - 1 - penalty,
                t + 1,
            )

        if x_1 in boxes and not x_1 in chests and not x_2 in chests:
            if (
                free(x_2)
                and not x_2 in boxes
                and not x_2 in skeletons
                and not on_waifu(x_2)
            ):
                return State(
                    x_0,
                    frozenset({x_2} | boxes - {x_1}),
                    frozenset(skeletons),
                    frozenset(state.chests),
                    frozenset(state.keys),
                    state.hasKey,
                    state.nbMove - 1 - penalty,
                    t + 1,
                )
            return None

        if (x_1 in chests) and state.hasKey:
            return State(
                x_1,
                frozenset(boxes),
                frozenset(skeletons),
                frozenset(state.chests - {x_1}),
                frozenset(state.keys),
                state.hasKey,
                state.nbMove - 1 - penalty,
                t + 1,
            )

        if free(x_1):
            return State(
                x_0,
                frozenset(boxes),
                frozenset(skeletons),
                frozenset(state.chests),
                frozenset(state.keys),
                state.hasKey,
                state.nbMove - 1 - penalty,
                t + 1,
            )

        return None

    s_0, free, goals, succ, trapped, on_waifu, on_even_trap, on_odd_trap, search_with_parent_heuristic, key_position = factory(
        infos["grid"], infos["max_steps"]
    )
    print(key_position)
    #s_end, save = search_with_parent(s_0, goals, succ, remove_head, insert_tail)
    s_end, save = search_with_parent_heuristic(s_0, goals, succ, remove_head, insert_tail)

    plan = "".join([a for s, a in dict2path(s_end, save) if a])
    return plan


def main():
    """Programme principal"""
    # récupération du nom du fichier depuis la ligne de commande
    filename = sys.argv[1]

    # récupération de la grille et de toutes les infos
    infos = grid_from_file(filename)

    # calcul du plan
    plan = monsuperplanificateur(infos)

    # affichage du résultat
    if check_plan(plan):
        print("[OK]", plan)
    else:
        print("[Err]", plan, file=sys.stderr)
        sys.exit(2)


if __name__ == "__main__":
    start_time = time.time()
    main()
    print("--- %s seconds ---" % (time.time() - start_time))
     #print(resource.getrusage(resource.RUSAGE_SELF))

