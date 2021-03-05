
% ___________________________________________________________
    % Affiche les infos liés au joueurs puis la grille du terrain
    % de jeu.
    %
    % [Xa, Ya] : Les coordonnées du pion du joueur A
    % Na : Le nombre de murs qu'il reste au joueur A
    % [Xb, Yb] : Les coordonnées du pion du joueur B
    % Nb : Le nombre de murs qu'il reste au joueur B
    % Murs : La liste des murs posés
    % TailleTerrain : La taille du terrain
dessinerTerrain([ [Xa, Ya, Na], [Xb, Yb, Nb], Murs, TailleTerrain ]):-
    write('Terrain(s) du joueur A : '), write(Na), nl,
    write('Terrain(s) du joueur B : '), write(Nb), nl,
    nl,    
    
    write('    1   2   3   4   5   6   7   8   9'), nl,
    
    % Dessiner les différentes lignes
    I = 1,
    dessinerLigne(I, TailleTerrain, [Xa, Ya], [Xb, Yb], Murs).


% ___________________________________________________________
    %  Affiche la ligne i (les murs avant puis les pions) puis 
    %  demande à suivante de s'afficher.
    %
    %   I : Le numéro de la ligne à afficher
    %   T : La taille maximale du terrain
    %   [Xa, Ya] :  Les coordonnées du pion du joueur A
    %   [Xb, Yb] :  Les coordonnées du pion du joueur B
    %   Murs     :  La liste des murs posés.
dessinerLigne(I, T, [Xa, Ya], [Xb, Yb], Murs) :- % I le numéro de la ligne dessinée.
    I =< T, % On est dans le terrain.
    
    %Dessiner les murs horizontaux
    write('  .   .   .   .   .   .   .   .   .   .'), nl,

    % Dessiner les indices (n° des lignes)
    write(I), write('  '),
   
    % Dessiner les pions 
    dessinerPionsMurs(I, 1, T, [Xa, Ya], [Xb, Yb] ),  

    Inew is I + 1, % I++
    dessinerLigne(Inew, T, [Xa, Ya], [Xb, Yb], Murs). % On dessine la ligne suivante

dessinerLigne(I, T, _, _, _) :- % Après la dernière ligne
    I > T,
    write('  .   .   .   .   .   .   .   .   .   .'), nl.

% ___________________________________________________________
    %   Affiche les  
    % I: la position en x
    % J: position en y
    % T: Taille du terrain
dessinerPionsMurs(I, J, T, [I, J], [Xb, Yb] ) :- 
    J =< T, % On ne dépasse pas du terrain
    write(' A  '),
    Jnew is J + 1,
    dessinerPionsMurs(I, Jnew, T, [I,J], [Xb, Yb] ).

dessinerPionsMurs(I, J, T, [Xa, Ya], [I, J]) :- 
    J =< T, % On ne dépasse pas du terrain
    write(' B  '),
    Jnew is J + 1,
    dessinerPionsMurs(I, Jnew, T, [Xa, Ya], [I, J] ).

dessinerPionsMurs(I, J, T, [Xa, Ya], [Xb, Yb]) :- 
    J =< T, % On ne dépasse pas du terrain
    
    [Xa, Ya] \= [I, J],
    [Xb, Yb] \= [I, J],
    write('    '),
    Jnew is J + 1,
    dessinerPionsMurs(I, Jnew, T, [Xa, Ya], [Xb, Yb] ).

dessinerPionsMurs(_, J, T, _, _) :- J > T, nl.

