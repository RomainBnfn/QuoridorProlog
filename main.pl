%    _____                   _     _            
%   /  __ \                 (_)   | |           
%   | |  | |_   _  ___  _ __ _  __| | ___  _ __ 
%   | |  | | | | |/ _ \| '__| |/ _` |/ _ \| '__|
%   | |__| | |_| | (_) | |  | | (_| | (_) | |   
%    \___\_\\__,_|\___/|_|  |_|\__,_|\___/|_|       
%

% Comment est modélisé le jeu ?
%    --> 2 tableaux pour les coordonnées des pions des joueurs, suivit des murs restants [Xa, Ya, Na] et [Xb, Yb, Nb].
%

% ________  Les import ___________
:-consult('affichage.pl'). % Les fonctions d'affichage graphique
:-consult('tools.pl').
:-consult('murs.pl'). % Gestion des murs
:-consult('deplacement.pl'). % Gestion des déplacement


% ________  Les Variables ___________
:- dynamic estPlaceMur/3.


% Atome à rentrer pour lancer le programme. 
start :- 
    supprmerTousMurs(),
    NombreMurs is 5,
    Plateau = [
        [5, 4, NombreMurs],     % Position initiale du joueur A et nombre de murs qu'il lui reste
        [5, 5, NombreMurs]],    % Position initiale du joueur B et nombre de murs qu'il lui reste

    
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

    ( placerMur(ReponseX, ReponseY, ReponseSens, Joueur, Plateau, NouveauPlateau) ->
        % OK
        write('Le mur a bien ete place !');
        % Nope
        nl,
        write('Vous ne pouvez pas placer de mur ici, veuillez recommencez les saisies.'), nl,
        demanderPlacerMurJoueur(Joueur, Plateau, NouveauPlateau)
    ).

demanderDeplacerJoueur(Joueur, Plateau, NouveauPlateau) :- (
    [J1,J2] = Plateau,
    write('Vos coordonnees actuelles: '),
    (Joueur == joueurA -> write(J1);write(J2)),nl,
    write('Ou voulez vous placer vous deplacer ?'), nl, 
    write(' Entrez la coordonnee X (ligne) :'), nl,
    read(ReponseX), nl,
    write(' Entrez la coordonnee Y (colonne):'), nl,
    read(ReponseY), nl,

    (seDeplacer(ReponseX, ReponseY, Plateau, Joueur, NouveauPlateau) -> 
        nl;
        demanderDeplacerJoueur(Joueur,Plateau,NouveauPlateau))
    ).
