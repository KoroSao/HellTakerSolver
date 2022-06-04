#const n = 3.
#const tmax = 2.
instant(0..tmax).
nb(0..n).
action(b;h;g;d).

cell(0..n,0..n).

wall(0,0..3).
wall(3,0..3).
wall(1,0).
wall(1,3).
wall(2,0).
wall(2,3).

%at(0,3,1).
%at(4,0,0).

%Generate
{do(T,A): action(A)} = 1:- instant(T), instant(T+1).
{at(T,X,Y): cell(X,Y)} = 1 :- instant(T).

:- at(T,X,Y), at(T+1,X1,Y1), do(T,h), (X1,Y1) != (X,Y+1).
:- at(T,X,Y), at(T+1,X1,Y1), do(T,b), (X1,Y1) != (X,Y-1).
:- at(T,X,Y), at(T+1,X1,Y1), do(T,g), (X1,Y1) != (X-1,Y).
:- at(T,X,Y), at(T+1,X1,Y1), do(T,d), (X1,Y1) != (X+1,Y).
:- at(T,X,Y), wall(X,Y).
:- at(4,X,Y), (X,Y) != (1,2).
:- at(0,X,Y), (X,Y) != (2,1).



% #show at/3.
#show do/2.