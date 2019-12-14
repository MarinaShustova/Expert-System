cond(1,'higher than 50sm'). %database definition
cond(2,'have flowers').
cond(3,'have needles').
cond(4,'require a lot of water').
cond(5,'need a lot of light').
cond(6,'need shadow').
cond(7,'slightly poison').
cond(8,'have spots on the leafs').
cond(9,'have trunk').
cond(10,'blooms several times per year').
cond(11,'need poor watering').

rule(1,'cactus', [2,3,7,10]).
rule(2,'chinese_money_plant', [6,8,11]).
rule(3,'chinese_evergreen',[1,4,8]).
rule(4,'yucca',[1,5,9]).
rule(5,'african_violets',[2,6,10]).
rule(6,'peace_lily',[1,2,4,10]).
rule(7,'dragon_tree',[1,7,9,11]).
rule(8,'calathea',[4,6,8]).
rule(9,'kalanchoe',[2,5,10,11]).
rule(10,'phalaenopsis_orchid',[1,4,6]).
rule(11,'ZZ_plant',[1,6,9,11]).
rule(12,'dieffenbachia',[1,6,8]).
:-
   dynamic(db_yes/1),
   dynamic(db_no/1).

yes(X):-
    db_yes(X),
    !.
yes(X):-
    not(no(X)), !,
    check_if(X).
no(X):-
    db_no(X), !.
plant(X):-
	rule(_, X, Property),
	check_property(Property).

check_property([N | Property]):-
	cond(N, A),
	yes(A),
	check_property(Property).

check_property([]).

check_if(X):-                  %check features
	write("Does/Is it "),
	write(X),
	writeln(" ?"),
	read(Reply),           %saves reply to database
	remember(Reply, X).

remember(yes, X):-
	asserta(db_yes(X)).

remember(no, X):-
	asserta(db_no(X)),
	fail.

investigate(X):-               %process of asking itself
	nl,
	write('Answer some questions'),
	nl,
	plant(X) ,!, %checks features
	nl,
	write('That plant could be '),
	write(X),
        nl, write('Because of '),
	describe(X).            %explanation of decision
investigate(_):-
	nl,
	write('Sorry, I don\'t know such plant').

writeProperty([N|Property]):-  %writes list of plant properties to console
	cond(N,A),
	write(A),
	nl,
	writeProperty(Property).
writeProperty([]).

describe(X):-                  %describes given plant
	nl,
	rule(_,X,Property),
	writeProperty(Property).
start:-
	retractall(db_yes(_)), %clear previous data
	retractall(db_no(_)),
	investigate(_).




















