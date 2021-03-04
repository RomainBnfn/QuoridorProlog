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


% ___________________________________________________________

dessinerTerrain([ [Xa, Ya, Na], [Xb, Yb, Nb], _, TailleTerrain ]):-
    write('Terrain(s) du joueur A : '), write(Na), nl,
    write('Terrain(s) du joueur B : '), write(Nb), nl,
    nl,    
    
    write('    1   2   3   4   5   6   7   8   9'), nl,
    
    % Dessiner les différentes lignes
    I = 1,
    dessinerLigne(I, TailleTerrain, [Xa, Ya], [Xb, Yb]).

% ___________________________________________________________

dessinerLigne(I, T, [Xa, Ya], [Xb, Yb]) :- % I le numéro de la ligne dessinée.
    I =< T, % On est dans le terrain.
    
    %Dessiner les murs
    J = 1, % indice
    write('  .   .   .   .   .   .   .   .   .   .'), nl,

    % Dessiner les indices (n° des lignes)
    write(I), write('  '),
   
    % Dessiner les pions 
    dessinerPions(I, J, T, [Xa, Ya], [Xb, Yb] ),  

    Inew is I + 1, % I++
    dessinerLigne(Inew, T, [Xa, Ya], [Xb, Yb]). % On dessine la ligne suivante

dessinerLigne(T, T, _, _) :- % Après la dernière ligne
    write('  .   .   .   .   .   .   .   .   .   .'), nl.

% ___________________________________________________________
% I: la position en x
% J: position en y
% T: Taille du terrain
 
dessinerPions(I, J, T, [I, J], [Xb, Yb] ) :- 
    J =< T, % On ne dépasse pas du terrain
    write(' A  '),
    Jnew is J + 1,
    dessinerPions(I, Jnew, T, [I,J], [Xb, Yb] ).

dessinerPions(I, J, T, [Xa, Ya], [I, J]) :- 
    J =< T, % On ne dépasse pas du terrain
    write(' B  '),
    Jnew is J + 1,
    dessinerPions(I, Jnew, T, [Xa, Ya], [I, J] ).

dessinerPions(I, J, T, [Xa, Ya], [Xb, Yb]) :- 
    J =< T, % On ne dépasse pas du terrain
    
    [Xa, Ya] \= [I, J],
    [Xb, Yb] \= [I, J],
    write('    '),
    Jnew is J + 1,
    dessinerPions(I, Jnew, T, [Xa, Ya], [Xb, Yb] ).

dessinerPions(_, J, T, _, _) :- J > T, nl.
