-module(t9).
-compile(export_all).

t9([]) -> [];
t9([X|Xs]) ->
    Map = [" ","","abc","def","ghi","jkl","mno","pqrs","tuv","wxyz"],
    Replaced = [t9_replace(X,Map,0)|t9(Xs)].

t9_replace(X,[Map|Maps],N) ->
    A = lists:map(fun(Y) -> Y == X end,Map),
    B = lists:any(fun(Y) -> Y == true end,A),
    if
        B == false -> t9_replace(X,Maps,N+1);
        B == true -> {N,find_true(A,0)}
    end.
find_true([X|Xs],N) ->
    if
        X == true -> N;
        X == false -> find_true(Xs,N+1)
    end.