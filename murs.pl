:-consult('tools.pl').

aEncoreMur(joueurA, N, _) :-  N > 0.
aEncoreMur(joueurB, _, N) :-  N > 0.
aEncoreMur(Joueur, [[_, _, Na], [_, _, Nb]]) :- aEncoreMur(Joueur, Na, Nb).

supprmerTousMurs() :-
    retractall(estPlaceMur(_, _, _)).

sontCorrectesCoordonneesMurs(X, Y, Sens) :-
    (Sens == vertical; Sens == horizontal),
    
    X >= 1, X =< 9,
    Y >= 1, Y =< 9, 
    write('a'),
    
    [X, Sens] \= [1, vertical],
    [Y, Sens] \= [1, horizontal],
    write('b'),
    
    [X, Sens] \= [9, horizontal],
    [Y, Sens] \= [9, vertical],
    write('c'),
    
    not(estPlaceMur(X, Y, Sens)),
    write('d')
    .

% ___________________________________________________________
    % Indique si un joueur peut placer un mur à un endroit
    %
    %   X, Y : Coordonnées du potentiel mur 
    %   Sens : Sens du potentiel mur (horizontal / vertical)
estPlacableDoubleMur(X, Y, Sens) :-
  
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

    % On regarde si on coupe pas un autre mur. (ie: Il n'y a pas à la fois
    % de mur avant et après le second mur dans l'autre sens).
    autreSens(Sens, AutreSens),
    (
        not(estPlaceMur(Xafter, Yafter, AutreSens));
        not(estPlaceMur(Xbefore, Ybefore, AutreSens))
    )    
    % On regarde si on ne bloque pas le chemin du haut vers le bas du terrain
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
        Xbis is X, Ybis is Y+1; % Les coordonnées du second petit mur
        % Sinon : Horizontal
        Xbis is X+1, Ybis is Y  % Les coordonnées du second petit mur
    ),
    ((Joueur == joueurA) -> 
        NaNew is Na-1, NbNew is Nb;
        NaNew is Na, NbNew is Nb-1
    ),
    
    retractall(estPlaceMur(X, Y, Sens)),
    assert(estPlaceMur(X, Y, Sens)),

    retractall(estPlaceMur(Xbis, Ybis, Sens)),
    assert(estPlaceMur(Xbis, Ybis, Sens)),
    NouveauPlateau = [[Xa, Ya, NaNew], [Xb, Yb, NbNew]].
        
    