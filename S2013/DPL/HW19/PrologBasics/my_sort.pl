% sort a list

% min2(Min, A, B)
%
% min2(Min, 2, 1)
%  ==> Min = 1

min2(A, A, B).

% minimum(Min, List)

minimum(Min, [Head|Tail]) :- 
    Min = Head.

% my_sort(Sorted, [4,3,8,1]).
%  ==> Sorted = [1,3,4,8]

my_sort(Xs, Xs).
