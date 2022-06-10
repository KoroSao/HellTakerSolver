import sys
import clingo
import resource


action_to_direction = {
    "push_droite": "d",
    "push_gauche": "g",
    "push_haut": "h",
    "push_bas": "b",
    "push_droite_s": "d",
    "push_gauche_s": "g",
    "push_haut_s": "h",
    "push_bas_s": "b",
    "droite": "d",
    "gauche": "g",
    "haut": "h",
    "bas": "b",
    "nop": '',
    "skip": ''
}


def asp_res_to_table(asp_encoded_problem, nb_coups):
    """
    asp_encoded_problem : ASP program to solve a unique level
    nb_coups : number of actions permitted by the game to solve the level
    """

    # ==========Launching ASP with the right parameter==========
    hor = f"horizon={nb_coups}"
    ctl = clingo.Control(["-c", hor])
    ctl.add("base", [], asp_encoded_problem)
    ctl.ground([("base", [])])
    # ctl.configuration.solve.models = "0"

    # ==========Getting all the models found by ASP==========
    models = []
    with ctl.solve(yield_=True) as handle:
        for model in handle:
            models.append(model.symbols(atoms=True))

    # ==========Getting the list of actions to solve the level==========
    glob = []
    for model in models:
        model_l = []
        for act in model:
            if act.match("do", 2):
                model_l.append(
                    str(act).split(sep="(")[1].split(sep=")")[0].split(sep=",")
                )
        for elt in model_l:
            elt[0] = int(elt[0])
        model_l = sorted(model_l, key=lambda x: x[0])

        # ==========Transforming the actions into letters for evaluation==========
        res = []
        for action in model_l:
            res.append(action_to_direction[action[1]])

        glob.append("".join(res))

    return glob


def map_reader(grid, nb_coups):
    """
    Encode the grid in ASP program
    """
    asp_enc = ""

    for i, elt in enumerate(grid):
        for j, case in enumerate(elt):
            if case == "H":
                asp_enc = "\n".join([asp_enc, f"fluent(me({i}, {j}), 0)."])
            if case == "D":
                asp_enc = "\n".join([asp_enc, f"goal(me({i-1}, {j}))."])
                asp_enc = "\n".join([asp_enc, f"goal(me({i+1}, {j}))."])
                asp_enc = "\n".join([asp_enc, f"goal(me({i}, {j-1}))."])
                asp_enc = "\n".join([asp_enc, f"goal(me({i}, {j+1}))."])
                asp_enc = "\n".join([asp_enc, f"wall({i}, {j})."])
            if case == "#":
                asp_enc = "\n".join([asp_enc, f"wall({i}, {j})."])
            if case == "B":
                asp_enc = "\n".join([asp_enc, f"fluent(box({i}, {j}), 0)."])
            if case == "M":
                asp_enc = "\n".join([asp_enc, f"fluent(skeleton({i}, {j}), 0)."])
            if case == "K":
                asp_enc = "\n".join([asp_enc, f"fluent(key({i}, {j}),0)."])
            if case == "L":
                asp_enc = "\n".join([asp_enc, f"fluent(lock({i}, {j}),0)."])
            if case == "S":
                asp_enc = "\n".join([asp_enc, f"spike({i}, {j})."])
            if case == "T":
                asp_enc = "\n".join([asp_enc, f"fluent(trapDown({i}, {j}),0)."])
            if case == "U":
                asp_enc = "\n".join([asp_enc, f"fluent(trapUp({i}, {j}),0)."])
            if case == "O":
                asp_enc = "\n".join([asp_enc, f"spike({i}, {j})."])
                asp_enc = "\n".join([asp_enc, f"fluent(box({i}, {j}), 0)."])
            if case == "P":
                asp_enc = "\n".join([asp_enc, f"fluent(box({i}, {j}), 0)."])
                asp_enc = "\n".join([asp_enc, f"fluent(trapDown({i}, {j}),0)."])
                
            if case == "Q":
                asp_enc = "\n".join([asp_enc, f"fluent(box({i}, {j}), 0)."])
                asp_enc = "\n".join([asp_enc, f"fluent(trapUp({i}, {j}),0)."])
                
            else:
                continue

    return asp_enc


def complete(m, n):
    """ Complete the map with spaces """
    for l in m:
        for _ in range(len(l), n):
            l.append(" ")
    return m

def grid_from_file(filename):
    """
    Cette fonction lit un fichier et le convertit en une grille de Helltaker

    Arguments:
    - filename: fichier contenant la description de la grille

    Retour:
    - un dictionnaire contenant:
        - la grille de jeu sous une forme d'une liste de liste de (chaînes de) caractères
        - le nombre de ligne m
        - le nombre de colonnes n
        - le titre de la grille
        - le nombre maximal de coups max_steps
    """

    grid = []
    m = 0  # nombre de lignes
    n = 0  # nombre de colonnes
    no = 0  # numéro de ligne du fichier
    title = ""
    max_steps = 0

    with open(filename, "r", encoding="utf-8") as f:
        for line in f:
            no += 1

            l = line.rstrip()

            if no == 1:
                title = l
                continue
            if no == 2:
                max_steps = int(l)
                continue

            if len(l) > n:
                n = len(l)
                complete(grid, n)

            if l != "":
                grid.append(list(l))

    m = len(grid)

    return {"grid": grid, "title": title, "m": m, "n": n, "max_steps": max_steps}


def check_plan(plan: str):
    """
    Cette fonction vérifie que votre plan est valide/

    Argument: un plan sous forme de chaîne de caractères
    Retour  : True si le plan est valide, False sinon
    """
    valid = "hbgd"
    for c in plan:
        if c not in valid:
            return False
    return True


def test():
    """ Test la présence d'un argument de la ligne de commande """
    if len(sys.argv) != 2:
        sys.exit(-1)

    filename = sys.argv[1]

    return grid_from_file(filename)


# file to string
def file_to_string(filename: str):
    """ Convertit un fichier en une chaîne de caractères """
    with open(filename, "r", encoding="utf-8") as f:
        return f.read()


def creating_pb(initialisation, nb_coups, largeur):
    """ Concate les fichiers ASP et le plan pour créer le problème """
    init = f"#const n={largeur}.\netape(0..{nb_coups-1}).\nnombre(0..n).\n"
    return '\n'.join([init, initialisation, file_to_string("rules.asp")])



if __name__ == "__main__":
    dic = test()
    # print(map_reader(dic['grid']))
    encoded_problem = creating_pb(
        map_reader(dic["grid"], dic["max_steps"]), dic["max_steps"], dic["n"]
    )
    # print(encoded_problem)
    # print(dic["max_steps"])
    print(asp_res_to_table(encoded_problem, dic["max_steps"]))
    print(resource.getrusage(resource.RUSAGE_SELF))
