/******* READ INPUT *******/
% N : LENGTH OF ARRAY
% Arr : ARRAY OF NON NEGATIVE INTEGERS
read_input(File, N, Arr) :-
  open(File, read, Stream),
  read_line(Stream, [N]),
  read_line(Stream, Arr).

read_line(Stream, L) :-
  read_line_to_codes(Stream, Line),
  atom_codes(Atom, Line),
  atomic_list_concat(Atoms, ' ', Atom),
  maplist(atom_number, Atoms, L).

/* config(UnurderedList, Stack) */
final(config(Arr, [])) :- msort(Arr, ArrS), Arr == ArrS.

% POPS ELEMENT FROM THE START OF THE LIST AND INSERTS IT AT THE TOP OF THE STACK
pop([X1 | Arr1], Stack1, Arr1, [X1 | Stack1]).
% PUSHES ELEMENT FROM THE TOP OF THE STACK AND INSERTS IT AT THE END OF THE LIST
push(Arr1, [X1 | Stack1], Arr2, Stack1) :- append(Arr1, [X1], Arr2).

% POSIBLE Moves
/* move(Conf1, letter(Q / S), Conf2) */
move(config(Arr1, Stack1), 'Q', config(Arr2, Stack2)) :-
  pop(Arr1, Stack1, Arr2, Stack2).
move(config([X1 | Arr1], [X2 | Stack1]), 'S', config(Arr2, Stack2)) :-
  X1 =\= X2,
  push([X1 | Arr1], [X2 | Stack1], Arr2, Stack2).

invalid_move(config([], _), 'Q', config(_, _)).
invalid_move(config(_, []), 'S', config(_, _)).

solve(Conf, []) :- final(Conf).
% solve(config([X | Arr], [X | Stack]), [Move | Moves]) :-
  % text_to_string(['Q'], Move),
%   % move(config([X | Arr], [X | Stack], 'Q', config(Arr, [X | [ X | Stack]]))),
  % solve(config(Arr, [ X, X | Stack]), Moves).
solve(Conf, [Move | Moves]) :-
  move(Conf, Move, Conf1),
  % \+ invalid_move(Conf, Move, Conf1),
  solve(Conf1, Moves).

print_result([], Output) :- Output = 'empty'.
print_result(ListTmp, Output) :- atomics_to_string(ListTmp, Output).

% EVEN SOLUTIONS
% is_even(MaxL1) :- (MaxTemp is (MaxL1 mod 2), MaxTemp \== 0 -> true ; false).

qssort(File, Answer) :-
  read_input(File, _, Arr),
  % is_even(MaxL),
  length(Moves, MaxL),
  MaxL1 is mod(MaxL, 2),
  (MaxL1 =:= 0 -> solve(config(Arr, []), Moves); false),
  % solve(config(Arr, []), Moves),
  print_result(Moves, Answer),
  !.
