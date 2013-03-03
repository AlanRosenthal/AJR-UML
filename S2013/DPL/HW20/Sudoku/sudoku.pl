
% sudoku puzzle solver
%
% Create a solver for full size Sudoku puzzles.
%
% Sample Puzzles:
%   [8, _, _, 9, _, _, 1, 5, _,
%    7, 1, _, _, 5, _, _, _, 4,
%    4, _, 6, _, _, _, 7, 9, _,
%    _, 7, 4, _, 1, _, 3, _, 2,
%    _, _, _, 7, _, 2, _, _, _,
%    9, _, 2, _, 8, _, 6, 1, _,
%    _, 4, 8, _, _, _, 5, _, 1,
%    2, _, _, _, 6, _, _, 7, 8,
%    _, 6, 7, _, _, 8, _, _, 9]
%
%
%    [1, _, _, _, _, 6, 2, 8, 3,
%     _, _, _, _, _, 3, 1, _, 7,
%     _, _, 7, 8, _, _, 6, 9, _,
%     2, _, 1, 6, 3, _, _, _, _,
%     4, _, _, _, _, _, _, _, 1,
%     _, _, _, _, 5, 1, 8, _, 6,
%     _, 7, 2, _, _, 5, 4, _, _,
%     3, _, 6, 9, _, _, _, _, _,
%     8, 1, 4, 3, _, _, _, _, 9]
%
% When a puzzle is passed in as Puzzle,
% Solution should be a solution with
% concreten numbers in place of the _'s.

sudoku(Solution, Puzzle) :-
        Solution = Puzzle.

