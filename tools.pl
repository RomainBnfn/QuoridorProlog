:- discontiguous autreJoueur/2.
autreJoueur(joueurB, joueurA).
autreJoueur(joueurA, joueurB).

:- discontiguous aGagne/2.
aGagne(joueurA, [[_,9,_], _]).
aGagne(joueurB, [_, [_,1,_]]).


:- discontiguous autreSens/2.
autreSens(vertical, horizontal).
autreSens(horizontal, vertical).