safeTrap(6, 1).
safeTrap(6, 3).
safeTrap(6, 6).
etape(0..horizon).

alternativeTrap(X,Y,T):-
    safeTrap(X,Y),
    etape(T),
    T \ 2 != 0.

alternativeTrap(X,Y,T):-
    unsafeTrap(X,Y),
    etape(T),
    T \ 2 = 0.

#show alternativeTrap/3.