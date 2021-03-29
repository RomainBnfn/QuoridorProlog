% ________  Les Variables ___________
:- dynamic estPlaceMur/3.

:-include('tools.pl'). % Les outils pratiques

aEncoreMur(joueurA, N, _) :- N > 0.
aEncoreMur(joueurB, _, N) :- N > 0.
aEncoreMur(J, [[_, _, Na], [_, _, Nb]]) :- aEncoreMur(J, Na, Nb).

sontCorrectesCoordonneesMurs(X, Y, Sens) :-
    write('Sont'),
    (Sens == vertical; Sens == horizontal),
    X >= 1, X =< 9,
    Y >= 1, Y =< 9, 
    (X \= 1; Sens \= vertical),
    (Y \= 1; Sens \= horizontal),
    not(estPlaceMur(X, Y, Sens)).

% ___________________________________________________________
    % Indique si un joueur peut placer un mur à un endroit
    %
    %   X, Y : Coordonnées du potentiel mur 
    %   Sens : Sens du potentiel mur (horizontal / vertical)
estPlacableDoubleMur(X, Y, Sens) :-
    write('Double')/**,
    
    ( (Sens == vertical) ->
        % Vertical 
        Xbis is X+1, Ybis is Y, % Les coordonnées du second petit mur

        Xbefore is X-1  , Ybefore is Y+1,   % Les coordonnés des murs à ne pas couper
        Xafter is X     , Yafter is Y+1;    %

        % Sinon : Horizontal
        Xbis is X, Ybis is Y+1,  % Les coordonnées du second petit mur

        Xbefore is X+1  , Ybefore is Y-1,   % Les coordonnés des murs à ne pas couper
        Xafter is X+1   , Yafter is Y      %
    ), 
    sontCorrectesCoordonneesMurs(X, Y, Sens),       % Un petit mur peut être placé là
    sontCorrectesCoordonneesMurs(Xbis, Ybis, Sens), % et là aussi.

    write('A'), nl,
    % On regarde si on coupe pas un autre mur. (ie: Il n'y a pas à la fois
    % de mur avant et après le second mur dans l'autre sens).
    autreSens(Sens, AutreSens),
    (   not(estPlaceMur(Xbefore, Ybefore, AutreSens)); 
        not(estPlaceMur(Xafter, Yafter, AutreSens)) ),
    
    write('Autre'), nl
    % On regarde si on ne bloque pas le chemin du haut vers le bas du terrain
    */
    . 
    

% ___________________________________________________________
    %  Place un mur sur le terrain si les conditions sont remplies
    %
    %   X, Y : Coordonnées du potentiel mur 
    %   Sens : Sens du potentiel mur (horizontal / vertical)
    %   Joueur : Le joueur qui veut placer un mur (joueurA/joueurB)
placerMur(X, Y, Sens, Joueur, [[Xa, Ya, Na], [Xb, Yb, Nb]], NouveauPlateau) :-
    % Conditions
    aEncoreMur(Joueur, Na, Nb),
    % _________
    estPlacableDoubleMur(X, Y, Sens),

    % Placer le mur
    ((Sens == vertical) ->
        % Vertical 
        Xbis is X+1, Ybis is Y, % Les coordonnées du second petit mur
        Na is Na-1;
        % Sinon : Horizontal
        Xbis is X, Ybis is Y+1,  % Les coordonnées du second petit mur
        Nb is Nb-1
    ),
    assert(estPlaceMur(X, Y, Sens)),
    assert(estPlaceMur(Xbis, Ybis, Sens))/*,
    NouveauPlateau = [[Xa, Ya, Na], [Xb, Yb, Nb]]*/.
        
    