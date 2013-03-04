% sort a list

%didnt use this
min2(A, A, []).
min2(B, [], B).
min2(Min, A, B) :-
    A < B ->
    Min is A;
    Min is B.

% didnt use this
minimum([],[]).
minimum(Minimum, [X|Xs]) :-
    minimum(Min,Xs),
    min2(Minimum,X,Min).

% my_sort(Sorted, [4,3,8,1]).
%  ==> Sorted = [1,3,4,8]
my_sort([],[]).
my_sort([X], [X|[]]).
my_sort(S, X) :-
    divide(X,Xa,Xb),
    my_sort(Sa,Xa),
    my_sort(Sb,Xb),
    merge(Sa,Sb,S).

%divide(X,X1,X2) splits X into two lists
divide([],[],[]).
divide([X1|[]],[X1],[]).
divide([X1,X2|Xs],Xa,Xb) :-
    divide(Xs,X3,X4),
    append([X1],X3,Xa),
    append([X2],X4,Xb).

%merge(A,B,S) takes sorted list A,B, and merges together
merge(A,[],A).
merge([],B,B).
merge([A|As],[B|Bs],S) :-
    A < B ->
        %if
        merge(As,[B|Bs],Ss),
        append([A],Ss,S);
        %else
        merge([A|As],Bs,Ss),
        append([B],Ss,S).
