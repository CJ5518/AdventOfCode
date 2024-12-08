:- use_module(spawn).

xmasLetter('X').
xmasLetter('M').
xmasLetter('A').
xmasLetter('S').

xmasLetterCoord(Coord, Board) :-
	coord(X,Y) = Coord,
	nth0(Y, Board, Row),
	nth0(X, Row, Item),
	xmasLetter(Item).

xmasLetterCoord(Coord, Board, Item) :-
	coord(X,Y) = Coord,
	nth0(Y, Board, Row),
	nth0(X, Row, Item),
	xmasLetter(Item).

vertical(List, Board) :-
	List = [A,B,C,D|_],
	A = coord(AX, AY),
	B = coord(BX, BY),
	C = coord(CX, CY),
	D = coord(DX, DY),
	length(Board, Height),
	Board = [FirstElement|_],
	length(FirstElement, Width),
	between(0,Width,AX),
	between(0,Height,AY),
	BX = AX,
	CX = AX,
	DX = AX,
	(
		BY is AY + 1, CY is AY + 2, DY is AY + 3
		;
		BY is AY - 1, CY is AY - 2, DY is AY - 3
	).
horizontal(List, Board) :-
	List = [A,B,C,D|_],
	A = coord(AX, AY),
	B = coord(BX, BY),
	C = coord(CX, CY),
	D = coord(DX, DY),
	length(Board, Height),
	Board = [FirstElement|_],
	length(FirstElement, Width),
	between(0,Width,AX),
	between(0,Height,AY),
	BY = AY,
	CY = AY,
	DY = AY,
	(
		BX is AX + 1, CX is AX + 2, DX is AX + 3
		;
		BX is AX - 1, CX is AX - 2, DX is AX - 3
	).
diagonal(List, Board) :-
	List = [A,B,C,D|_],
	A = coord(AX, AY),
	B = coord(BX, BY),
	C = coord(CX, CY),
	D = coord(DX, DY),
	length(Board, Height),
	Board = [FirstElement|_],
	length(FirstElement, Width),
	between(0,Width,AX),
	between(0,Height,AY),
	% The 4 diagonals
	(
		% Down and right
		BX is AX + 1, BY is AY + 1,
		CX is AX + 2, CY is AY + 2,
		DX is AX + 3, DY is AY + 3
		;
		% Down and left
		BX is AX - 1, BY is AY + 1,
		CX is AX - 2, CY is AY + 2,
		DX is AX - 3, DY is AY + 3
		;
		% Up and left
		BX is AX - 1, BY is AY - 1,
		CX is AX - 2, CY is AY - 2,
		DX is AX - 3, DY is AY - 3
		;
		% Up and Right
		BX is AX + 1, BY is AY - 1,
		CX is AX + 2, CY is AY - 2,
		DX is AX + 3, DY is AY - 3
	).
	
aligned(List, Board) :-
	vertical(List, Board).
aligned(List, Board) :-
	horizontal(List, Board).
aligned(List, Board) :-
	diagonal(List, Board).

xmasList(List, Board) :-
	length(List,4),
	aligned(List,Board),
	forall(member(X, List), xmasLetterCoord(X, Board)),
	List = [A,B,C,D|_],
	xmasLetterCoord(A, Board, Xatom),
	Xatom = 'X',
	xmasLetterCoord(B, Board, Matom),
	Matom = 'M',
	xmasLetterCoord(C, Board, Aatom),
	Aatom = 'A',
	xmasLetterCoord(D, Board, Satom),
	Satom = 'S'.



main :-
	open("input.txt", read, Input),
	read_string(Input, _, String),
	split_string(String,"\n","\r",Out),
	maplist(string_chars,Out,Board),
	findall(R, xmasList(R,Board), Possibilities),
	length(Possibilities, Sum),
	write(Sum).
