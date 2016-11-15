/*
 * get(X, T, LTX) is true if either (X, LTX) \in T, or (X, _) \notin T \wedge
 * LTX = bot.
 */
get(_, [], bot).
get(X, [(X, LTX)|_], LTX).
get(X, [(Y, _)|T], LTX) :- X \= Y, get(X, T, LTX).

/*
 * union(L1, L2, L) is true if L has all the elements of L1 and L2, without
 * duplicate elements from L1.
 * Union of anything and bot is anything.
 */
union(bot, bot, []).
union(bot, L, L) :- L \= bot.
union(L, bot, L) :- L \= bot.
union([], L, L) :- L \= bot.
union([A|L1], L2, L) :- L2 \= bot, member(A, L2), union(L1, L2, L).
union([A|L1], L2, [A|L]) :- L2 \= bot, \+member(A, L2), union(L1, L2, L).

intersect(bot, bot, []).
intersect(bot, L, L) :- L \= bot.
intersect(L, bot, L) :- L \= bot.
intersect([], L, []) :- L \= bot.
intersect([A|L1], L2, [A|L]) :- L2 \= bot, member(A, L2), intersect(L1, L2, L).
intersect([A|L1], L2, L) :- L2 \= bot, \+member(A, L2), intersect(L1, L2, L).


intersect_all([], Acc, Acc).
intersect_all([L1|LL], Acc, AccAA) :-
  intersect(L1, Acc, AccA),
  intersect_all(LL, AccA, AccAA).

intersect_all([L], [L]).
intersect_all([L|T], Acc) :- intersect_all(T, L, Acc).

/*
 * update(X, LTX, T, TT) is true if TT is a new table built by inserting
 * (X, LTX) into T, if T did not already contain a tuple (X, LTX'). Otherwise,
 * we replace LTX' by LTX.
 */
update(X, LTX, [], [(X, LTX)]).
update(X, LTX, [(X, _)|T], [(X, LTX)|T]).
update(X, LTX, [(Y, LTY)|T], [(Y, LTY)|TT]) :- X \= Y, update(X, LTX, T, TT).

/*
 * same_set(S1, S2) is true if S2 is a permutation of S1
 */
same_set([], []).
same_set([A|T], S) :- select(A, S, SS), same_set(T, SS).

/*
 * same_table(T1, T2) is true if T2 contains every key from T1, and two equal
 * keys are bound to permutations of the same elements.
 */ 
same_table([], []).
same_table([(X, LTX)|T], S) :-
  select((X, LTXX), S, SS),
  same_set(LTX, LTXX),
  same_table(T, SS).

/*
 * We can't unify ofter a less-than comparison, otherwise we generate wrong
 * constraints before the comparison. Consider, for instance, this program:
 * 1) x1 = z + 1
 * 2) x2 = w + 3
 * 3) x1 < x3
 * 4) T: x1t = x1; x2t = x2 {x1t < x2t}
 * If we unified at x1t and x2 at 4, then we would end up proving the following:
 * z < x1 (1); z < x1t (4); z < x2t (4); z < x2 (and this is not true!)
 */
gen(def(X), [cp(X, X)]).
gen(add(X1, X2, N), [lt(X2, X1)]) :- N > 0.
gen(add(X1, X2, N), [lt(X1, X2), cp(X1, X1)]) :- N < 0.
gen(phi(X, L), [jn(X, L)]).
gen(less(X1, X2, T1, T2, F1, F2),
    [lt(T1, T2), lt(F2, F1), cp(X1, T1), cp(X1, F1), cp(X2, T2), cp(X2, F2)]).

/*
 * There is not need to model simple assignment, e.g., x = y. Such a thing
 * does not exist in SSA-form programs.
 */ 
gen_all(P, C) :- findall(E, (member(I, P), gen(I, E)), LC), flatten(LC, C).

solve(lt(X, Y), T, TT) :-
  get(Y, T, LTY),
  union([X], LTY, LTYY),
  get(X, T, LTX),
  union(LTX, LTYY, LTYYY),
  update(Y, LTYYY, T, TT).

solve(cp(X, Y), T, TT) :-
  get(X, T, LTX),
  get(Y, T, LTY),
  union(LTX, LTY, LTYY),
  update(Y, LTYY, T, TT).

solve(jn(X, L), T, TT) :-
  findall(LTA, (member(XA, L), get(XA, T, LTA)), Args),
  intersect_all(Args, NewLT),
  update(X, NewLT, T, TT).

solve_all([], T, T).
solve_all([C|Cs], T, TTT) :-
  solve(C, T, TT),
  solve_all(Cs, TT, TTT).

fixed_point(C, T, T) :-
  solve_all(C, T, TT),
  same_table(T, TT).
fixed_point(C, T, TTT) :-
  solve_all(C, T, TT),
  not(same_table(T, TT)),
  fixed_point(C, TT, TTT).

/*
 * Examples of different programs.
 * Usage: prog(N, P).
 */
/* Sol = [ (x1, [x3, x0]), (x2, [x3, x0, x1]), (x0, [x3]), (x3, [])] */
prog(0, [add(x1, x0, 1), add(x2, x1, 1), add(x3, x0, -1)]).
/* Sol = [ (x1, [x2, z]), (z, [x2]), (x2, []), (x3, [])] */
prog(1, [add(x1, z, 1), add(x2, z, -1), phi(x3, [x1, x2])]).
/* Sol = [ (x1, [z]), (x2, [z]), (x3, [z, x2])] */
prog(2, [add(x1, z, 1), phi(x2, [x1, x3]), add(x3, x2, 1)]).
/* Sol = [ (x1, [z]), (x2, [x3]), (x3, [])] */
prog(3, [add(x1, z, 1), phi(x2, [x1, x3]), add(x3, x2, -1)]).
prog(4, [def(x0), phi(x1, [x0, x3]), add(x2, x1, 7), add(x3, x2, 1)]).
prog(5, [def(x0), phi(x, [x0, x1]), add(z, x, -1), add(x1, x, 2), add(y, x1, -1)]).
prog(6, [add(x1, z, 1), phi(x2, [x1, x3]), add(x3, z, -1)]).
prog(7, [def(p), add(x1, 2, 0), add(p1, p, 2), phi(x, [x1, x2]), add(x2, x, 1), add(p2, p, x)]).
prog(8, [add(x1, 2, 1), add(x2, x1, 1), add(x3, x0, -1)]).

/*
 * Interface of the analysis.
 * Example of Usage: analyze(1, P, T).
 */
analyze(N, P, T) :- prog(N, P), gen_all(P, C), fixed_point(C, [], T).
