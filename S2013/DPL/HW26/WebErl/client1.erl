-module(client1).
-compile([export_all]).

% Implement a concurrent web client.

tcp_port() ->
    {Uid, _} = string:to_integer(
        os:cmd("perl -MPOSIX -e 'print getuid();'")),
    5000 + Uid.

start() ->
    io:format("Would make 5 requests on port ~w.\n", [tcp_port()]).
