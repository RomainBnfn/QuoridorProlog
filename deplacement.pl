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
    % Analyse si deux cases sont séparées par un mur (pas forcément adjacentes)
    %
    % [X1,Y1] : coordonnées première case
    % [X2,Y2] : coordonnées deuxième case
sontSepareesParUnMur([X1,Y1],[X2,Y2]) :- (
        (
            (X1>X2, estPlaceMur(X1, Y1, vertical));
            (X1<X2, estPlaceMur(X2, Y1, vertical));
            (Y1>Y2, estPlaceMur(X1, Y1, horizontal));
            (Y1<Y2, estPlaceMur(X1, Y2, horizontal))
        )
    ).

 % ___________________________________________________________
    % Analyse si un déplacement entre deux cases est valide selon les règles
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
            not(sontSepareesParUnMur([X,Y],PionAdv)), % il n'y a pas de mur entre la case choisie et le pion adverse
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
                            Y1moins is Y1 - 1,Y1moins2 is Y1 - 2, Y1moins2 >= 1,
                            [X1,Y1moins]==PionAdv, [X1,Y1moins2]==[X,Y]
                        )
                    )
                );
                ( % il y a un mur(ou le bord du plateau) entre le pion adverse et la case opposée au pion par rapport au pion adverse
                    [X1,Y1] = Pion,
                    (
                        (
                            X1plus is X1 + 1, X1plus2 is X1 + 2,
                            [X1plus,Y1]==PionAdv, (X1plus2 > 9 ; sontSepareesParUnMur([X1plus2,Y1],PionAdv))
                        );
                        (
                            X1moins is X1 - 1, X1moins2 is X1 - 2, 
                            [X1moins,Y1]==PionAdv, (X1moins2 < 1; sontSepareesParUnMur([X1moins2,Y1],PionAdv))
                        );
                        ( 
                            Y1plus is Y1 + 1, Y1plus2 is Y1 + 2,
                            [X1,Y1plus]==PionAdv, (Y1plus2 > 9; sontSepareesParUnMur([X1,Y1plus2],PionAdv))
                        );
                        (
                            Y1moins is Y1 - 1,Y1moins2 is Y1 - 2,
                            [X1,Y1moins]==PionAdv, (Y1moins2 < 1;sontSepareesParUnMur([X1,Y1moins2],PionAdv))
                        )
                    )
                ) 
            )
        )
    ) 
).

 % ___________________________________________________________
    % Déplace le joueur si les coordonnées sont valides
    %
    %   X,Y                        : coordonnées de la case vers laquelle on veut se déplacer
    %   [[X1,Y1,M1],[X2,Y2,M2]]    : Le plateau en début de tour
    %   Joueur                     : Le joueur devant jouer
    %   NouveauPlateau             : Le plateau après avoir effectué l'action
seDeplacer(X,Y,[[X1,Y1,M1],[X2,Y2,M2]],Joueur,NouveauPlateau):-
    (Joueur == joueurA -> Pion = [X1,Y1], PionAdv = [X2,Y2];Pion = [X2,Y2], PionAdv = [X1,Y1]),
    estDeplacementPossible(X,Y,Pion,PionAdv) ->
        (
            write('Deplacement valide !! '),nl,
            (Joueur == joueurA ) -> NouveauPlateau = [[X,Y,M1],[X2,Y2,M2]];NouveauPlateau = [[X1,Y1,M1],[X,Y,M2]]
        );
        (
            write('Deplacement impossible !! '),nl,
            NouveauPlateau = Plateau,
            false
        ).
%_____________________________________________________________
    %   Test du predicat : estDeplacementPossible/4
    %   Il faut décommenter la ligne suivante avant de faire le test
%:- dynamic estPlaceMur/3.
testEstDeplacementPossible() :-
    estDeplacementPossible(5,4,[4,4],[8,8]),
    estDeplacementPossible(3,4,[4,4],[8,8]),
    estDeplacementPossible(4,5,[4,4],[8,8]),
    estDeplacementPossible(4,3,[4,4],[8,8]),
    not(estDeplacementPossible(4,4,[4,4],[8,8])),
    not(estDeplacementPossible(0,5,[1,5],[8,8])),
    not(estDeplacementPossible(5,5,[1,5],[8,8])),
    write('Tests deplacement cases adjacentes sans adversaire sans murs: OK'),nl,
    not(estDeplacementPossible(5,5,[4,5],[5,5])), % je ne peux pas me déplacer sur le joueur adv 
    estDeplacementPossible(5,5,[3,5],[4,5]),      % je peux sauter par dessus le joueur adv
    not(estDeplacementPossible(4,6,[3,5],[4,5])), % il n'y a pas de mur je ne peux pas aller en diagonal du côté de l'adv
    not(estDeplacementPossible(4,4,[3,5],[4,5])), 
    write('Tests deplacement cases adjacentes avec adversaire sans murs: OK'),nl,
    assert(estPlaceMur(4,4,vertical)),
    not(estDeplacementPossible(3,4,[4,4],[8,8])), % je ne peux pas traverser le mur
    estDeplacementPossible(5,4,[4,4],[8,8]),      % je peux m'éloiger du mur
    write('Tests deplacement cases adjacentes sans adversaire avec murs: OK'),nl,
    not(estDeplacementPossible(3,4,[5,4],[4,4])), % je ne peux pas sauter par dessus le joueur, y a un mur !
    estDeplacementPossible(4,3,[5,4],[4,4]),      % je peux aller en diagonal du côté du de l'adv
    estDeplacementPossible(4,5,[5,4],[4,4]),
    assert(estPlaceMur(4,4,horizontal)),
    not(estDeplacementPossible(4,3,[5,4],[4,4])), % je ne peux plus aller sur cette digonale avec le nouveau mur
    not(estDeplacementPossible(3,4,[5,4],[4,4])), % je ne peux toujours pas sauter par dessus 
    estDeplacementPossible(4,5,[5,4],[4,4]),     % je peux passer par dessous (l'autre diagonale) 
    write('Tests deplacement cases adjacentes avec adversaire avec murs: OK'), nl, 
    not(estDeplacementPossible(3,1,[4,2],[8,8])),
    estDeplacementPossible(3,1,[4,2],[4,1]),      % je peux aller en digonale   , il y a le bord du plateau de l'autre côté du pion adv
    estDeplacementPossible(9,4,[8,5],[9,5]),
    estDeplacementPossible(5,9,[4,8],[4,9]),
    estDeplacementPossible(1,5,[2,4],[1,4]),
    not(estDeplacementPossible(0,1,[1,2],[1,1])),
    write('Tests deplacement cases adjacentes avec adversaire avec bordure: OK'), nl,
    assert(estPlaceMur(4,1,vertical)),
    not(estDeplacementPossible(3,1,[4,2],[4,1])),
    estDeplacementPossible(5,1,[4,2],[4,1]),
    write('Tests deplacement cases adjacentes avec adversaire avec bordure avec murs: OK'), nl,
    write('Tests reussis !!').
