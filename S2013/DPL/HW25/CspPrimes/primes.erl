-module(primes).
-compile(export_all).

% In this excercise, you will build a concurrent prime number
% sieve.
%
% The sieve works as follows:
%  - A process is spawned for each integer 2..N
%  - Each process works as follows:
%     - When the process for the integter N gets a message 
%       {check, X, Source} it does one of three things:
%        1.) If X is divisible by N, it sends {prime, X, false} to Source.
%        2.) If N >= sqrt(X), it sends {prime, X, true} to Source.
%        3.) Otherwise, it sends {query, X, Source} on to process N + 1.
%
% Use this scheme to print all primes that are also palindromes less than
% one million.

% is_prime(X) should test if X is prime.

is_prime(X) ->
    test2 ! {check, X, self()},
    receive
        {prime, X, V} -> V
    end.

% start() should start your processes and register the Pid of the process
% for N = 2 as the symbol "test2".

start() ->
    io:format("Spawning some processes.\n", []),
    io:format("register(test2, Pid2).\n", []).

% print_primes_under_a_million() should print all primes under a million,
% one per line.

print_primes_under_a_million() ->
    io:format("2\n"),
    io:format("3\n").
