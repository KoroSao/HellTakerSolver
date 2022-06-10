#const n=8.
etape(0..22).
nombre(0..n).


wall(0, 0).
wall(0, 1).
wall(0, 2).
wall(0, 3).
wall(0, 4).
wall(0, 5).
wall(0, 6).
wall(0, 7).
wall(1, 3).
goal(me(0, 5)).
goal(me(2, 5)).
goal(me(1, 4)).
goal(me(1, 6)).
wall(1, 5).
wall(1, 6).
wall(2, 1).
wall(2, 2).
fluent(lock(2, 4),0).
fluent(box(2, 5), 0).
wall(2, 7).
wall(3, 0).
fluent(me(3, 1), 0).
wall(3, 2).
fluent(trapDown(3, 3),0).
fluent(box(3, 5), 0).
wall(3, 7).
wall(4, 0).
wall(4, 2).
fluent(trapDown(4, 4),0).
fluent(trapDown(4, 6),0).
wall(4, 7).
wall(5, 0).
fluent(skeleton(5, 1), 0).
wall(5, 2).
fluent(box(5, 3), 0).
fluent(box(5, 4), 0).
fluent(box(5, 5), 0).
fluent(box(5, 6), 0).
wall(5, 7).
wall(6, 0).
fluent(trapDown(6, 1),0).
fluent(trapDown(6, 3),0).
fluent(trapDown(6, 6),0).
wall(6, 7).
wall(7, 1).
wall(7, 2).
wall(7, 3).
wall(7, 4).
wall(7, 5).
fluent(key(7, 6),0).
wall(7, 7).
wall(8, 6).


fluent(has_key(0), 0).
%------------------- ACTIONS -------------------
%------------------- Niveau 1 -------------------
%------------------- Se deplacer -------------------
action(bas;haut;gauche;droite).
%------------------- Pousser une caisse -------------------
action(push_haut;push_bas;push_gauche;push_droite).
%------------------- Pousser une squelette -------------------
%
action(nop).
action(skip).     

%------------------- Buts -------------------

achieved(T):- fluent(F,T), goal(F).
:- not achieved(_).
:- achieved(T), T > horizon.
:- achieved(T), do(T, A), A != nop.
:- do(nop, T), not achieved(T).

%------- Génération des actions.
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

% ------------------- PUSH -------------------
%------------------- HAUT -------------------
%préconditions
:- do(T,push_haut),
    fluent(me(X, Y), T),
    not fluent(box(X - 1, Y), T),
    not fluent(skeleton(X - 1, Y), T).


:- do(T,push_haut),
    fluent(me(X, Y), T),
    wall(X-1, Y).

%effets

fluent(me(X, Y), T + 1) :- 
    do(T,push_haut), 
    fluent(me(X,Y), T).

fluent(box(X - 2, Y), T + 1) :-
    do(T, push_haut), fluent(box(X - 1, Y), T),
    not fluent(box(X - 2, Y),T),
    not fluent(skeleton(X - 2, Y),T),
    not fluent(lock(X - 2, Y),T),
    not wall(X - 2, Y),
    fluent(me(X, Y), T).

fluent(box(X - 1, Y), T + 1) :-
    do(T, push_haut), fluent(box(X - 1, Y), T),
    fluent(box(X - 2, Y),T),
    fluent(me(X, Y), T).

fluent(box(X - 1, Y), T + 1) :-
    do(T, push_haut), fluent(box(X - 1, Y), T),
    fluent(skeleton(X - 2, Y),T),
    fluent(me(X, Y), T).

fluent(box(X - 1, Y), T + 1) :-
    do(T, push_haut), fluent(box(X - 1, Y), T),
    fluent(lock(X - 2, Y),T),
    fluent(me(X, Y), T).

fluent(box(X - 1, Y), T + 1) :-
    do(T, push_haut), fluent(box(X - 1, Y), T),
    wall(X - 2, Y),
    fluent(me(X, Y), T).

removed(box(X - 1, Y), T) :-
    do(T, push_haut), fluent(box(X - 1, Y), T),
    fluent(me(X, Y), T).

fluent(skeleton(X - 2, Y), T + 1) :-
    do(T, push_haut), fluent(skeleton(X - 1, Y), T),
    not wall(X - 2, Y),
    not fluent(box(X - 2, Y),T),
    not fluent(skeleton(X - 2, Y),T),
    fluent(me(X, Y), T).

removed(skeleton(X - 1, Y), T) :-
    do(T, push_haut), fluent(skeleton(X - 1, Y), T),
    fluent(me(X, Y), T).

%------------------- BAS -------------------
%préconditions
:- do(T,push_bas),
    fluent(me(X, Y), T),
    not fluent(box(X + 1, Y), T),
    not fluent(skeleton(X + 1, Y), T).


:- do(T,push_bas),
    fluent(me(X, Y), T),
    wall(X+1, Y).

