/*
 * get(X, T, LTX) is true if either (X, LTX) \in T, or (X, _) \notin T \wedge
 * LTX = [].
 */
get(_, [], []).
get(X, [(X, LTX)|_], LTX).
get(X, [(Y, _)|T], LTX) :- X \= Y, get(X, T, LTX).

/*
 * union(L1, L2, L) is true if L has all the elements of L1 and L2, without
 * duplicate elements from L1.
 */
union([], L, L).
union([A|L1], L2, L) :- member(A, L2), union(L1, L2, L).
union([A|L1], L2, [A|L]) :- \+member(A, L2), union(L1, L2, L).

/*
 * intersect(L1, L2, L) is true if L has all the elements that are in L1 and in
 * L2.
 */
intersect([], _, []).
intersect([A|L1], L2, [A|L]) :- member(A, L2), intersect(L1, L2, L).
intersect([A|L1], L2, L) :- \+member(A, L2), intersect(L1, L2, L).

/*
 * This predicate performs a reduction: intersect_all(L, Acc, AccA) is true if
 * AccA is the intersection of every list in L and Acc.
 */
intersect_all([], Acc, Acc).
intersect_all([L1|LL], Acc, AccAA) :-
  intersect(L1, Acc, AccA),
  intersect_all(LL, AccA, AccAA).

/*
 * This is just an interface to call intersect_all/3.
 */ 
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

/*
 * gen(I, C) is true if C is the list of constraints produced to model
 * instruction I.
 */
gen(def(X), [cp(bullet, X)]).
gen(add(X1, X2, N), [lt(X2, X2, X1)]) :- N > 0.
gen(sub(X1, X2, N, X3), [cp(bullet, X1), lt(X1, X2, X3)]) :- N > 0.
gen(phi(X, L), [jn(X, L)]).
gen(less(X1, X2, T1, T2, F1, F2),
  [lt(T1,X1,T2), cp(F2,F1), cp(X1,T1), cp(X2,F2)]).

/*
 * vars(I, T, TT) is true if TT is T plus all the variables in instruction I.
 */
vars(def(X), T, TT) :- union([X], T, TT).
vars(add(X1, X2, _), T, TT) :- union([X1, X2], T, TT).
vars(sub(X1, X2, _, X3), T, TT) :- union([X1, X2, X3], T, TT).
vars(phi(X, L), T, TT) :- union([X|L], T, TT).
vars(less(X1, X2, T1, T2, F1, F2), T, TT) :-
  union([X1, X2, T1, T2, F1, F2], T, TT).

/*
 * collect_vars(P, T) is true if T is the set of all the variables in P.
 */
collect_vars([], []).
collect_vars([I|P], TT) :- collect_vars(P, T), vars(I, T, TT).

/*
 * There is not need to model simple assignment, e.g., x = y. Such a thing
 * does not exist in SSA-form programs.
 */ 
gen_all(P, C) :- findall(E, (member(I, P), gen(I, E)), LC), flatten(LC, C).

/*
 * solve(C, T, TT) is true if TT is the new table produced after evaluating
 * constraint C under the table T.
 */
solve(lt(X, Y, Z), T, TT) :-
  get(Y, T, LTY),
  union([X], LTY, LTZ),
  update(Z, LTZ, T, TT).

solve(cp(X, Y), T, TT) :-
  get(X, T, LTX),
  update(Y, LTX, T, TT).

solve(jn(X, L), T, TT) :-
  findall(LTA, (member(XA, L), get(XA, T, LTA)), Args),
  intersect_all(Args, ArgsIntersect),
  update(X, ArgsIntersect, T, TT).

/*
 * solve_all(C, T, TT) is true if TT is the result of solving all the
 * constraints C under table T.
 */
solve_all([], T, T).
solve_all([C|Cs], T, TTT) :-
  solve(C, T, TT),
  solve_all(Cs, TT, TTT).

/*
 * fixed_point(C, T, TT) is true if TT is the fixed point of constraints
 * C with initial table T.
 */ 
fixed_point(C, T, T) :-
  solve_all(C, T, TT),
  same_table(T, TT).
fixed_point(C, T, TTT) :-
  solve_all(C, T, TT),
  \+same_table(T, TT),
  fixed_point(C, TT, TTT).

/*
 * Examples of different programs.
 * Usage: prog(N, P).
 * Next to each program, there is its expected answer.
 */
/* Sol = [(x2, [x1, x0]), (x1, [x0]), (x3, []), (x0, []), (x4, [x3])] */
prog(0, [def(x0), add(x1, x0, 1), add(x2, x1, 1), sub(x3, x0, 1, x4)]).
/* Sol = [(x1, [x2, z]), (z, [x2]), (x2, []), (x3, [])] */
prog(1, [def(z), add(x1, z, 1), sub(x2, z, 1, x3), phi(x4, [x1, x3])]).
/* Sol = [(x2, []), (z, []), (x4, []), (x1, [z]), (x3, [x2])] */
prog(2, [def(z), add(x1, z, 1), phi(x2, [x1, x3]), add(x3, x2, 1)]).
/* Sol = [(z, []), (x1, [z]), (x3, []), (x2, [z]), (x4, [x3, z])] */
prog(3, [def(z), add(x1, z, 1), phi(x2, [x1, x4]), sub(x3, x2, 1, x4)]).
/* Sol = [(x0, []), (x1, []), (x3, [x2, x1]), (x2, [x1])] */
prog(4, [def(x0), phi(x1, [x0, x3]), add(x2, x1, 7), add(x3, x2, 1)]).

prog(5, [def(x0), add(x1, x0, 1), phi(x2, [x1, x3]), add(x3, x2, 1), sub(x4, x2, 2, x5), less(x5, x1, x5t, x1t, x5f, x1f)]).

/*
 * analyze(N, P, C, T) is true if prog(N, P) is true, e.g., P is the N-th
 * program. This program yields constraints C, and the solution of this
 * constraint system is T.
 * I am adding P and C to the predicate just for readability, so that the
 * constraints will come out in the terminal, when testing the predicate.
 */ 
analyze(N, P, C, T) :-
  prog(N, P),
  collect_vars(P, Vars),
  gen_all(P, C),
  findall((V, Vars), member(V, Vars), Init),
  fixed_point(C, Init, T).
