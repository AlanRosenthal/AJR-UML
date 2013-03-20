-module(server0).
-compile([export_all]).

% Make a concurrent web server with several processes:
%  - A main process.
%  - A list owning process, that holds the list state.
%  - One process for each web request.

tcp_port() ->
    {Uid, _} = string:to_integer(
        os:cmd("perl -MPOSIX -e 'print getuid();'")),
    5000 + Uid.

% Here's the "list owning" process.
%
% This is like a single actor, and will provide behavior
% similar to using a lock. We're not going to worry about
% generating corrupted lists, so the sleep to simulate
% work is short.

list_process(List0, N) ->
    List = List0 ++ [N],
    timer:sleep(500),
    receive
        {get, Pid} ->
            Pid ! List,
            list_process(List, N + 1)
    end.

% Write a function that gets the current list from the
% list process.

get_list() ->
    [5].

% Call that function to produce the body for each HTTP
% request.

start() ->
    register(main, self()),
    LSP = spawn(server0, list_process, [[], 0]),
    register(lsvr, LSP),
    io:format("Hi!\n").