%effets

fluent(me(X, Y), T + 1) :- 
    do(T,push_bas), 
    fluent(me(X,Y), T).

fluent(box(X + 2, Y), T + 1) :-
    do(T, push_bas),
    fluent(box(X + 1, Y), T),
    not fluent(box(X + 2, Y),T),
    not fluent(skeleton(X + 2, Y),T),
    not fluent(lock(X + 2, Y),T),
    not wall(X + 2, Y),
    fluent(me(X, Y), T).

fluent(box(X + 1, Y), T + 1) :-
    do(T, push_bas),
    fluent(box(X + 1, Y), T),
    fluent(box(X + 2, Y),T),
    fluent(me(X, Y), T).

fluent(box(X + 1, Y), T + 1) :-
    do(T, push_bas),
    fluent(box(X + 1, Y), T),
    fluent(skeleton(X + 2, Y),T),
    fluent(me(X, Y), T).

fluent(box(X + 1, Y), T + 1) :-
    do(T, push_bas),
    fluent(box(X + 1, Y), T),
    fluent(lock(X + 2, Y),T),
    fluent(me(X, Y), T).

fluent(box(X + 1, Y), T + 1) :-
    do(T, push_bas),
    fluent(box(X + 1, Y), T),
    wall(X + 2, Y),
    fluent(me(X, Y), T).

removed(box(X + 1, Y), T) :-
    do(T, push_bas),
    fluent(box(X + 1, Y), T),
    fluent(me(X, Y), T).

fluent(skeleton(X + 2, Y), T + 1) :-
    do(T, push_bas),
    fluent(skeleton(X + 1, Y), T),
    not wall(X + 2, Y),
    not fluent(box(X + 2, Y),T),
    not fluent(skeleton(X + 2, Y),T),
    fluent(me(X, Y), T).

removed(skeleton(X + 1, Y), T) :-
    do(T, push_bas),
    fluent(skeleton(X + 1, Y), T),
    fluent(me(X, Y), T).

%------------------- GAUCHE -------------------

%préconditions
:- do(T,push_gauche),
    fluent(me(X, Y), T),
    not fluent(box(X, Y-1), T),
    not fluent(skeleton(X, Y-1), T).

:- do(T,push_gauche),
    fluent(me(X, Y), T),
    wall(X, Y-1).

%effets

fluent(me(X, Y), T + 1) :- 
    do(T,push_gauche), 
    fluent(me(X,Y), T).

fluent(box(X, Y-2), T + 1) :-
    do(T, push_gauche), fluent(box(X, Y-1), T),
    not fluent(box(X, Y-2),T),
    not fluent(skeleton(X, Y-2),T),
    not fluent(lock(X, Y-2),T),
    not wall(X, Y-2),
    fluent(me(X, Y), T).

fluent(box(X, Y-1), T + 1) :-
    do(T, push_gauche), fluent(box(X , Y-1), T),
    fluent(box(X, Y-2),T),
    fluent(me(X, Y), T).

fluent(box(X, Y-1), T + 1) :-
    do(T, push_gauche), fluent(box(X, Y-1), T),
    fluent(skeleton(X, Y-2),T),
    fluent(me(X, Y), T).

fluent(box(X, Y-1), T + 1) :-
    do(T, push_gauche), fluent(box(X, Y-1), T),
    fluent(lock(X, Y-2),T),
    fluent(me(X, Y), T).

fluent(box(X, Y-1), T + 1) :-
    do(T, push_gauche), fluent(box(X, Y-1), T),
    wall(X, Y-2),
    fluent(me(X, Y), T).

removed(box(X, Y-1), T) :-
    do(T, push_gauche), fluent(box(X, Y-1), T),
    fluent(me(X, Y), T).

fluent(skeleton(X, Y-2), T + 1) :-
    do(T, push_gauche), fluent(skeleton(X, Y-1), T),
    not wall(X, Y-2),
    not fluent(box(X, Y-2),T),
    not fluent(skeleton(X, Y-2),T),
    fluent(me(X, Y), T).

removed(skeleton(X, Y-1), T) :-
    do(T, push_gauche), fluent(skeleton(X, Y-1), T),
    fluent(me(X, Y), T).

%------------------- DROITE -------------------
%préconditions
:- do(T,push_droite),
    fluent(me(X, Y), T),
    not fluent(box(X, Y+1), T),
    not fluent(skeleton(X, Y+1), T).

:- do(T,push_droite),
    fluent(me(X, Y), T),
    wall(X, Y+1).

%effets

fluent(me(X, Y), T + 1) :- 
    do(T,push_droite), 
    fluent(me(X,Y), T).

