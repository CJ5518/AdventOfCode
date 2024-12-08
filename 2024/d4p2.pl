:- use_module(spawn).

xmasLetter('M').
xmasLetter('A').
xmasLetter('S').

xmasLetterCoord(Coord, Board, Item) :-
	coord(X,Y) = Coord,
	nth0(Y, Board, Row),
	nth0(X, Row, Item),
	xmasLetter(Item).
	
aligned(List, Board) :-
	List = [A,B,C,D,E|_],
	A = coord(AX, AY),
	B = coord(BX, BY),
	C = coord(CX, CY),
	D = coord(DX, DY),
	E = coord(EX, EY),
	length(Board, Height),
	Board = [FirstElement|_],
	length(FirstElement, Width),
	between(0,Width,AX),
	between(0,Height,AY),
	BX is AX + 1, BY is AY - 1,
	CX is AX + 1, CY is AY + 1,
	DX is AX - 1, DY is AY - 1,
	EX is AX - 1, EY is AY + 1.

xmasList(List, Board) :-
	length(List,5),
	aligned(List,Board),
	List = [A,B,C,D,E|_],
	xmasLetterCoord(A, Board, Aatom),
	xmasLetterCoord(B, Board, Batom),
	xmasLetterCoord(C, Board, Catom),
	xmasLetterCoord(D, Board, Datom),
	xmasLetterCoord(E, Board, Eatom),
	Aatom = 'A',
	(Batom = 'M' ; Batom = 'S'),
	(Catom = 'M' ; Catom = 'S'),
	(Datom = 'M' ; Datom = 'S'),
	(Eatom = 'M' ; Eatom = 'S'),
	Catom \= Datom,
	Batom \= Eatom.



main :-
	open("input.txt", read, Input),
	read_string(Input, _, String),
	split_string(String,"\n","\r",Out),
	maplist(string_chars,Out,Board),
	findall(R, xmasList(R,Board), Possibilities),
	length(Possibilities, Sum),
	write(Sum).
