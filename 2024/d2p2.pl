%Test input
%[[7, 6, 4, 2, 1],[1, 2, 7, 8, 9],[9, 7, 6, 2, 1],[1, 3, 2, 4, 5],[8, 6, 4, 4, 1],[1, 3, 6, 7, 9]]


%do the thing

inc(X,Y):- X < Y,Y - X =< 3.

allIncreasing([X,Y|T]):-
	inc(X,Y),
	allIncreasing([Y|T]).

allIncreasing([_|T]):-
	length(T, 0).

allDecreasing([X,Y|T]):-
	X > Y,
	X - Y =< 3,
	allDecreasing([Y|T]).

allDecreasing([_|T]):-
	length(T, 0).



safe(List) :-
	allIncreasing(List).

safe(List) :-
	allDecreasing(List).

%Given a list of lists, true if it's safe for at least one.
safeForOne([H|T]) :-
	(
		safe(H)
		;
		safeForOne(T)
	).

%Checks the possibilities
safeForAPossibility(List) :-
	findall(R, nth0(I, List,_,R), Possibilities),
	safeForOne(Possibilities).

countSafe(List, Result) :-
	%Check lists without an element
	include(safeForAPossibility, List, SafeOnes),
	length(SafeOnes, Result).

% Read the file

readSingleLine(Line, Numbers) :-
	split_string(Line, " ", "", NewRecordStrings),
	maplist(number_string, Numbers, NewRecordStrings).

readLines(Stream, Output, OutputAcc) :-
	read_string(Stream, "\n", "\r", Sep, String),
	readSingleLine(String, Numbers),
	append(OutputAcc, [Numbers|[]], NewOutput),
	(
		Sep = -1 -> Output = NewOutput
		;
		readLines(Stream, Output, NewOutput)
	).
	

readFile(Output) :-
	open("input.txt", read, Input),
	readLines(Input, Output, []).

main :-
	readFile(Output),
	countSafe(Output, Number),
	write(Number).