fluent(box(X, Y+2), T + 1) :-
    do(T, push_droite),
    fluent(box(X, Y+1), T),
    not fluent(box(X, Y+2),T),
    not fluent(skeleton(X, Y+2),T),
    not fluent(lock(X, Y+2),T),
    not wall(X, Y+2),
    fluent(me(X, Y), T).

fluent(box(X, Y+1), T + 1) :-
    do(T, push_droite),
    fluent(box(X , Y+1), T),
    fluent(box(X, Y+2),T),
    fluent(me(X, Y), T).

fluent(box(X, Y+1), T + 1) :-
    do(T, push_droite),
    fluent(box(X, Y+1), T),
    fluent(skeleton(X, Y+2),T),
    fluent(me(X, Y), T).

fluent(box(X, Y+1), T + 1) :-
    do(T, push_droite),
    fluent(box(X, Y+1), T),
    fluent(lock(X, Y+2),T),
    fluent(me(X, Y), T).

fluent(box(X, Y+1), T + 1) :-
    do(T, push_droite),
    fluent(box(X, Y+1), T),
    wall(X, Y+2),
    fluent(me(X, Y), T).

removed(box(X, Y+1), T) :-
    do(T, push_droite),
    fluent(box(X, Y+1), T),
    fluent(me(X, Y), T).

fluent(skeleton(X, Y+2), T + 1) :-
    do(T, push_droite),
    fluent(skeleton(X, Y+1), T),
    not wall(X, Y+2),
    not fluent(box(X, Y+2),T),
    not fluent(skeleton(X, Y+2),T),
    fluent(me(X, Y), T).

removed(skeleton(X, Y+1), T) :-
    do(T, push_droite),
    fluent(skeleton(X, Y+1), T),
    fluent(me(X, Y), T).

%---------------------- SKIP ----------------------
do(T+1, skip):- fluent(me(X,Y),T), spike(X-1,Y), do(T,haut).
do(T+1, skip):- fluent(me(X,Y),T), spike(X+1,Y), do(T,bas).
do(T+1, skip):- fluent(me(X,Y),T), spike(X,Y-1), do(T,gauche).
do(T+1, skip):- fluent(me(X,Y),T), spike(X,Y+1), do(T,droite).

do(T+1, skip):- fluent(me(X,Y),T), spike(X,Y), do(T,push_haut).
do(T+1, skip):- fluent(me(X,Y),T), spike(X,Y), do(T,push_bas).
do(T+1, skip):- fluent(me(X,Y),T), spike(X,Y), do(T,push_gauche).
do(T+1, skip):- fluent(me(X,Y),T), spike(X,Y), do(T,push_droite).

do(T+1, skip):- fluent(me(X,Y),T), fluent(trapUp(X-1,Y),T+1), do(T,haut).
do(T+1, skip):- fluent(me(X,Y),T), fluent(trapUp(X+1,Y),T+1), do(T,bas).
do(T+1, skip):- fluent(me(X,Y),T), fluent(trapUp(X,Y-1),T+1), do(T,gauche).
do(T+1, skip):- fluent(me(X,Y),T), fluent(trapUp(X,Y+1),T+1), do(T,droite).

do(T+1, skip):- fluent(me(X,Y),T), fluent(trapUp(X,Y), T+1), do(T,push_haut).
do(T+1, skip):- fluent(me(X,Y),T), fluent(trapUp(X,Y), T+1), do(T,push_bas).
do(T+1, skip):- fluent(me(X,Y),T), fluent(trapUp(X,Y), T+1), do(T,push_gauche).
do(T+1, skip):- fluent(me(X,Y),T), fluent(trapUp(X,Y), T+1), do(T,push_droite).

:- do(T, skip), T < 1.


fluent(me(X, Y), T + 1) :- 
    do(T,skip), 
    fluent(me(X,Y), T).




% -------- Mort du squelette sur un trap --------

removed(skeleton(X, Y), T) :-
    fluent(skeleton(X,Y), T),
    spike(X,Y).

removed(skeleton(X, Y), T) :-
    fluent(skeleton(X,Y), T),
    fluent(trapUp(X,Y),T+1).



%--------- MAJ des fluents -----------
removed(me(X, Y), T) :- 
    do(T, _),
    fluent(me(X,Y), T).

removed(trapUp(X,Y), T):-
    fluent(trapDown(X,Y),T+1).

removed(trapDown(X,Y), T):-
    fluent(trapUp(X,Y),T+1).


fluent(trapDown(X,Y),T+1):-
    not do(T,skip),
    fluent(trapUp(X,Y),T),
    T + 1 <= horizon.

fluent(trapUp(X,Y),T+1):-
    not do(T,skip),
    fluent(trapDown(X,Y),T),
    T + 1 <= horizon.


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

#defined oddTrap/2.
#defined evenTrap/2.
#defined spike/2.
#defined lock/2.
#defined key/2.
#defined alternativeTrap/3.
#defined safeTrap/2.
#defined unsafeTrap/2.

