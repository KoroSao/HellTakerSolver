#const n = 8.
nombre(0..n).
etape(0..horizon-1).


wall(0,0..8).
wall(1,0..8).
wall(2,0..4).
wall(2,7..8).
wall(3,0..1).
wall(3,7..8).
wall(4,0..1).
wall(4,6..8).
wall(5,0).
wall(5,3..8).
wall(6,0).
wall(6,7..8).
wall(7,0).
wall(7,7..8).
wall(8,0..8).

action(bas;haut;gauche;droite;push_haut;push_bas;push_gauche;push_droite;push_haut_s;push_bas_s;push_gauche_s;push_droite_s).


%initalisation
fluent(me(2,6),0).
fluent(box(6,2), 0).
fluent(box(7,2), 0).
fluent(box(7,4), 0).
fluent(box(6,5), 0).
fluent(skeleton(3,4),0).
fluent(skeleton(4,3),0).
fluent(skeleton(4,5),0).

%Buts.
goal(me(7,6)).



%Test sur les buts

:- goal(F), not fluent(F,horizon).


%Génération des actions pour chaque instant
{do(T,A) : action(A)} = 1 :- etape(T).


% ------------------- MOVE -------------------
%préconditions

:- do(T,haut),
    fluent(me(X, Y), T), 
    fluent(box(X - 1, Y), T).

:- do(T,haut),
    fluent(me(X, Y), T),
    wall(X - 1, Y).

:- do(T,haut),
    fluent(me(X, Y), T),
    fluent(skeleton(X - 1, Y),T).

%effets
fluent(me(X - 1, Y), T + 1) :- 
    do(T, haut), 
    fluent(me(X, Y), T).

removed(me(X, Y), T) :- 
    do(T, haut),
    fluent(me(X,Y), T).

%préconditions
:- do(T,bas),
    fluent(me(X, Y), T), 
    fluent(box(X + 1, Y), T).

:- do(T,bas),
    fluent(me(X, Y), T),
    wall(X + 1, Y).

:- do(T,bas),
    fluent(me(X, Y), T),
    fluent(skeleton(X + 1, Y),T).


%effets
fluent(me(X + 1, Y), T + 1) :- 
    do(T, bas), 
    fluent(me(X, Y), T).

removed(me(X, Y), T) :- 
    do(T, bas),
    fluent(me(X,Y), T).


%préconditions
:- do(T,gauche),
    fluent(me(X, Y), T), 
    fluent(box(X, Y - 1), T).

:- do(T,gauche),
    fluent(me(X, Y), T),
    wall(X, Y - 1).

:- do(T,gauche),
    fluent(me(X, Y), T),
    fluent(skeleton(X, Y - 1),T).

%effets
fluent(me(X, Y - 1), T + 1) :- 
    do(T, gauche), 
    fluent(me(X, Y), T).

removed(me(X, Y), T) :- 
    do(T, gauche),
    fluent(me(X,Y), T).


%préconditions

:- do(T, droite),
    fluent(me(X,Y), T),
    wall(X, Y + 1).

:- do(T, droite),
    fluent(me(X, Y), T),
    fluent(box(X, Y+1),T).

:- do(T, droite),
    fluent(me(X, Y), T),
    fluent(skeleton(X, Y+1),T).

%effets
fluent(me(X, Y+1), T+1) :- 
    do(T, droite), 
    fluent(me(X,Y),T).

removed(me(X, Y), T) :-
    do(T, droite),
    fluent(me(X, Y), T).

% ------------------- PUSH BOX -------------------

%préconditions
:- do(T,push_haut),
    fluent(me(X, Y), T),
    not fluent(box(X - 1, Y), T).

:- do(T, push_haut),
    fluent(me(X,Y),T),
    wall(X - 2, Y).

:- do(T, push_haut),
    fluent(me(X,Y), T),
    fluent(box(X - 2, Y), T).

%effets

fluent(me(X, Y), T + 1) :- 
    do(T,push_haut), 
    fluent(me(X,Y), T).

fluent(box(X - 2, Y), T + 1) :-
    do(T, push_haut),
    fluent(me(X, Y), T).

removed(box(X - 1, Y), T) :-
    do(T, push_haut),
    fluent(me(X, Y), T).

removed(me(X, Y), T) :-
    do(T,push_haut),
    fluent(me(X, Y), T).

%préconditions
:- do(T,push_bas),
    fluent(me(X, Y), T),
    not fluent(box(X + 1, Y), T).

:- do(T, push_bas),
    fluent(me(X,Y),T),
    wall(X + 2, Y).

:- do(T, push_bas),
    fluent(me(X,Y), T),
    fluent(box(X + 2, Y), T).

%effets

fluent(me(X, Y), T + 1) :- 
    do(T,push_bas), 
    fluent(me(X,Y), T).

fluent(box(X + 2, Y), T + 1) :-
    do(T, push_bas),
    fluent(me(X, Y), T).

removed(box(X + 1, Y), T) :-
    do(T, push_bas),
    fluent(me(X, Y), T).

