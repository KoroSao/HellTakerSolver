#const n=9.
etape(0..42).
nombre(0..n).

wall(0, 2).
wall(0, 3).
wall(0, 4).
wall(1, 1).
fluent(me(1, 3), 0).
wall(1, 5).
wall(2, 1).
fluent(box(2, 2), 0).
fluent(box(2, 3), 0).
fluent(box(2, 4), 0).
wall(2, 5).
wall(3, 0).
fluent(key(3, 4),0).
wall(3, 5).
wall(4, 1).
evenTrap(4, 2).
fluent(box(4, 3), 0).
evenTrap(4, 3).
wall(4, 6).
wall(4, 7).
wall(5, 1).
fluent(skeleton(5, 2), 0).
wall(5, 3).
fluent(box(5, 4), 0).
fluent(box(5, 5), 0).
wall(5, 8).
wall(6, 1).
fluent(box(6, 4), 0).
fluent(skeleton(6, 6), 0).
wall(6, 7).
wall(7, 2).
wall(7, 3).
wall(7, 4).
fluent(lock(7, 5),0).
fluent(box(7, 6), 0).
wall(7, 8).
wall(8, 4).
goal(me(7, 6)).
goal(me(9, 6)).
goal(me(8, 5)).
goal(me(8, 7)).
wall(8, 6).
wall(8, 7).
wall(9, 5).
wall(9, 6).












fluent(coups_restants(horizon), 0).
fluent(has_key(0), 0).
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

:- do(T,haut),
    fluent(me(X, Y), T),
    fluent(lock (X - 1, Y), T),
    fluent(has_key(0), T).


%effets
fluent(me(X - 1, Y), T + 1) :- 
    do(T, haut),
    fluent(me(X, Y), T).

%effets rammassage de la clé
fluent(has_key(1), T + 1) :- 
    do(T, haut),
    fluent(me(X, Y), T),
    fluent(key(X-1,Y),T).

removed(key(X - 1, Y), T) :- 
    do(T, haut),
    fluent(me(X, Y), T),
    fluent(key(X - 1, Y), T).

removed(has_key(0), T) :- 
    do(T, haut),
    fluent(me(X, Y), T),
    fluent(key(X - 1, Y), T).

%effets passage d'un lock
fluent(has_key(0), T + 1) :- 
    do(T, haut),
    fluent(me(X, Y), T),
    fluent(lock(X - 1, Y), T),
    fluent(has_key(1), T).

removed(lock(X-1,Y), T) :- 
    do(T, haut),
    fluent(me(X, Y), T),
    fluent(lock(X-1,Y),T).

removed(has_key(1), T) :- 
    do(T, haut),
    fluent(me(X, Y), T),
    fluent(lock(X-1,Y),T),
    fluent(has_key(1), T).

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

:- do(T, bas),
    fluent(me(X, Y), T),
    fluent(lock (X + 1, Y), T),
    fluent(has_key(0), T).

%effets
fluent(me(X + 1, Y), T + 1) :- 
    do(T, bas), 
    fluent(me(X, Y), T).

%effets rammassage de la clé
fluent(has_key(1), T + 1) :- 
    do(T, bas),
    fluent(me(X, Y), T),
    fluent(key(X+1,Y),T).

removed(key(X + 1, Y), T) :- 
    do(T, bas),
    fluent(me(X, Y), T),
    fluent(key(X + 1, Y), T).

removed(has_key(0), T) :- 
    do(T, bas),
    fluent(me(X, Y), T),
    fluent(key(X + 1, Y), T).

%effets passage d'un lock
fluent(has_key(0), T + 1) :- 
    do(T, bas),
    fluent(me(X, Y), T),
    fluent(lock(X + 1, Y), T),
    fluent(has_key(1), T).

removed(lock(X+1,Y), T) :- 
    do(T, bas),
    fluent(me(X, Y), T),
    fluent(lock(X+1,Y),T).

removed(has_key(1), T) :- 
    do(T, bas),
    fluent(me(X, Y), T),
    fluent(lock(X+1,Y),T),
    fluent(has_key(1), T).

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

:- do(T, gauche),
    fluent(me(X, Y), T),
    fluent(lock (X, Y-1), T),
    fluent(has_key(0), T).

%effets
fluent(me(X, Y - 1), T + 1) :- 
    do(T, gauche), 
    fluent(me(X, Y), T).

%effets rammassage de la clé
fluent(has_key(1), T + 1) :- 
    do(T, gauche),
    fluent(me(X, Y), T),
    fluent(key(X,Y-1),T).

removed(key(X , Y-1 ), T) :- 
    do(T, gauche),
    fluent(me(X, Y), T),
    fluent(key(X, Y-1), T).

removed(has_key(0), T) :- 
    do(T, gauche),
    fluent(me(X, Y), T),
    fluent(key(X, Y-1), T).

