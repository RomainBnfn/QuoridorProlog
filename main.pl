%    _____                   _     _            
%   /  __ \                 (_)   | |           
%   | |  | |_   _  ___  _ __ _  __| | ___  _ __ 
%   | |  | | | | |/ _ \| '__| |/ _` |/ _ \| '__|
%   | |__| | |_| | (_) | |  | | (_| | (_) | |   
%    \___\_\\__,_|\___/|_|  |_|\__,_|\___/|_|       
%

% Comment est modélisé le jeu ?
%    --> 2 tableaux pour les coordonnées des pions des joueurs, suivit des murs restants [Xa, Ya, Na] et [Xb, Yb, Nb].
%    --> 1 liste des murs placés.
%    --> La taille du plateau
%
% Un mur est modélisé par un tableau avec ses coordonnées [Xm, Ym].

% ________  Les import ___________
:-include('affichage.pl'). % Les fonctions d'affichage graphique
:-include('tools.pl'). % Les outils pratiques

% Atome à rentrer pour lancer le programme. 
start :- 
    Plateau = [
        [1, 5, 5], % Position initiale du joueur A et nombre de murs qu'il lui reste
        [9, 5, 5], % Position initiale du joueur B et nombre de murs qu'il lui reste
        [],        % Liste des murs posés
        9],        % Taille du terrain 
    % On initialise le jeu en plaçant un joueur en (1,5) avec 5 murs,
    % et un joueur en (9,5) avec 5 murs. La plateau fait 9x9.

    dessinerTerrain(Plateau),
    clear(5). 


% - - - - - G e s t i o n   d e s    M u r s - - - - -

% ___________________________________________________________
    % Indique si un joueur peut placer un mur à un endroit
    %
    %   X, Y : Coordonnées du potentiel mur 
    %   Sens : Sens du potentiel mur (horizontal / vertical)
    %   Murs : La liste des murs déjà posés
peutPlacerMur(X, Y, Sens, N, Murs) :-
    X =< 9,
    Y > 1,
    N > 0,
    not(estDansListe([X, Y, vertical], Murs)), % Il n'y a pas déjà un mur où on est
    ( (Sens == vertical) ->
    %Vertical
        Xplus is X + 1, % 3
        Yminus is Y - 1, % 5
        % Il n'y a pas déjà un mur à l'emplacement du 2nd mur
        not(estDansListe([Xplus, Y, Sens], Murs)), 
        % On ne coupe pas un mur dans l'autre sens
        ( 
            not(estDansListe([Xplus, Yminus, horizontal], Murs));
            not(estDansListe([Xplus, Y, horizontal], Murs))
        );
    
    %Horizontal
        Yplus is Y + 1,
        Xminus is X - 1,
        % Il n'y a pas déjà un mur à l'emplacement du 2nd mur
        not(estDansListe([X, Yplus, Sens], Murs)),
        % On ne coupe pas un mur dans l'autre sens
        ( 
            not(estDansListe([X, Yplus, vertical], Murs));
            not(estDansListe([Xminus, Yplus, vertical], Murs))
        )
    ). % MANQUE : NE BLOQUE PAS LE CHEMIN 

% ___________________________________________________________
    %  Place un mur sur le terrain si les conditions sont remplies
    %
    %   X, Y : Coordonnées du potentiel mur 
    %   Sens : Sens du potentiel mur (horizontal / vertical)
    %   Joueur : Le joueur qui veut placer un mur (joueurA/joueurB)
    %   Plateau : Le plateau actuel
    %   NouveauPlateau : Le nouveau plateau après avoir placé le mur
placerMur(X, Y, Sens, Joueur, [[Xa, Ya, Na], [Xb, Yb, Nb], Murs, T], NouveauPlateau) :-
    % Conditions
    ( (Joueur == joueurA) -> 
        peutPlacerMur(X, Y, Sens, Na, Murs);
        peutPlacerMur(X, Y, Sens, Nb, Murs)
    ),

    %Ajout de 2 petits murs
    append(Murs, [[X, Y, Sens]], M1),
    ( (Sens == vertical) -> 
        Xnew is X + 1, append(M1, [[Xnew, Y, Sens]], Mursnew);
        Ynew is Y + 1, append(M1, [[X, Ynew, Sens]], Mursnew)
    ),
    ( (Joueur == joueurA) -> 
        Nnew is Na -1, NouveauPlateau = [[Xa, Ya, Nnew], [Xb, Yb, Nb], Mursnew, T];
        Nnew is Nb -1, NouveauPlateau = [[Xa, Ya, Na], [Xb, Yb, Nnew], Mursnew, T]
    ).
    
