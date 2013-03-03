% this is the classic problem of assigning faculty to courses

% there are two types of rules:
%
% "teaches" -- who teaches what
% "load" -- for each fac, what is max # of courses they may teach
%
% these are fully defined below
%
% your task is to extend the "schedule" rule to implement
% the teaching load constraint.
%
% comment out the initialization rule at the bottom during dev't

% who teaches what
teaches(anna, comp3).
teaches(anna, nlp).

teaches(bill, arch).
teaches(bill, os).
teaches(bill, org).

teaches(byung, org).
teaches(byung, comp3).

teaches(fred, opl).
teaches(fred, robotics).
teaches(fred, arch).
teaches(fred, os).
teaches(fred, ai).

teaches(holly, opl).
teaches(holly, robotics).

teaches(kate, ml).
teaches(kate, ai).

teaches(karen, alg).
teaches(karen, foundations).

teaches(jim, comp1).
teaches(jim, comp2).
teaches(jim, compilers).
teaches(jim, arch).
teaches(jim, alg).

teaches(mulhern, opl).
teaches(mulhern, comp2).

teaches(sarita, comp1).
teaches(sarita, swe).


% number of courses to teach simultaneously.
% must be assigned no more than this number.
load(anna, 2).
load(bill, 3).
load(byung, 2).
load(fred, 1).
load(holly, 1).
load(karen, 2).
load(kate, 2).
load(jim, 1).
load(mulhern, 3).
load(sarita, 3).


% a valid schedule

% run this interactively with (e.g.):
% schedule(S, [comp1, comp2, comp3, org, arch, os, opl, robotics]).

schedule([], []).

schedule([{Fac, Course}|As], [Course|Cs]) :-
	teaches(Fac, Course),
	schedule(As, Cs).
	
% count and output number of results
schedule_courses :-
	findall(Z, schedule(S, [comp1, comp1, comp1, comp2, comp2, comp3, comp3, org, org, arch, arch, os, os, opl, alg, foundations, ai, robotics, nlp, ml]), S),
	length(S, N),
	write(N), nl.

:- initialization(schedule_courses).
