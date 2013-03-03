
% fib(Y, 1).
%  ==> Y = 1
% fib(Y, 10).
%  ==> Y = 55

fib(Y, N) :- Y = N.

% square_list(Ys, [1,2,3]).
%  ==> Ys = [1,4,9]

square_list(Ys, Xs) :- Ys = Xs.