%effets passage d'un lock
fluent(has_key(0), T + 1) :- 
    do(T, gauche),
    fluent(me(X, Y), T),
    fluent(lock(X, Y-1), T),
    fluent(has_key(1), T).

removed(lock(X,Y-1), T) :- 
    do(T, gauche),
    fluent(me(X, Y), T),
    fluent(lock(X,Y-1),T).

removed(has_key(1), T) :- 
    do(T, gauche),
    fluent(me(X, Y), T),
    fluent(lock(X,Y-1),T),
    fluent(has_key(1), T).

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

:- do(T, droite),
    fluent(me(X, Y), T),
    fluent(lock (X, Y+1), T),
    fluent(has_key(0), T).

%effets
fluent(me(X, Y+1), T+1) :- 
    do(T, droite), 
    fluent(me(X,Y),T).

%effets rammassage de la clé
fluent(has_key(1), T + 1) :- 
    do(T, droite),
    fluent(me(X, Y), T),
    fluent(key(X,Y+1),T).

removed(key(X , Y+1 ), T) :- 
    do(T, droite),
    fluent(me(X, Y), T),
    fluent(key(X, Y+1), T).

removed(has_key(0), T) :- 
    do(T, droite),
    fluent(me(X, Y), T),
    fluent(key(X, Y+1), T).

%effets passage d'un lock
fluent(has_key(0), T + 1) :- 
    do(T, droite),
    fluent(me(X, Y), T),
    fluent(lock(X, Y+1), T),
    fluent(has_key(1), T).

removed(lock(X,Y+1), T) :- 
    do(T, droite),
    fluent(me(X, Y), T),
    fluent(lock(X,Y+1),T).

removed(has_key(1), T) :- 
    do(T, droite),
    fluent(me(X, Y), T),
    fluent(lock(X,Y+1),T),
    fluent(has_key(1), T).

% ------------------- PUSH BOX -------------------
%------------------- HAUT -------------------
%préconditions
:- do(T,push_haut),
    fluent(me(X, Y), T),
    not fluent(box(X - 1, Y), T).

%effets

fluent(me(X, Y), T + 1) :- 
    do(T,push_haut), 
    fluent(me(X,Y), T).

fluent(box(X - 2, Y), T + 1) :-
    do(T, push_haut),
    not fluent(box(X - 2, Y),T),
    not fluent(skeleton(X - 2, Y),T),
    not fluent(lock(X - 2, Y),T),
    not wall(X - 2, Y),
    fluent(me(X, Y), T).

fluent(box(X - 1, Y), T + 1) :-
    do(T, push_haut),
    fluent(box(X - 2, Y),T),
    fluent(me(X, Y), T).

fluent(box(X - 1, Y), T + 1) :-
    do(T, push_haut),
    fluent(skeleton(X - 2, Y),T),
    fluent(me(X, Y), T).

fluent(box(X - 1, Y), T + 1) :-
    do(T, push_haut),
    fluent(lock(X - 2, Y),T),
    fluent(me(X, Y), T).

fluent(box(X - 1, Y), T + 1) :-
    do(T, push_haut),
    wall(X - 2, Y),
    fluent(me(X, Y), T).



removed(box(X - 1, Y), T) :-
    do(T, push_haut),
    fluent(me(X, Y), T).

%------------------- BAS -------------------
%préconditions
:- do(T,push_bas),
    fluent(me(X, Y), T),
    not fluent(box(X + 1, Y), T).

%effets

fluent(me(X, Y), T + 1) :- 
    do(T,push_bas), 
    fluent(me(X,Y), T).

fluent(box(X + 2, Y), T + 1) :-
    do(T, push_bas),
    not fluent(box(X + 2, Y),T),
    not fluent(skeleton(X + 2, Y),T),
    not fluent(lock(X + 2, Y),T),
    not wall(X+2, Y),
    fluent(me(X, Y), T).

fluent(box(X + 1, Y), T + 1) :-
    do(T, push_bas),
    fluent(box(X + 2, Y),T),
    fluent(me(X, Y), T).

fluent(box(X + 1, Y), T + 1) :-
    do(T, push_bas),
    fluent(skeleton(X + 2, Y),T),
    fluent(me(X, Y), T).

fluent(box(X + 1, Y), T + 1) :-
    do(T, push_bas),
    fluent(lock(X + 2, Y),T),
    fluent(me(X, Y), T).

fluent(box(X + 1, Y), T + 1) :-
    do(T, push_bas),
    wall(X + 2, Y),
    fluent(me(X, Y), T).

removed(box(X + 1, Y), T) :-
    do(T, push_bas),
    fluent(me(X, Y), T).

%------------------- GAUCHE -------------------

%préconditions
:- do(T, push_gauche),
    fluent(me(X, Y), T),
    not fluent(box(X, Y - 1), T).

%effets
fluent(me(X, Y), T + 1):-
    do(T, push_gauche),
    fluent(me(X, Y), T).

