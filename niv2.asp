% #const n = 8.
% nombre(0..n).
% etape(0..horizon-1).

% wall(0, 2).
% wall(0, 3).
% wall(0, 4).
% wall(0, 5).
% wall(1, 1).
% wall(1, 6).
% wall(1, 7).
% wall(2, 1).
% fluent(skeleton(2, 2), 0).
% wall(2, 3).
% spike(2, 4).
% spike(2, 5).
% wall(2, 8).
% wall(3, 0).
% spike(3, 2).
% wall(3, 3).
% wall(3, 4).
% spike(3, 5).
% fluent(box(3, 5), 0).
% spike(3, 6).
% fluent(box(3, 6), 0).
% fluent(box(3, 7), 0).
% wall(3, 8).
% wall(4, 0).
% wall(4, 3).
% wall(4, 4).
% spike(4, 6).
% wall(4, 8).
% wall(5, 0).
% fluent(me(5, 1), 0).
% wall(5, 3).
% wall(5, 4).
% fluent(skeleton(5, 6), 0).
% wall(5, 8).
% wall(6, 0).
% wall(6, 1).
% wall(6, 2).
% wall(6, 3).
% wall(6, 4).
% goal(me(5, 5)).
% goal(me(7, 5)).
% goal(me(6, 4)).
% goal(me(6, 6)).
% fluent(skeleton(6, 7), 0).
% wall(6, 8).
% wall(7, 0).
% wall(7, 1).
% wall(7, 2).
% wall(7, 3).
% wall(7, 4).
% wall(7, 5).
% wall(7, 6).
% wall(7, 7).
% wall(7, 8).
% wall(6,5).
% goal(me(7,6)).

% #const n=10.
% etape(0..31).
% nombre(0..n).

% wall(0, 0).
% wall(0, 1).
% wall(0, 2).
% wall(0, 3).
% wall(0, 4).
% wall(0, 5).
% wall(0, 6).
% wall(0, 7).
% wall(0, 8).
% wall(0, 9).
% wall(1, 0).
% wall(1, 1).
% wall(1, 2).
% wall(1, 3).
% wall(1, 4).
% wall(1, 5).
% goal(me(1, 7)).
% wall(1, 6).
% wall(1, 8).
% wall(1, 9).
% wall(2, 0).
% wall(2, 1).
% wall(2, 2).
% wall(2, 3).
% wall(2, 4).
% wall(2, 5).
% wall(2, 6).
% fluent(lock(2, 7),0).
% wall(2, 8).
% wall(2, 9).
% wall(3, 0).
% wall(3, 1).
% wall(3, 2).
% spike(3, 4).
% spike(3, 5).
% fluent(me(3, 8), 0).
% wall(3, 9).
% wall(4, 0).
% wall(4, 1).
% wall(4, 2).
% spike(4, 3).
% wall(4, 4).
% spike(4, 5).
% wall(4, 6).
% wall(4, 9).
% wall(5, 0).
% wall(5, 1).
% wall(5, 2).
% fluent(skeleton(5, 5), 0).
% spike(5, 6).
% spike(5, 7).
% wall(5, 8).
% wall(5, 9).
% wall(6, 0).
% fluent(key(6, 1),0).
% wall(6, 2).
% spike(6, 3).
% wall(6, 4).
% spike(6, 5).
% wall(6, 6).
% wall(6, 8).
% wall(6, 9).
% wall(7, 0).
% fluent(skeleton(7, 6), 0).
% wall(7, 8).
% wall(7, 9).
% wall(8, 0).
% wall(8, 1).
% wall(8, 2).
% wall(8, 3).
% wall(8, 4).
% wall(8, 5).
% wall(8, 6).
% wall(8, 7).
% wall(8, 8).
% wall(8, 9).

#const n=8.
etape(0..3).
nombre(0..n).

wall(0, 0).
wall(0, 1).
wall(0, 2).
wall(0, 3).
wall(1, 0).
wall(1, 1).
wall(1, 2).
wall(1, 3).
wall(1, 4).
wall(1, 5).
wall(1, 6).
wall(1, 7).
wall(2, 0).
fluent(me(2, 2), 0).
oddTrap(2, 4).
evenTrap(2, 3).
goal(me(2, 5)).
wall(2, 6).
wall(2, 7).
wall(3, 0).
wall(3, 1).
wall(3, 2).
wall(3, 3).
wall(3, 4).
wall(3, 5).
wall(3, 6).
wall(3, 7).







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
    T\2 = 0.

fluent(coups_restants(D - 1), T + 1) :-
	do(T, A),
	A != nop,
	fluent(me(X,Y), T+1),
	oddTrap(X,Y),
    not spike(X,Y),
    not evenTrap(X,Y),
	fluent(coups_restants(D), T),
    T\2 != 0.

%--------- Cout d'un coup avec evenTrap -----------
fluent(coups_restants(D - 2), T + 1) :-
	do(T, A),
	A != nop,
	fluent(me(X,Y), T+1),
	evenTrap(X,Y),
    not spike(X,Y),
    not oddTrap(X,Y),
	fluent(coups_restants(D), T),
    T\2 != 0.

fluent(coups_restants(D - 1), T + 1) :-
	do(T, A),
	A != nop,
	fluent(me(X,Y), T+1),
	evenTrap(X,Y),
    not spike(X,Y),
    not oddTrap(X,Y),
	fluent(coups_restants(D), T),
    T\2 = 0.



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
%#show fluent/2.
%#show achieved/1.