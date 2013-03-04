% fib(Y, 1).
%  ==> Y = 1
% fib(Y, 10).
%  ==> Y = 55
fib(1, 1).
fib(1, 2).
fib(Y, N) :-
    A is N-1,B is N-2,
    fib(Y1,A),
    fib(Y2,B),
    Y is Y1 + Y2.
    
% square_list(Ys, [1,2,3]).
%  ==> Ys = [1,4,9]
square_list([], []).
square_list(Y, [X|Xs]) :- 
    square_list(Ys,Xs),  %recursive call, calculates 
    Xx is X*X,
    append([Xx],Ys,Y).
