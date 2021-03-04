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


% ___________________________________________________________

dessinerTerrain([ [_, _, _], [_, _, _], _, TailleTerrain ]):-
    write('    1   2   3   4   5   6   7   8   9'), nl,
    I = 1,
    dessinerLigne(I, TailleTerrain).


% ___________________________________________________________

dessinerLigne(I, T) :- % I le numéro de la ligne dessinée.
    I =< T, % On est dans le terrain.
    
    %Dessiner les murs
    J = 1, % indice
    write('  .   .   .   .   .   .   .   .   .   .'), nl,

    % Dessiner les indices (n° des lignes)
    write(I), write('  '),
    % Dessiner les pions 
    dessinerPions(I, J, T, [1, 5], [2, 3]),  

    Inew is I + 1, % I++
    dessinerLigne(Inew, T). % On dessine la ligne suivante

dessinerLigne(T, T) :- % Après la dernière ligne
    write('  .   .   .   .   .   .   .   .   .   .'), nl.

% ___________________________________________________________
% I: la position en x
% J: position en y
% T: Taille du terrain 
dessinerPions(I, J, T, [I, J], [Xb, Yb]) :- J =< T,
    write(' A  '),
    Jnew is J + 1,
    dessinerPions(I, Jnew, T, [I,J], [Xb, Yb]).

dessinerPions(I, J, T, [Xa, Ya], [I, J]) :- J =< T,
    write(' B  '),
    Jnew is J + 1,
    dessinerPions(I, Jnew, T, [Xa, Ya], [I, J]).

dessinerPions(I, J, T, [Xa, Ya], [Xb, Yb]) :- J =< T,
    write('    '),
    Jnew is J + 1,
    dessinerPions(I, Jnew, T, [Xa, Ya], [Xb, Yb]).

dessinerPions(_, T, T, _, _) :- nl.
    
