
isMul(String) :-
	sub_string(String, 0, 4, _, "mul("), 
	wildcard_match("mul(*[0-9],*[0-9])", String).

doMul(String, Result) :-
	isMul(String),
	split_string(String,",","mul()",Out),
	maplist(number_string, Numbers, Out),
	[X,Y|_] = Numbers,
	Result is X * Y.


checkSubstrings(String, Result) :-
	sub_string(String, _, Length, _, Sub),
	Length < 15,
	doMul(Sub, Result).

main :-
	open("input.txt", read, Input),
	read_string(Input, _, String),
	findall(R, checkSubstrings(String,R), Possibilities),
	sum_list(Possibilities, Sum),
	write(Sum).
