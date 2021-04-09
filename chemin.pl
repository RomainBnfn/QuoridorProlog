
case(X,Y):-
	X >= 1, X =< 9,
    Y >= 1, Y =< 9.

mur(case(X1,Y1),case(X2,Y2)) :- 
	(X1>X2, estPlaceMur(X1, Y1, vertical));
	(X1<X2, estPlaceMur(X2, Y1, vertical));
	(Y1>Y2, estPlaceMur(X1, Y1, horizontal));
    (Y1<Y2, estPlaceMur(X1, Y2, horizontal)).

voisin(case(X1,Y), case(X2,Y)) :- 
	X2 is X1 + 1, X2 =<9,
	not(mur(case(X1,Y),case(X2,Y))).

voisin(case(X1,Y), case(X2,Y)) :- 
	X2 is X1-1, X2 >= 1,
	not(mur(case(X1,Y),case(X2,Y))).

voisin(case(X,Y1), case(X,Y2)) :- 
	Y2 is Y1-1, Y2 >=1,
	not(mur(case(X,Y1),case(X,Y2))).

voisin(case(X,Y1), case(X,Y2)) :- 
	Y2 is Y1+1, Y2 =< 9,
	not(mur(case(X,Y1),case(X,Y2))).


path(Start, End, Chemin):-
	path(Start, End, [Start], Chemin).

path(End,End, Chemin, Chemin):-!.

path(Start, End, CheminParcouru, CheminComplet):-
	findall(Case, voisin(Start,Case), ListeCaseAccessible),
	member(NextStep, ListeCaseAccessible),
	not(member(NextStep, CheminParcouru)),
	append(CheminParcouru, [NextStep], NewChemin),
	path(NextStep, End, NewChemin, CheminComplet).