removed(me(X, Y), T) :-
    do(T,push_bas),
    fluent(me(X, Y), T).



%préconditions

:- do(T, push_gauche),
    fluent(me(X, Y), T),
    not fluent(box(X, Y + 1), T).

:- do(T, push_gauche),
    fluent(me(X, Y), T),
    wall(X, Y + 2).
    %not case(X, Y + 2).

:- do(T, push_gauche),
    fluent(me(X, Y), T),
    fluent(box(X, Y + 2), T).

%effets

fluent(me(X, Y + 1), T + 1):-
    do(T, push_gauche),
    fluent(me(X, Y), T).

fluent(box(X, Y + 2), T + 1) :-
    do(T, push_gauche),
    fluent(me(X, Y), T).

removed(me(X,Y),T) :-
    do(T, push_gauche),
    fluent(me(X, Y), T).

removed(box(X, Y + 1), T) :-
    do(T, push_gauche),
    fluent(me(X, Y), T).



%préconditions

:- do(T,push_droite),
    fluent(me(X, Y), T),
    not fluent(box(X, Y - 1), T).

:- do(T, push_droite),
    fluent(me(X,Y),T),
    wall(X, Y - 2).
    %not case(X, Y - 2).

:- do(T, push_droite),
    fluent(me(X,Y), T),
    fluent(box(X, Y - 2), T).

%effets

fluent(me(X,Y - 1), T + 1) :- 
    do(T,push_droite), 
    fluent(me(X,Y), T).

fluent(box(X, Y - 2), T + 1) :-
    do(T, push_droite),
    fluent(me(X, Y), T).

removed(box(X, Y - 1), T) :-
    do(T, push_droite),
    fluent(me(X, Y), T).

removed(me(X, Y), T) :-
    do(T,push_droite),
    fluent(me(X, Y), T).


% ------------------- PUSH SKELETON -------------------

%préconditions
:- do(T,push_haut_s),
    fluent(me(X, Y), T),
    not fluent(skeleton(X - 1, Y), T).

%effets

fluent(me(X, Y), T + 1) :- 
    do(T,push_haut_s), 
    fluent(me(X,Y), T).

fluent(skeleton(X - 2, Y), T + 1) :-
    do(T, push_haut_s),
    not wall(X - 2, Y),
    not fluent(box(X - 2, Y),T),
    not fluent(skeleton(X - 2, Y),T),
    fluent(me(X, Y), T).

removed(skeleton(X - 1, Y), T) :-
    do(T, push_haut_s),
    fluent(me(X, Y), T).

removed(me(X, Y), T) :-
    do(T,push_haut_s),
    fluent(me(X, Y), T).


%préconditions
:- do(T,push_bas_s),
    fluent(me(X, Y), T),
    not fluent(skeleton(X - 1, Y), T).

%effets
fluent(me(X, Y), T + 1) :- 
    do(T,push_bas_s), 
    fluent(me(X,Y), T).

fluent(skeleton(X + 2, Y), T + 1) :-
    do(T, push_bas_s),
    not wall(X + 2, Y),
    not fluent(box(X + 2, Y),T),
    not fluent(skeleton(X + 2, Y),T),
    fluent(me(X, Y), T).

removed(skeleton(X + 1, Y), T) :-
    do(T, push_bas_s),
    fluent(me(X, Y), T).

removed(me(X, Y), T) :-
    do(T,push_bas_s),
    fluent(me(X, Y), T).


%préconditions
:- do(T,push_gauche_s),
    fluent(me(X, Y), T),
    not fluent(skeleton(X , Y-1), T).

%effets
fluent(me(X, Y), T + 1) :- 
    do(T,push_gauche_s), 
    fluent(me(X,Y), T).

fluent(skeleton(X, Y-2), T + 1) :-
    do(T, push_gauche_s),
    not wall(X, Y-2),
    not fluent(box(X , Y-2),T),
    not fluent(skeleton(X , Y-2),T),
    fluent(me(X, Y), T).

removed(skeleton(X, Y-1), T) :-
    do(T, push_gauche_s),
    fluent(me(X, Y), T).

removed(me(X, Y), T) :-
    do(T,push_gauche_s),
    fluent(me(X, Y), T).


%préconditions
:- do(T,push_droite_s),
    fluent(me(X, Y), T),
    not fluent(skeleton(X , Y+1), T).

%effets
fluent(me(X, Y), T + 1) :- 
    do(T,push_droite_s), 
    fluent(me(X,Y), T).

fluent(skeleton(X, Y+2), T + 1) :-
    do(T, push_droite_s),
    not wall(X, Y+2),
    not fluent(box(X , Y+2),T),
    not fluent(skeleton(X , Y+2),T),
    fluent(me(X, Y), T).

removed(skeleton(X, Y+1), T) :-
    do(T, push_droite_s),
    fluent(me(X, Y), T).

removed(me(X, Y), T) :-
    do(T,push_droite_s),
    fluent(me(X, Y), T).




fluent(F, T + 1) :-
    fluent(F, T),
    T + 1 <= horizon,
    not removed(F,T).

#show do/2.