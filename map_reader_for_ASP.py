import clingo

def ASP_results(pb, nb_coups):
  # pb : ASP program to solve a unique level
  # nb_coups : number of actions permitted by the game to solve the level

  #==========Launching ASP with the right parameter==========
  hor = f"horizon={nb_coups}"
  ctl = clingo.Control(["-c", hor, "-n0"])
  ctl.add("base", [], pb)
  ctl.ground([("base", [])])
  ctl.configuration.solve.models="0"

  #==========Getting all the models found by ASP==========
  models = []
  with ctl.solve(yield_=True) as handle:
      for model in handle:
          models.append(model.symbols(atoms=True))

  #==========Getting the list of actions to solve the level==========
  glob = []
  for model in models:
    l = []
    for act in model:
      if act.match("do", 2):
        l.append(str(act).split(sep = "(")[1].split(sep = ')')[0].split(sep=","))
    for i in range(len(l)):
      l[i][0] = int(l[i][0])
    l = sorted(l, key=lambda x: x[0])


    #==========Transforming the actions into letters for evaluation==========
    res = []
    for i in range(len(l)):
      if l[i][1] == 'push_droite':
        res.append('d')
      if l[i][1] == 'push_gauche':
        res.append('g')
      if l[i][1] == 'push_haut':
        res.append('h')
      if l[i][1] == 'push_bas':
        res.append('b')
      if l[i][1] == 'push_droite_s':
        res.append('d')
      if l[i][1] == 'push_gauche_s':
        res.append('g')
      if l[i][1] == 'push_haut_s':
        res.append('h')
      if l[i][1] == 'push_bas_s':
        res.append('b')
      if l[i][1] == 'droite':
        res.append('d')
      if l[i][1] == 'gauche':
        res.append('g')
      if l[i][1] == 'haut':
        res.append('h')
      if l[i][1] == 'bas':
        res.append('b')

    glob.append("".join(res))

  return glob

def map_reader(grid, nb_coups):
    asp_enc = ""

    for i,elt in enumerate(grid):
        for j,case in enumerate(elt):
            if case == 'H':
                asp_enc = "\n".join([asp_enc, f"fluent(me({i}, {j}), 0)."])
            if case == 'D':
                asp_enc = "\n".join([asp_enc, f"goal(me({i-1}, {j}))."])
                asp_enc = "\n".join([asp_enc, f"goal(me({i+1}, {j}))."])
                asp_enc = "\n".join([asp_enc, f"goal(me({i}, {j-1}))."])
                asp_enc = "\n".join([asp_enc, f"goal(me({i}, {j+1}))."])
                asp_enc = "\n".join([asp_enc, f"wall({i}, {j})."])
            if case == '#':
                asp_enc = "\n".join([asp_enc, f"wall({i}, {j})."])
            if case == 'B':
                asp_enc = "\n".join([asp_enc, f"fluent(box({i}, {j}), 0)."])
            if case == 'M':
                asp_enc = "\n".join([asp_enc, f"fluent(skeleton({i}, {j}), 0)."])
            if case == 'K':
                asp_enc = "\n".join([asp_enc, f"fluent(key({i}, {j}),0)."])
            if case == 'L':
                asp_enc = "\n".join([asp_enc, f"fluent(lock({i}, {j}),0)."])
            if case == 'S':
                asp_enc = "\n".join([asp_enc, f"spike({i}, {j})."])
            if case == 'T':
                # if (nb_coups %2) == 0:
                #     asp_enc = "\n".join([asp_enc, f"oddTrap({i}, {j})."])
                # else:
                #     asp_enc = "\n".join([asp_enc, f"evenTrap({i}, {j})."])
                asp_enc = "\n".join([asp_enc, f"evenTrap({i}, {j})."])
            if case == 'U':
                # if (nb_coups %2) != 0:
                #     asp_enc = "\n".join([asp_enc, f"oddTrap({i}, {j})."])
                # else:
                #     asp_enc = "\n".join([asp_enc, f"evenTrap({i}, {j})."])
                asp_enc = "\n".join([asp_enc, f"oddTrap({i}, {j})."])
            if case == 'O':
                asp_enc = "\n".join([asp_enc, f"spike({i}, {j})."])
                asp_enc = "\n".join([asp_enc, f"fluent(box({i}, {j}), 0)."])
            if case == 'P':
                asp_enc = "\n".join([asp_enc, f"fluent(box({i}, {j}), 0)."])
                if nb_coups %2 == 0:
                    asp_enc = "\n".join([asp_enc, f"oddTrap({i}, {j})."])
                else:
                    asp_enc = "\n".join([asp_enc, f"evenTrap({i}, {j})."])
            if case == 'Q':
                asp_enc = "\n".join([asp_enc, f"fluent(box({i}, {j}), 0)."])
                if nb_coups %2 != 0:
                    asp_enc = "\n".join([asp_enc, f"oddTrap({i}, {j})."])
                else:
                    asp_enc = "\n".join([asp_enc, f"evenTrap({i}, {j})."])
            else:
                continue

    return asp_enc


"""
Version: 1.1.1
Auteur : Sylvain Lagrue <sylvain.lagrue@hds.utc.fr>

Ce module contient différentes fonction permettant de lire des fichiers Helltaker au format défini pour le projet et de vérifier des plans.
"""

from fileinput import filename
from pprint import pprint
import sys
from typing import List


def complete(m: List[List[str]], n: int):
    for l in m:
        for _ in range(len(l), n):
            l.append(" ")
    return m


def convert(grid: List[List[str]], voc: dict):
    new_grid = []
    for line in grid:
        new_line = []
        for char in line:
            if char in voc:
                new_line.append(voc[char])
            else:
                new_line.append(char)
        new_grid.append(new_line)
    return new_grid


def grid_from_file(filename: str, voc: dict = {}):
    """
    Cette fonction lit un fichier et le convertit en une grille de Helltaker

    Arguments:
    - filename: fichier contenant la description de la grille
    - voc: argument facultatif permettant de convertir chaque case de la grille en votre propre vocabulaire

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
    if voc:
        grid = convert(grid, voc)

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
    if len(sys.argv) != 2:
        sys.exit(-1)

    filename = sys.argv[1]

    return grid_from_file(filename)

# file to string
def file_to_string(filename: str):
    with open(filename, "r", encoding="utf-8") as f:
        return f.read()


def creating_pb(initialisation, nb_coups, largeur):
    init = f"#const n={largeur}.\netape(0..{nb_coups-1}).\nnombre(0..n).\n"
    p = (
        init
        + 
        initialisation
        +
        file_to_string('rules.asp')
)
    return p



if __name__ == "__main__":
    dic = test()
    #print(map_reader(dic['grid']))
    pb = creating_pb(map_reader(dic['grid'], dic['max_steps']), dic['max_steps'], dic['n'])
    print(pb)
    print(dic['max_steps'])
    print(ASP_results(pb, dic['max_steps']))