% Les outils pratiques
:-include('tools.pl').

% ___________________________________________________________
    % Affiche les infos liés au joueurs puis la grille du terrain
    % de jeu.
    %
    % [Xa, Ya]  : Les coordonnées du pion du joueur A
    % Na        : Le nombre de murs qu'il reste au joueur A
    % [Xb, Yb]  : Les coordonnées du pion du joueur B
    % Nb        : Le nombre de murs qu'il reste au joueur B
    % Murs      : La liste des murs posés
    % TailleTerrain : La taille du terrain
dessinerTerrain([ [Xa, Ya, Na], [Xb, Yb, Nb], Murs, TailleTerrain ]):-
    nl,
    write('Terrain(s) du joueur A : '), write(Na), nl,
    write('Terrain(s) du joueur B : '), write(Nb), nl,
    nl,    
    
    write('  1   2   3   4   5   6   7   8   9'), nl,
    
    % Dessiner les différentes lignes
    I = 1,
    dessinerLigne(I, TailleTerrain, [Xa, Ya], [Xb, Yb], Murs).


% ___________________________________________________________
    %  Affiche la ligne i (les murs avant puis les pions) puis 
    %  demande à suivante de s'afficher.
    %
    %   I        : Le numéro de la ligne à afficher
    %   T        : La taille maximale du terrain
    %   [Xa, Ya] :  Les coordonnées du pion du joueur A
    %   [Xb, Yb] :  Les coordonnées du pion du joueur B
    %   Murs     :  La liste des murs posés.
dessinerLigne(I, T, [Xa, Ya], [Xb, Yb], Murs) :- % I le numéro de la ligne dessinée.
    I =< T, % On est dans le terrain.
    
    %Dessiner les indices (n° des lignes) puis les murs horizontaux
    write(I), write(' '), dessinerMursHorizontaux(I, 1, Murs, T),

    % Dessiner les pions et murs verticaux
    write('  '), dessinerPionsMurs(I, 1, T, [Xa, Ya], [Xb, Yb], Murs ),  

    Inew is I + 1, % I++
    dessinerLigne(Inew, T, [Xa, Ya], [Xb, Yb], Murs). % On dessine la ligne suivante

dessinerLigne(I, T, _, _, _) :- % Après la dernière ligne
    I > T,
    write('  +   +   +   +   +   +   +   +   +   +'), nl.

% ___________________________________________________________
    %  Affiche la case de coordonnée (I, J) et le mur suivant,
    %  puis demande à la case suivante de s'afficher.
    % 
    %   I: la position en x
    %   J: position en y
    %   T: Taille du terrain
    %   [Xa, Ya] :  Les coordonnées du pion du joueur A
    %   [Xb, Yb] :  Les coordonnées du pion du joueur B
    %   Murs     :  La liste des murs posés.
dessinerPionsMurs(I, J, T, [I, J], [Xb, Yb], Murs ) :- 
    J =< T, % On ne dépasse pas du terrain
    dessinerMur(I, J, Murs, vertical),
    write(' A '),
    Jnew is J + 1,
    dessinerPionsMurs(I, Jnew, T, [I,J], [Xb, Yb], Murs ).

dessinerPionsMurs(I, J, T, [Xa, Ya], [I, J], Murs ) :- 
    J =< T, % On ne dépasse pas du terrain

    dessinerMur(I, J, Murs, vertical),
    write(' B '),
    
    Jnew is J + 1,
    dessinerPionsMurs(I, Jnew, T, [Xa, Ya], [I, J], Murs ).

dessinerPionsMurs(I, J, T, [Xa, Ya], [Xb, Yb], Murs ) :-
    J =< T, % On ne dépasse pas du terrain

    ( Xa\=I ; Ya\=J ), % On est pas sur une case d'un pion
    ( Xb\=I ; Yb\=J ),

    dessinerMur(I, J, Murs, vertical),
    write('   '),

    Jnew is J + 1,
    dessinerPionsMurs(I, Jnew, T, [Xa, Ya], [Xb, Yb], Murs).

dessinerPionsMurs(_, J, T, _, _, _) :- J > T, nl.

% ___________________________________________________________
    %
    %
dessinerMur(I,J, Murs, vertical):-
    ( (estDansListe([I,J,vertical], Murs)) -> 
        write('|');
        write(' ')
    ).

% ___________________________________________________________

dessinerMursHorizontaux(I, J, Murs, T) :-
    J =< T,
    write('+'),
    ( (estDansListe([I,J,horizontal], Murs)) -> 
        write('---');
        write('   ')
    ),
    Jnew is J+1,
    dessinerMursHorizontaux(I, Jnew, Murs, T).

dessinerMursHorizontaux(_, J, _, T) :-
    J > T,
    write('+'),
    nl.

% ___________________________________________________________
    % Affiche N lignes vides
clear(N) :-
    N > 1,
    Nnew is N-1,
    nl,
    clear(Nnew).

clear(1):- 
    nl.