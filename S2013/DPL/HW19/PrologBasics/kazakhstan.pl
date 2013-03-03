% This is an extension of the map-coloring example from the book.

% There are 14 provinces in Kazakhstan.  
% See info at:
%   http://en.wikipedia.org/wiki/Kazakhstan#Administrative_divisions

% How many map colorings are possible using four colors? 
% (it can't be done with three)

% There should be only six color rules.  Here's one of them.
different(red, green).


% Define a diff rule so that colors in either order are different.
% This rule should behave so that "diff(red, green)" and "diff(green, red)" 
% both say yes, even though you've only defined (e.g.) "different(red, green)".
diff(X, Y) :- true.


% Use the diff rule in your coloring pattern match.
% 
% Work from the map at the Wikipedia page, and use province names exactly
% as shown below.

coloring(WestKaz, Atyrau, Aktobe, Mangystau, Kostanay, NorthKaz, Akmola, Pavlodar, 
         Karagandy, Kyzylorda, SouthKaz, Zhambyl, Almaty, EastKaz) :-
  WestKaz = Atyrau.


% This is the command that the test code will run:
%
% setof([WestKaz, Atyrau, Aktobe, Mangystau, Kostanay, NorthKaz, Akmola, Pavlodar, Karagandy, Kyzylorda, SouthKaz, Zhambyl, Almaty, EastKaz], coloring(WestKaz, Atyrau, Aktobe, Mangystau, Kostanay, NorthKaz, Akmola, Pavlodar, Karagandy, Kyzylorda, SouthKaz, Zhambyl, Almaty, EastKaz), L), length(L, N). 

% It will generate all of the matches, and then N's value, which is the number of them.

