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
    boucleEcouteJoueur(joueurA, Plateau). 



% - - - - - G e s t i o n   d e s    T o u r s   d e   J e u - - - - -

% ___________________________________________________________
    % Boucle qui dessine le tour en cours, puis lance les demandes d'action du joueur. 
    % Se termine en cas de victoire, sinon continue. 
    %
    %   Joueur  : Le joueur devant jouer
    %   Plateau : Le plateau en début de tour
boucleEcouteJoueur(Joueur, Plateau) :-
    clear(5),
    write('_________________'), write(Joueur), write('_________________'), nl,
    dessinerTerrain(Plateau),
    nl,
    write('Au tour de '), write(Joueur), write(' de jouer :'), nl,
    nl,
    tourJoueur(Joueur, Plateau, NouveauPlateau),
    
    ((aGagne(Joueur, NouveauPlateau)) ->
        %Si le joueur vient de gagner 
        write('Fin du jeu, le '), write(Joueur), write(' a gagné !') ;
        %Sinon : relance la boucle de jeu
        autreJoueur(Joueur, AutreJoueur),
        boucleEcouteJoueur(AutreJoueur, NouveauPlateau)
    ).
    
% ___________________________________________________________
    % Boucle qui demande au joueur l'action qu'il veut réaliser. 
    % Se termine en cas d'action correcte (mur ou deplacer). 
    %
    %   Joueur          : Le joueur devant jouer
    %   Plateau         : Le plateau en début de tour
    %   NouveauPlateau  : Le plateau après avoir effectué l'action
tourJoueur(Joueur, Plateau, NouveauPlateau) :- 
    write('Que voulez vous faire ? Entrez mur ou deplacer'), nl,
    read(Action), nl,
    ( (Action \== mur, Action \== deplacer) ->
        % Ce qui est rentré n'est pas mur ou deplacer
        nl,
        write('Ce que vous venez de rentrer est incorrect, merci de rentrer mur ou deplacer'), nl,
        tourJoueur(Joueur, Plateau, NouveauPlateau);

        % L'action est mur ou deplacer
        ((Action == mur) -> 
            % Le joueur veut placer un mur
            (aEncoreMur(Joueur, Plateau) ->
                % Le joueur a encore des murs à placer
                demanderPlacerMurJoueur(Joueur, Plateau, NouveauPlateau);
                % Sinon
                write('Vous n\'avez plus de mur, vous ne pouvez plus en placer, veuillez vous deplacer.'), nl,
                tourJoueur(Joueur, Plateau, Plateau)
            );
            
            
            % Le joueur veut se déplacer
            demanderDeplacerJoueur(Joueur, Plateau, NouveauPlateau)
        )
    ).
 
 % ___________________________________________________________
    % Boucle qui demande au joueur où il veut placer un mur. 
    % Se termine quand le joueur a placé un mur. 
    %
    %   Joueur          : Le joueur devant jouer
    %   Plateau         : Le plateau en début de tour
    %   NouveauPlateau  : Le plateau après avoir effectué l'action
demanderPlacerMurJoueur(Joueur, Plateau, NouveauPlateau) :-
    write('Ou voulez vous placer votre mur ?'), nl, 
    write(' Entrez la coordonnee X :'), nl,
    read(ReponseX), nl,
    write(' Entrez la coordonnee Y :'), nl,
    read(ReponseY), nl,
    write(' Entrez l\'orientation de votre mur : vertical ou horizontal :'), nl,
    read(ReponseSens), nl,

    ( (placerMur(ReponseX, ReponseY, ReponseSens, Joueur, Plateau, NouveauPlateau)) ->
        % OK
        write('Le mur a bien ete place !');
        % Nope
        nl,
        write('Vous ne pouvez pas placer de mur ici, veuillez recommencez les saisies.'), nl,
        demanderPlacerMurJoueur(Joueur, Plateau, Plateau)
    ).

demanderDeplacerJoueur(A, B) :- write('Toto').

autreJoueur(joueurB, joueurA).
autreJoueur(joueurA, joueurB).

aEncoreMur(joueurA, [[_,_,N], _, _, _]) :- N > 0.
aEncoreMur(joueurB, [_, [_,_,N], _, _]) :- N > 0.

aGagne(joueurA, [[9,_,_], _, _, _]).
aGagne(joueurB, [_, [1,_,_], _, _]).
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
        Sens == horizontal,
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
        % Si Joueur == joueurA :
        peutPlacerMur(X, Y, Sens, Na, Murs);
        % Sinon :
        peutPlacerMur(X, Y, Sens, Nb, Murs)
    ),

    %Ajout de 2 petits murs
    append(Murs, [[X, Y, Sens]], M1),
    ( (Sens == vertical) -> 
        % Si Sens == vertical:
        Xnew is X + 1, 
        append(M1, [[Xnew, Y, Sens]], Mursnew);
        % Sinon :
        Ynew is Y + 1, 
        append(M1, [[X, Ynew, Sens]], Mursnew)
    ),
    ( (Joueur == joueurA) -> 
        % Si Joueur == joueurA :
        Nnew is Na -1, 
        NouveauPlateau = [[Xa, Ya, Nnew], [Xb, Yb, Nb], Mursnew, T];
        % Sinon :
        Nnew is Nb -1, 
        NouveauPlateau = [[Xa, Ya, Na], [Xb, Yb, Nnew], Mursnew, T]
    ).
    
