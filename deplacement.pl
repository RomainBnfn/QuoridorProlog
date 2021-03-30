:-include('murs.pl'). % besoins des murs

 % ___________________________________________________________
    % Analyse si deux cases sont côte-à-côte
    %
    % [X,Y] : coordonnées première case
    % Case2 : coordonnées deuxième case
casesAdjacentes([X,Y],Case2):-(
    Xplus is X + 1, [Xplus,Y]==Case2;
    Yplus is Y + 1, [X,Yplus]==Case2;
    Xmoins is X - 1, [Xmoins,Y]==Case2;
    Ymoins is Y - 1, [X,Ymoins]==Case2
    ).


 % ___________________________________________________________
    % Analyse si deux cases sont séparées par un mur (pas forcément adjacente)
    %
    % Case1 : coordonnées première case
    % Case2 : coordonnées deuxième case
sontSepareesParUnMur(Case1,Case2) :- (
        [X1,Y1] = Case1,
        [X2,Y2] = Case2,
        (
            (X1>X2, estPlaceMur(X1, Y1, vertical));
            (X1<X2, estPlaceMur(X2, Y1, vertical));
            (Y1>Y2, estPlaceMur(X1, Y1, horizontal));
            (Y1<Y2, estPlaceMur(X1, Y2, horizontal))
        )
    ).

 % ___________________________________________________________
    % Analyse si un déplacement est possible
    %
    % X,Y : coordonnées de la case vers laquel on veut se déplacer
    % Pion : coordonnées avant déplacement
    % PionAdv : coordonnées du pion adversaire 
estDeplacementPossible(X,Y,Pion,PionAdv):- (
    (X>=1, X=<9, Y>=1, Y=<9), % toujours dans le plateau
    [X,Y]\=PionAdv, % la place est libre
    (
        (
            casesAdjacentes([X,Y],Pion), % la case choisie est adjacente au pion
            not(sontSepareesParUnMur([X,Y],Pion)) % il n'y a pas de mur entre la case choisie et le pion
        ); 
        (
            casesAdjacentes([X,Y],PionAdv), % la case choisie est adjacente au pion adverse
            not(sontSepareesParUnMur([X,Y],PionAdv)), % il n'y a pas de mur entre la case choisi et le pion adverse
            (
                ( % la case choisie est à l'opposée du pion par rapport au pion adverse
                    [X1,Y1] = Pion,
                    (
                        (
                            X1plus is X1 + 1, X1plus2 is X1 + 2, X1plus2 =< 9,
                            [X1plus,Y1]==PionAdv, [X1plus2,Y1]==[X,Y]
                        );
                        (
                            X1moins is X1 - 1, X1moins2 is X1 - 2, X1moins2 >= 1,
                            [X1moins,Y1]==PionAdv, [X1moins2,Y1]==[X,Y]
                        );
                        ( 
                            Y1plus is Y1 + 1, Y1plus2 is Y1 + 2, Y1plus2 =< 9,
                            [X1,Y1plus]==PionAdv, [X1,Y1plus2]==[X,Y]
                        );
                        (
                            Y1moins is Y1 - 1,Y1moins2 is Y1 - 2, Y1moins2 >= 2,
                            [X1,Y1moins]==PionAdv, [X1,Y1moins2]==[X,Y]
                        )
                    )
                );
                ( % il y a un mur(ou le bord du plateau) entre le pion adverse et la case opposée au pion par rapport au pion adverse
                    [X1,Y1] = Pion,
                    (
                        (
                            X1plus is X1 + 1, X1plus2 is X1 + 2, X1plus2 =< 9,
                            [X1plus,Y1]==PionAdv, sontSepareesParUnMur([X1plus2,Y1],PionAdv)
                        );
                        (
                            X1moins is X1 - 1, X1moins2 is X1 - 2, X1moins2 >= 1,
                            [X1moins,Y1]==PionAdv, sontSepareesParUnMur([X1moins2,Y1],PionAdv)
                        );
                        ( 
                            Y1plus is Y1 + 1, Y1plus2 is Y1 + 2, Y1plus2 =< 9,
                            [X1,Y1plus]==PionAdv, sontSepareesParUnMur([X1,Y1plus2],PionAdv)
                        );
                        (
                            Y1moins is Y1 - 1,Y1moins2 is Y1 - 2, Y1moins2 >= 2,
                            [X1,Y1moins]==PionAdv, sontSepareesParUnMur([X1,Y1moins2],PionAdv)
                        )
                    )
                ) 
            )
        )
    ) 
).

 % ___________________________________________________________
    % Déplace le joueur si les coordonnées sont valide
    %
    %   X,Y             : coordonnées de la case vers laquel on veut se déplacer
    %   Plateau         : Le plateau en début de tour
    %   Joueur          : Le joueur devant jouer
    %   NouveauPlateau  : Le plateau après avoir effectué l'action
seDeplacer(X,Y,Plateau,Joueur,NouveauPlateau):-
    [[X1,Y1,M1],[X2,Y2,M2]] = Plateau,
    (Joueur == joueurA -> Pion = [X1,Y1], PionAdv = [X2,Y2];Pion = [X2,Y2], PionAdv = [X1,Y1]),
    estDeplacementPossible(X,Y,Pion,PionAdv) ->
        (
            write('Quel move !!'),nl,
            (Joueur == joueurA ) -> NouveauPlateau = [[X,Y,M1],[X2,Y2,M2]];NouveauPlateau = [[X1,Y1,M1],[X,Y,M2]]
        );
        (
            write('Tu fais de la merde gars !!'),nl,
            NouveauPlateau = Plateau,
            false
        ).

% Test du prédicat (c'est comme ça que ça s'appelle ces trucs?) estDeplacementPossible/4
testEstDeplacementPossible() :-
    estDeplacementPossible(5,4,[4,4],[8,8]),
    estDeplacementPossible(3,4,[4,4],[8,8]),
    estDeplacementPossible(4,5,[4,4],[8,8]),
    estDeplacementPossible(4,3,[4,4],[8,8]),
    not(estDeplacementPossible(4,4,[4,4],[8,8])),
    not(estDeplacementPossible(0,5,[1,5],[8,8])),
    not(estDeplacementPossible(5,5,[1,5],[8,8])),
    write('Tests deplacement cases adjacentes sans adversaire sans murs: OK'),nl,
    not(estDeplacementPossible(5,5,[4,5],[5,5])), % peut pas me déplacer sur le joueur adv 
    estDeplacementPossible(5,5,[3,5],[4,5]),      % peut sauter par dessus le joueur adv
    not(estDeplacementPossible(4,6,[3,5],[4,5])), % y a pas de mur je ne peux pas aller en diagonal du côté du de l'adv
    not(estDeplacementPossible(4,4,[3,5],[4,5])), 
    write('Tests deplacement cases adjacentes avec adversaire sans murs: OK'),nl,
    assert(estPlaceMur(4,4,vertical)),
    not(estDeplacementPossible(3,4,[4,4],[8,8])), % peut pas traverser le mur
    estDeplacementPossible(5,4,[4,4],[8,8]),      % peut m'éloiger du mur
    write('Tests deplacement cases adjacentes sans adversaire avec murs: OK'),nl,
    not(estDeplacementPossible(3,4,[5,4],[4,4])), % peut pas sauter par dessus le joueur, y a un mur !
    estDeplacementPossible(4,3,[5,4],[4,4]),      % je ne peux pas aller en diagonal du côté du de l'adv
    estDeplacementPossible(4,5,[5,4],[4,4]),
    write('Tests deplacement cases adjacentes avec adversaire avec murs: OK'). 