fluent(box(X, Y - 2), T + 1) :-
    do(T, push_gauche),
    not fluent(box(X, Y - 2),T),
    not fluent(skeleton(X, Y - 2),T),
    not fluent(lock(X, Y - 2),T),
    not wall(X, Y - 2),
    fluent(me(X, Y), T).

fluent(box(X, Y-1), T + 1) :-
    do(T, push_gauche),
    fluent(box(X, Y-2),T),
    fluent(me(X, Y), T).

fluent(box(X, Y-1), T + 1) :-
    do(T, push_gauche),
    fluent(skeleton(X, Y-2),T),
    fluent(me(X, Y), T).

fluent(box(X, Y-1), T + 1) :-
    do(T, push_gauche),
    fluent(lock(X, Y-2),T),
    fluent(me(X, Y), T).

fluent(box(X, Y-1), T + 1) :-
    do(T, push_gauche),
    wall(X, Y-2),
    fluent(me(X, Y), T).

removed(box(X,Y-1),T) :-
    do(T, push_gauche),
    fluent(me(X, Y), T).

%------------------- DROITE -------------------
%préconditions
:- do(T,push_droite),
    fluent(me(X, Y), T),
    not fluent(box(X, Y + 1), T).

%effets

fluent(me(X,Y), T + 1) :- 
    do(T,push_droite), 
    fluent(me(X,Y), T).

fluent(box(X, Y + 2), T + 1) :-
    do(T, push_droite),
    not fluent(box(X, Y + 2),T),
    not fluent(skeleton(X, Y + 2),T),
    not fluent(lock(X, Y + 2),T),
    not wall(X, Y + 2),
    fluent(me(X, Y), T).

fluent(box(X, Y+1), T + 1) :-
    do(T, push_droite),
    fluent(box(X, Y+2),T),
    fluent(me(X, Y), T).

fluent(box(X, Y+1), T + 1) :-
    do(T, push_droite),
    fluent(skeleton(X, Y+2),T),
    fluent(me(X, Y), T).

fluent(box(X, Y+1), T + 1) :-
    do(T, push_droite),
    fluent(lock(X, Y+2),T),
    fluent(me(X, Y), T).

fluent(box(X, Y+1), T + 1) :-
    do(T, push_droite),
    wall(X, Y+2),
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

%--------- Cout d'un coup classique -----------
fluent(coups_restants(D -1), T + 1) :-
	do(T, A),
	A != nop,
	fluent(me(X, Y), T+1),
	not spike(X, Y),
    not evenTrap(X,Y),
    not oddTrap(X,Y),
	fluent(coups_restants(D), T).

%--------- Cout d'un coup avec spike -----------
fluent(coups_restants(D - 2), T + 1) :-
	do(T, A),
	A != nop,
	fluent(me(X,Y), T+1),
	spike(X,Y),
    not evenTrap(X,Y),
    not oddTrap(X,Y),
	fluent(coups_restants(D), T).


%--------- Cout d'un coup avec oddTrap -----------
fluent(coups_restants(D - 2), T + 1) :-
	do(T, A),
	A != nop,
	fluent(me(X,Y), T+1),
	oddTrap(X,Y),
    not spike(X,Y),
    not evenTrap(X,Y),
	fluent(coups_restants(D), T),
    T\2 != 0.

fluent(coups_restants(D - 1), T + 1) :-
	do(T, A),
	A != nop,
	fluent(me(X,Y), T+1),
	oddTrap(X,Y),
    not spike(X,Y),
    not evenTrap(X,Y),
	fluent(coups_restants(D), T),
    T\2 = 0.

%--------- Cout d'un coup avec evenTrap -----------
fluent(coups_restants(D - 2), T + 1) :-
	do(T, A),
	A != nop,
	fluent(me(X,Y), T+1),
	evenTrap(X,Y),
    not spike(X,Y),
    not oddTrap(X,Y),
	fluent(coups_restants(D), T),
    T\2 = 0.

fluent(coups_restants(D - 1), T + 1) :-
	do(T, A),
	A != nop,
	fluent(me(X,Y), T+1),
	evenTrap(X,Y),
    not spike(X,Y),
    not oddTrap(X,Y),
	fluent(coups_restants(D), T),
    T\2 != 0.

% -------- Mort du squelette sur un trap --------

removed(skeleton(X, Y), T) :-
    do(T, _),
    fluent(skeleton(X,Y), T),
    spike(X,Y).

removed(skeleton(X, Y), T) :-
    do(T, _),
    fluent(skeleton(X,Y), T),
    evenTrap(X,Y),
    T\2 = 0.

removed(skeleton(X, Y), T) :-
    do(T, _),
    fluent(skeleton(X,Y), T),
    oddTrap(X,Y),
    T\2 != 0.



%--------- MAJ des fluents -----------
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
#show fluent/2.
#show oddTrap/2.
#show evenTrap/2.
%#show fluent/2.
%#show achieved/1.