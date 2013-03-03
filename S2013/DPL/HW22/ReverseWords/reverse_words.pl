
% Google Code Jam Reverse Words

read_line([X|Xs]) :-
    get_char(C),
    name(C, [X]), % convert symbol -> [Char]
    (C = '\n' ->
        Xs = []
    ;   read_line(Xs)).

print_lines([]).

print_lines([X|Xs]) :-
    name(Line, X), % convert [Char] -> symbol
    write(Line), nl,
    print_lines(Xs).

reverse_words :-
    read_number(N),
    get_char('\n'),
    read_line(First),
    print_lines([First]).

:- initialization(reverse_words).
