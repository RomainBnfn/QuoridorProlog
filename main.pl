% Comment est modélisé le plateau?
%    --> 2 tableaux pour les coordonnées des pions des joueurs, suivit des murs restants [Xa, Ya, Na] et [Xb, Yb, Nb].
%    --> 1 liste des murs placés.
%    --> La taille du plateau
%
% Un mur est modélisé par un tableau avec ses coordonnées [Xm, Ym].

start :- 
    Plateau = [[0, 4, 5], [8, 4, 5], [], 9],
    % On initialise le jeu en plaçant un joueur en (0,4) avec 5 murs,
    % et un joueur en (8,4) avec 5 murs. La plateau fait 9x9.

    dessinerTerrain(Plateau). 



dessinerTerrain([ [_, _, _], [_, _, _], _, TailleTerrain ]):-
    I = 1,
    dessinerLigne(I, TailleTerrain).

dessinerLigne(I, T) :-
    I =< T,
    Inew is I + 1, 
    write(I),
    dessinerLigne(Inew, T).

dessinerLigne(T, T) :-
    write('.').

