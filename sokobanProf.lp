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

action(bas;haut;gauche;droite;push_haut;push_bas;push_gauche;push_droite).
% action(bas;haut;gauche;droite;push_haut).


%initalisation
fluent(me(2,6),0).
fluent(box(6,2), 0).
fluent(box(7,2), 0).
fluent(box(7,4), 0).
fluent(box(6,5), 0).

%Buts.
goal(me(7,6)).



%Test sur les buts

:- goal(F), not fluent(F,horizon).


%Génération des actions pour chaque instant
{do(T,A) : action(A)} = 1 :- etape(T).


% ------------------- HAUT -------------------
%préconditions

:- do(T,haut),
    fluent(me(X, Y), T), 
    fluent(box(X - 1, Y), T).

:- do(T,haut),
    fluent(me(X, Y), T),
    wall(X - 1, Y).

%effets
fluent(me(X - 1, Y), T + 1) :- 
    do(T, haut), 
    fluent(me(X, Y), T).

removed(me(X, Y), T) :- 
    do(T, haut),
    fluent(me(X,Y), T).


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


% ------------------- BAS -------------------
%préconditions
:- do(T,bas),
    fluent(me(X, Y), T), 
    fluent(box(X + 1, Y), T).

:- do(T,bas),
    fluent(me(X, Y), T),
    wall(X + 1, Y).

%effets
fluent(me(X + 1, Y), T + 1) :- 
    do(T, bas), 
    fluent(me(X, Y), T).

removed(me(X, Y), T) :- 
    do(T, bas),
    fluent(me(X,Y), T).

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

% ------------------- GAUCHE -------------------
%préconditions
:- do(T,gauche),
    fluent(me(X, Y), T), 
    fluent(box(X, Y - 1), T).

:- do(T,gauche),
    fluent(me(X, Y), T),
    wall(X, Y - 1).
    %not case(X, Y - 1).

%effets
fluent(me(X, Y - 1), T + 1) :- 
    do(T, gauche), 
    fluent(me(X, Y), T).

removed(me(X, Y), T) :- 
    do(T, gauche),
    fluent(me(X,Y), T).

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

% ------------------- DROITE -------------------
%préconditions

:- do(T, droite),
    fluent(me(X,Y), T),
    wall(X, Y + 1).

:- do(T, droite),
    fluent(me(X, Y), T),
    fluent(box(X, Y+1),T).

%effets
fluent(me(X, Y+1), T+1) :- 
    do(T, droite), 
    fluent(me(X,Y),T).

removed(me(X, Y), T) :-
    do(T, droite),
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

% ------------------- FLUENTS -------------------
fluent(F, T + 1) :-
    fluent(F, T),
    T + 1 <= horizon,
    not removed(F,T).

#show do/2.