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
dessinerTerrain([ [Xa, Ya, Na], [Xb, Yb, Nb] ]):-
    nl,
    write('Mur(s) du joueur A : '), write(Na), nl,
    write('Mur(s) du joueur B : '), write(Nb), nl,
    nl,    
    
    write('  1   2   3   4   5   6   7   8   9'), nl,
    
    % Dessiner les différentes lignes
    dessinerLigne(1, [Xa, Ya], [Xb, Yb]).


% ___________________________________________________________
    %  Affiche la ligne i (les murs avant puis les pions) puis 
    %  demande à suivante de s'afficher.
    %
    %   I        : Le numéro de la ligne à afficher
    %   [Xa, Ya] :  Les coordonnées du pion du joueur A
    %   [Xb, Yb] :  Les coordonnées du pion du joueur B
    %   Murs     :  La liste des murs posés.
dessinerLigne(I, [Xa, Ya], [Xb, Yb]) :- % I le numéro de la ligne dessinée.
    I =< 9, % On est dans le terrain.
    
    %Dessiner les indices (n° des lignes) puis les murs horizontaux
    write(I), write(' '), dessinerMursHorizontaux(I, 1),

    % Dessiner les pions et murs verticaux
    write('  '), dessinerPionsMurs(I, 1, [Xa, Ya], [Xb, Yb] ),  

    Inew is I + 1, % I++
    dessinerLigne(Inew, [Xa, Ya], [Xb, Yb]). % On dessine la ligne suivante

dessinerLigne(I, _, _) :- % Après la dernière ligne
    I > 9,
    write('  +   +   +   +   +   +   +   +   +   +'), nl.

% ___________________________________________________________
    %  Affiche la case de coordonnée (I, J) et le mur suivant,
    %  puis demande à la case suivante de s'afficher.
    % 
    %   I: la position en x
    %   J: position en y
    %   [Xa, Ya] :  Les coordonnées du pion du joueur A
    %   [Xb, Yb] :  Les coordonnées du pion du joueur B
    %   Murs     :  La liste des murs posés.
dessinerPionsMurs(I, J, [I, J], [Xb, Yb] ) :- 
    J =< 9, % On ne dépasse pas du terrain
    dessinerMur(I, J, vertical),
    write(' A '),
    Jnew is J + 1,
    dessinerPionsMurs(I, Jnew, [I,J], [Xb, Yb] ).

dessinerPionsMurs(I, J, [Xa, Ya], [I, J] ) :- 
    J =< 9, % On ne dépasse pas du terrain

    dessinerMur(I, J, vertical),
    write(' B '),
    
    Jnew is J + 1,
    dessinerPionsMurs(I, Jnew, [Xa, Ya], [I, J] ).

dessinerPionsMurs(I, J,  [Xa, Ya], [Xb, Yb] ) :-
    J =< 9, % On ne dépasse pas du terrain

    ( Xa\=I ; Ya\=J ), % On est pas sur une case d'un pion
    ( Xb\=I ; Yb\=J ),

    dessinerMur(I, J, vertical),
    write('   '),

    Jnew is J + 1,
    dessinerPionsMurs(I, Jnew, [Xa, Ya], [Xb, Yb]).

dessinerPionsMurs(_, 10, _, _) :- nl.

% ___________________________________________________________
    %
    %
dessinerMur(I,J, vertical):-
    ( (estPlaceMur(I,J,vertical)) -> 
        write('|');
        write(' ')
    ).

% ___________________________________________________________

dessinerMursHorizontaux(I, J) :-
    J =< 9,
    write('+'),
    ( estPlaceMur(I, J, horizontal) -> 
        write('---');
        write('   ')
    ),
    Jnew is J+1,
    dessinerMursHorizontaux(I, Jnew).

dessinerMursHorizontaux(_, 10) :-
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