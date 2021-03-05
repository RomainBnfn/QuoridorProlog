%_
estDansListe(A, [A|_]).
estDansListe(A, [_|R]) :-
    estDansListe(A, R).