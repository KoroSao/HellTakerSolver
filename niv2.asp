#const n = 8.
nombre(0..n).
etape(0..horizon-1).

wall(0, 2).
wall(0, 3).
wall(0, 4).
wall(0, 5).
wall(1, 1).
wall(1, 6).
wall(1, 7).
wall(2, 1).
fluent(skeleton(2, 2), 0).
wall(2, 3).
spike(2, 4).
spike(2, 5).
wall(2, 8).
wall(3, 0).
spike(3, 2).
wall(3, 3).
wall(3, 4).
spike(3, 5).
fluent(box(3, 5), 0).
spike(3, 6).
fluent(box(3, 6), 0).
fluent(box(3, 7), 0).
wall(3, 8).
wall(4, 0).
wall(4, 3).
wall(4, 4).
spike(4, 6).
wall(4, 8).
wall(5, 0).
fluent(me(5, 1), 0).
wall(5, 3).
wall(5, 4).
fluent(skeleton(5, 6), 0).
wall(5, 8).
wall(6, 0).
wall(6, 1).
wall(6, 2).
wall(6, 3).
wall(6, 4).
goal(me(5, 5)).
goal(me(7, 5)).
goal(me(6, 4)).
goal(me(6, 6)).
fluent(skeleton(6, 7), 0).
wall(6, 8).
wall(7, 0).
wall(7, 1).
wall(7, 2).
wall(7, 3).
wall(7, 4).
wall(7, 5).
wall(7, 6).
wall(7, 7).
wall(7, 8).
wall(6,5).

fluent(coups_restants(horizon), 0).
%------------------- ACTIONS -------------------
%------------------- Niveau 1 -------------------
%------------------- Se deplacer -------------------
action(bas;haut;gauche;droite).
%------------------- Pousser une caisse -------------------
action(push_haut;push_bas;push_gauche;push_droite).
%------------------- Pousser une squelette -------------------
action(push_haut_s;push_bas_s;push_gauche_s;push_droite_s).
%
action(nop).


%------------------- Buts -------------------
goal(me(7,6)).
achieved(T):- fluent(F,T), goal(F).
:- not achieved(_).
:- achieved(T), fluent(coups_restants(D), T), D < 0.
:- achieved(T), T > horizon.
:- achieved(T), do(T, A), A != nop.
:- do(nop, T), not achieved(T).


% Génération des actions.
{do(T,A) : action(A)} = 1 :- etape(T).


% ------------------- MOVE -------------------
%------------------- HAUT -------------------
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

%------------------- BAS -------------------
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

%------------------- GAUCHE -------------------

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

%------------------- DROITE -------------------
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

% ------------------- PUSH BOX -------------------
%------------------- HAUT -------------------
%préconditions
:- do(T,push_haut),
    fluent(me(X, Y), T),
    not fluent(box(X - 1, Y), T).

:- do(T, push_haut),
    fluent(me(X,Y),T),
    wall(X - 2, Y).

:- do(T, push_haut),
    fluent(me(X,Y),T),
    fluent(skeleton(X - 2, Y),T).

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

%------------------- BAS -------------------
%préconditions
:- do(T,push_bas),
    fluent(me(X, Y), T),
    not fluent(box(X + 1, Y), T).

:- do(T, push_bas),
    fluent(me(X,Y),T),
    wall(X + 2, Y).

:- do(T, push_bas),
    fluent(me(X,Y),T),
    fluent(skeleton(X + 2, Y),T).

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

%------------------- GAUCHE -------------------

%préconditions
:- do(T, push_gauche),
    fluent(me(X, Y), T),
    not fluent(box(X, Y - 1), T).

:- do(T, push_gauche),
    fluent(me(X, Y), T),
    wall(X, Y - 2).

:- do(T, push_gauche),
    fluent(me(X, Y), T),
    fluent(skeleton(X, Y - 2),T).

:- do(T, push_gauche),
    fluent(me(X, Y), T),
    fluent(box(X, Y - 2), T).

%effets

fluent(me(X, Y), T + 1):-
    do(T, push_gauche),
    fluent(me(X, Y), T).

fluent(box(X, Y - 2), T + 1) :-
    do(T, push_gauche),
    fluent(me(X, Y), T).

removed(me(X,Y),T) :-
    do(T, push_gauche),
    fluent(me(X, Y), T).

%------------------- DROITE -------------------
%préconditions
:- do(T,push_droite),
    fluent(me(X, Y), T),
    not fluent(box(X, Y + 1), T).

:- do(T, push_droite),
    fluent(me(X,Y),T),
    wall(X, Y + 2).

:- do(T, push_droite),
    fluent(me(X,Y),T),
    fluent(skeleton(X, Y + 2),T).

:- do(T, push_droite),
    fluent(me(X,Y), T),
    fluent(box(X, Y + 2), T).

%effets

fluent(me(X,Y), T + 1) :- 
    do(T,push_droite), 
    fluent(me(X,Y), T).

fluent(box(X, Y + 2), T + 1) :-
    do(T, push_droite),
    fluent(me(X, Y), T).

removed(box(X, Y + 1), T) :-
    do(T, push_droite),
    fluent(me(X, Y), T).

% ------------------- PUSH SKELETON -------------------
%------------------- HAUT -------------------
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

%------------------- BAS -------------------
%préconditions
:- do(T,push_bas_s),
    fluent(me(X, Y), T),
    not fluent(skeleton(X + 1, Y), T).

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

%------------------- GAUCHE -------------------
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


%------------------- DROITE -------------------
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


%%%

fluent(coups_restants(D -1), T + 1) :-
	do(T, A),
	A != nop,
	fluent(me(X, Y), T+1),
	not spike(X, Y),
	fluent(coups_restants(D), T).

fluent(coups_restants(D - 2), T + 1) :-
	do(T, A),
	A != nop,
	fluent(me(X,Y), T+1),
	spike(X,Y),
	fluent(coups_restants(D), T).

removed(me(X, Y), T) :- 
    do(T, _),
    fluent(me(X,Y), T).

removed(coups_restants(D), T) :-
	do(T, _),
	fluent(coups_restants(D), T).

fluent(F, T+1) :-
	fluent(F, T),
	T + 1 < horizon,
	not removed(F, T).

fluent(F, T+1) :-
	fluent(F, T),
	achieved(T),
	T + 1 <= horizon.

#show do/2.
%#show fluent/2.
%#show achieved/1.