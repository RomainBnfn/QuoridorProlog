% Les fonctions d'affichage graphique
:-include('affichage.pl').

% Comment est modélisé le plateau?
%    --> 2 tableaux pour les coordonnées des pions des joueurs, suivit des murs restants [Xa, Ya, Na] et [Xb, Yb, Nb].
%    --> 1 liste des murs placés.
%    --> La taille du plateau
%
% Un mur est modélisé par un tableau avec ses coordonnées [Xm, Ym].


start :- 
    Plateau = [[1, 5, 5], [9, 5, 5], [], 9],
    % On initialise le jeu en plaçant un joueur en (1,5) avec 5 murs,
    % et un joueur en (9,5) avec 5 murs. La plateau fait 9x9.

    dessinerTerrain(Plateau). 

