mur(0,0).
mur(0,1).
mur(0,2).
mur(0,3).
mur(0,4).
mur(0,5).
mur(0,6).
mur(0,7).
mur(1,0).
mur(1,1).
mur(1,2).
mur(1,6).
mur(1,7).
mur(2,0).
mur(2,6).
mur(2,7).
mur(3,0).
mur(3,1).
mur(3,2).
mur(3,6).
mur(3,7).
mur(4,0).
mur(4,2).
mur(4,3).
mur(4,6).
mur(4,7).
mur(5,0).
mur(5,2).
mur(5,6).
mur(5,7).
mur(6,0).
mur(6,7).
mur(7,0).
mur(7,7).
mur(8,0).
mur(8,1).
mur(8,2).
mur(8,3).
mur(8,4).
mur(8,5).
mur(8,6).
mur(8,7).


goal(pos(2,1)).
goal(pos(3,5)).
goal(pos(4,1)).
goal(pos(5,4)).
goal(pos(6,3)).
goal(pos(6,6)).
goal(pos(7,4)).


start(state(me(2,2),
    boxes([pos(2,3), pos(3,4), pos(4,4), pos(6,1), pos(6,3), pos(6,4), pos(6,5)]))).

% :param D : direction
% renvoie vrai quand D permet de passer de pos(X,Y) à pos(X1,Y1)
relativePosition(up, pos(X,Y), pos(X1,Y)):-
    X1 is X - 1,
    \+mur(X,Y),
    \+mur(X1,Y).

relativePosition(down, pos(X,Y), pos(X1,Y)):-
    X1 is X + 1,
    \+mur(X,Y),
    \+mur(X1,Y).

relativePosition(left, pos(X,Y), pos(X,Y1)):-
    Y1 is Y - 1,
    \+mur(X,Y),
    \+mur(X,Y1).

relativePosition(right, pos(X,Y), pos(X,Y1)):-
    Y1 is Y + 1,
    \+mur(X,Y),
    \+mur(X,Y1).

notIn(_, []).
notIn(X, [Y|T]):- dif(X, Y), notIn(X, T).



ends([X],X).
ends([_|T],X):- ends(T,X).



allontarget([]).
allontarget([H|T]):- 
    goal(H), 
    allontarget(T).




%foundRemove(X,[X], []).
foundRemove(X, [X|T], T).
foundRemove(X, [Y|T], [Y|T1]):- 
    dif(X,Y), 
    foundRemove(X,T,T1).



do( act(move,D), 
    state(me(X,Y), boxes(L)), 
    state(me(X1,Y1), boxes(L))  ):-
        relativePosition(D, pos(X,Y), pos(X1,Y1)),
        notIn(pos(X1,Y1), L).

do( act(push,D), 
    state(me(X,Y), boxes(L)), 
    state(me(X1,Y1), boxes([pos(X2,Y2)|L1]))  ):-
        relativePosition(D, pos(X,Y), pos(X1,Y1)),
        foundRemove(pos(X1,Y1), L, L1),
        relativePosition(D, pos(X1,Y1), pos(X2,Y2)),
        notIn(pos(X2,Y2), L).





validPlan([], [_], 0).
validPlan([A|AT], [S1,S2|ST], N):-
    N > 0,
    N1 is N - 1,
    do(A, S1, S2),
    validPlan(AT, [S2|ST], N1).

winningPlan(A,[X|T], N):-
    start(X),
    validPlan(A, [X|T], N),
    ends(T, state(_,boxes(L))),
    allontarget(L).    

    
    
