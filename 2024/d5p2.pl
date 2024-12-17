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
breaksRules(Rules, Pages) :-
	\+ followsAllRules(Rules, Pages).

%Selects on the element itself, not an index
swapElements(Element1, Element2, List, Result) :-
	select(Element2, List, "hello", NewList1),
	select(Element1, NewList1, Element2, NewList2),
	select("hello", NewList2, Element1, Result).

fixRule(Rule, Pages, PagesFixed) :-
	[First, Second|_] = Rule,
	(
		member(First, Pages),
		member(Second, Pages) ->
		(
			\+ followsRule(Pages, Rule) -> swapElements(First, Second, Pages, PagesFixed)
			;
			PagesFixed = Pages
		)
		;
		PagesFixed = Pages
	).

fixAllRules([], Pages, Fixed) :-
	Fixed = Pages.

fixAllRules([Rule|Rest], Pages, Fixed) :-
	fixRule(Rule, Pages, FixedAcc),
	fixAllRules(Rest, FixedAcc, Fixed).

fixAllAllRules(Rules, Pages, Fixed) :-
	fixAllRules(Rules, Pages, FixedAcc),
	(
		followsAllRules(Rules, FixedAcc) -> Fixed = FixedAcc
		;
		fixAllAllRules(Rules, FixedAcc, Fixed)
	).

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
	include(call(breaksRules, Rules), Pages, RuleBreakers),
	maplist(call(fixAllAllRules, Rules), RuleBreakers, PagesOut),
	maplist(middleElement, PagesOut, Middles),
	maplist(number_string, Numbers, Middles),
	sum_list(Numbers, Answer),
	write(Answer).

