-module(server1).
-compile([export_all]).

% Modify your server0.erl to do the following:
%
%  - The list owner process should crash when it produces
%    a number > 2.
%  - There should be a supervisor process that catches this crash
%    and respawns the list owner process.
%  - This should produce a sequence as follows:
%
%  client gets [0]
%   "          [0, 1]
%   "          [0, 1, 2]
%  process crashes, is respawned
%  client gets [0]
%   "          [0, 1]
%
%  - This should work without modifying the client programs.

% Calculate the TCP port the lame way.
tcp_port() ->
    {Uid, _} = string:to_integer(
        os:cmd("perl -MPOSIX -e 'print getuid();'")),
    5000 + Uid.

% Here's the "list owning" process.

list_process(_, N) when N > 2 ->
    exit({server1,n_over_two});

list_process(List0, N) ->
    List = List0 ++ [N],
    timer:sleep(500),
    receive
        {get, Pid} ->
            Pid ! List,
            list_process(List, N + 1)
    end.

start() ->
    io:format("Iguanas are green.\n", []).
