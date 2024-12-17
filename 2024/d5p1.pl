:- use_module(spawn).



ruleApplies(Pages, Rule) :-
	[First, Second|_] = Rule,
	nth0(_, Pages, First),
	nth0(_, Pages, Second).
followsRule(Pages, Rule) :-
	\+ ruleApplies(Pages, Rule).
followsRule(Pages, Rule) :-
	[First, Second|_] = Rule,
	nth0(Index1, Pages, First),
	nth0(Index2, Pages, Second),
	Index1 < Index2.
followsAllRules(Rules, Pages) :-
	forall(member(X, Rules), followsRule(Pages, X)).

middleElement(List, Element) :-
	length(List, Length),
	Length2 is Length - 1,
	MiddleIdx is Length2 / 2,
	nth0(MiddleIdx, List, Element).


splitBars(String, Output) :-
	split_string(String,"|","\r",Output).
splitCommas(String, Output) :-
	split_string(String, ",", "\r", Output).

main :-
	open("input.txt", read, Input1),
	read_string(Input1, _, String),
	split_string(String,"\n","\r",Out),
	maplist(splitBars, Out, Rules),
	open("input2.txt", read, Input2),
	read_string(Input2, _, String2),
	split_string(String2, "\n", "\r", Out2),
	maplist(splitCommas, Out2, Pages),

	% Now do the thing
	include(call(followsAllRules, Rules), Pages, PagesOut),
	maplist(middleElement, PagesOut, Middles),
	maplist(number_string, Numbers, Middles),
	sum_list(Numbers, Answer),
	write(Answer).
