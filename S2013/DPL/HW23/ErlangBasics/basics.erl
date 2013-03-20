
-module(basics).
-compile(export_all).

% Define fib(N).

fib(1) -> 1;
fib(2) -> 1;
fib(N) -> fib(N-1) + fib(N-2).


% Define square_list1(Xs) recursively.

square_list1([]) -> [];
square_list1([X|Xs]) -> 
    [X*X|square_list1(Xs)].

% Define square_list2(Xs) using lists:map.

square_list2(Xs) ->
    lists:map(fun(X) -> X*X end,Xs).


% Implement map using lists:foldl and one other standard library
% list function (other than "map") from
%   http://www.erlang.org/doc/man/lists.html

map1(Fn, Xs) -> 
    lists:reverse(lists:foldl(fun(X,Acc) -> [Fn(X)|Acc] end, [],Xs)).


% Define prime(N) which returns the Nth prime number (prime(1) = 2).

prime(N) ->
    AllPrimes = lists:filter(fun(X) -> basics:isprime(X) end, lists:seq(2,2*N*N,1)),
    lists:nth(N,AllPrimes).
    
isprime(N) ->
    lists:all(fun(X) -> X /= 0 end,lists:map(fun(X) -> N rem X end,lists:seq(2,N-1,1))).
