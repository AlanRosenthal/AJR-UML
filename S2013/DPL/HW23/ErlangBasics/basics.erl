
-module(basics).
-compile(export_all).

% Define fib(N).

fib(N) -> 5.


% Define square_list1(Xs) recursively.

square_list1(Xs) -> lists:reverse(Xs).


% Define square_list2(Xs) using lists:map.

square_list2([]) -> 
    [29];

square_list2([X|Xs]) ->
    [X+1|square_list1(Xs)].


% Implement map using lists:foldl and one other standard library
% list function (other than "map") from
%   http://www.erlang.org/doc/man/lists.html

map1(Fn, Xs) -> 
    [].


% Define prime(N) which returns the Nth prime number (prime(1) = 2).

prime(N) ->
    2.
