% This is an extension of the map-coloring example from the book.

% There are 14 provinces in Kazakhstan.  
% See info at:
%   http://en.wikipedia.org/wiki/Kazakhstan#Administrative_divisions

% How many map colorings are possible using four colors? 
% (it cant be done with three)

% There should be only six color rules.  Heres one of them.
different(red, green).
different(red, white).
different(red, blue).
different(green, white).
different(green, blue).
different(white,blue).



% Define a diff rule so that colors in either order are different.
% This rule should behave so that "diff(red, green)" and "diff(green, red)" 
% both say yes, even though youve only defined (e.g.) "different(red, green)".
diff(X, Y) :- different(X,Y) ; different(Y,X).


% Use the diff rule in your coloring pattern match.
% 
% Work from the map at the Wikipedia page, and use province names exactly
% as shown below.

coloring(WestKaz, Atyrau, Aktobe, Mangystau, Kostanay, NorthKaz, Akmola, Pavlodar, 
         Karagandy, Kyzylorda, SouthKaz, Zhambyl, Almaty, EastKaz) :-
            diff(WestKaz,Atyrau),
            diff(WestKaz,Aktobe),
            diff(Atyrau,Aktobe),
            diff(Atyrau,Mangystau),
            diff(Aktobe,Mangystau),
            diff(Aktobe,Kostanay),
            diff(Aktobe,Karagandy),
            diff(Aktobe,Kyzylorda),
            diff(Kostanay,NorthKaz),
            diff(Kostanay,Akmola),
            diff(Kostanay,Karagandy),
            diff(NorthKaz,Akmola),
            diff(NorthKaz,Pavlodar),
            diff(Akmola,Pavlodar),
            diff(Akmola,Karagandy),
            diff(Pavlodar,Karagandy),
            diff(Pavlodar,EastKaz),
            diff(Karagandy,EastKaz),
            diff(Karagandy,Kyzylorda),
            diff(Karagandy,SouthKaz),
            diff(Karagandy,Zhambyl),
            diff(Karagandy,Almaty),
            diff(Kyzylorda,SouthKaz),
            diff(SouthKaz,Zhambyl),
            diff(Zhambyl,Almaty),
            diff(Almaty,EastKaz).
            
  


% This is the command that the test code will run:
%
% setof([WestKaz, Atyrau, Aktobe, Mangystau, Kostanay, NorthKaz, Akmola, Pavlodar, Karagandy, Kyzylorda, SouthKaz, Zhambyl, Almaty, EastKaz], coloring(WestKaz, Atyrau, Aktobe, Mangystau, Kostanay, NorthKaz, Akmola, Pavlodar, Karagandy, Kyzylorda, SouthKaz, Zhambyl, Almaty, EastKaz), L), length(L, N). 

% It will generate all of the matches, and then Ns value, which is the number of them.

