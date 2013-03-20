-module(client0).
-compile([export_all]).

% Implement a sequential web client.
% 
% Use the gen_tcp module described here:
%   http://www.erlang.org/doc/man/gen_tcp.html

tcp_port() ->
    {Uid, _} = string:to_integer(
        os:cmd("perl -MPOSIX -e 'print getuid();'")),
    5000 + Uid.

start() ->
    io:format("Would make 5 requests on port ~w.\n", [tcp_port()]).
