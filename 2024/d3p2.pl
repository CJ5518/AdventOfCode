:- use_module(library(filesex)).


isDo(String) :-
	sub_string(String, 0, 4, _, "do()").

isDont(String) :-
	sub_string(String, 0, 7, _, "don't()").

isMul(String) :-
	sub_string(String, 0, 4, _, "mul("), 
	wildcard_match("mul(*[0-9],*[0-9])", String).

doMul(String, Result) :-
	split_string(String,",","mul()",Out),
	maplist(number_string, Numbers, Out),
	[X,Y|_] = Numbers,
	Result is X * Y.

hasDontBeforeDoList(List) :-
	append(_, [SecondLast,_], List),
	SecondLast = "don't()".

% true if String has a dont() instead of a do() most recently
hasDontBeforeDo(String) :-
	re_split("don't\\(\\)|do\\(\\)", String, Res),
	hasDontBeforeDoList(Res).



checkSubstrings(String, Result) :-
	sub_string(String, Before, Length, _, Sub),
	Length < 15,
	Length > 3,
	isMul(Sub),
	sub_string(String, 0, Before, _, EverythingBefore),
	\+ hasDontBeforeDo(EverythingBefore),
	doMul(Sub, Result).
	
	

main :-
	open("input.txt", read, Input),
	read_string(Input, _, String),
	findall(R, checkSubstrings(String,R), Possibilities),
	sum_list(Possibilities, Sum),
	write(Sum).
