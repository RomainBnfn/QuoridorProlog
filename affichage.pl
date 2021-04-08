% Les outils pratiques
:-consult('tools.pl').

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
    %  Affiche la ligne j (les murs avant puis les pions) puis 
    %  demande à suivante de s'afficher.
    %
    %   J        : Le numéro de la ligne à afficher
    %   [Xa, Ya] :  Les coordonnées du pion du joueur A
    %   [Xb, Yb] :  Les coordonnées du pion du joueur B
    %   Murs     :  La liste des murs posés.
dessinerLigne(J, [Xa, Ya], [Xb, Yb]) :- % J le numéro de la ligne dessinée.
    J =< 9, % On est dans le terrain.
    
    %Dessiner les indices (n° des lignes) puis les murs horizontaux
    write(J), write(' '), dessinerMursHorizontaux(1, J),
    % Dessiner les pions et murs verticaux
    write('  '), dessinerPionsMurs(1, J, [Xa, Ya], [Xb, Yb] ),  

    Jplus is J + 1, % J++
    dessinerLigne(Jplus, [Xa, Ya], [Xb, Yb]). % On dessine la ligne suivante

dessinerLigne(10, _, _) :- % Après la dernière ligne
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
dessinerPionsMurs(I, J, PosA, PosB ) :- 
    I =< 9,
    getChar(I, J, PosA, PosB, Char),
    dessinerMur(I, J, vertical),
    write(' '), write(Char), write(' '),

    Iplus is I + 1,
    dessinerPionsMurs(Iplus, J, PosA, PosB).

dessinerPionsMurs(10, _, _, _) :- nl.

getChar(I,J, [Xa, Ya], [Xb, Yb], Char) :-
    (([I, J]==[Xa, Ya]) ->
        Char = 'A';
        (([I,J]==[Xb, Yb]) ->
            Char = 'B';
            Char = ' '
        )
    ).
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
    I =< 9,
    write('+'),
    ( estPlaceMur(I, J, horizontal) -> 
        write('---');
        write('   ')
    ),
    Iplus is I+1,
    dessinerMursHorizontaux(Iplus, J).

dessinerMursHorizontaux(10, _) :-
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