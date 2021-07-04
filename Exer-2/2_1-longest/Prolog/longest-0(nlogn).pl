% FOR DEBUGING
%  read_input("longest.in1", M, N, Arr), format("~w ~w~n~w", [M, N, Arr]), fail.

/******* READ INPUT *******/
% M : NUMBER OF DAYS
% N : NUMBER OF HOSPITALS
% Arr : HOSPITAL BEDS DAILY DIFFERENCE (f')
read_input(File, M, N, Arr) :-
  open(File, read, Stream),
  read_line(Stream, [M, N]),
  read_line(Stream, Arr).

read_line(Stream, L) :-
  read_line_to_codes(Stream, Line),
  atom_codes(Atom, Line),
  atomic_list_concat(Atoms, ' ', Atom),
  maplist(atom_number, Atoms, L).

/******* CREATE PrefixDiff *******/
% Sum = 0
% PrefixDiff[0] = 0
% PrefixDiff[i+1] = Sum += ArrDiff[i]
% -> PrefixDiff[i+1] = Sum += (Arr + N)
% make_prefixDiff(Initial Array, Current Sum, Destination Array, Increment Value (N))
make_prefixDiff([], _, [], _, _).
make_prefixDiff([X | Arr2], Sum, [(X2,C2) | PrefixDiff2], Value, Counter) :-
  X2 is (Sum + X + Value),
  % Sum2 is X2,
  C2 is Counter,
  Counter2 is (Counter + 1),
  make_prefixDiff(Arr2, X2, PrefixDiff2, Value, Counter2).

% UNZIP TUPLE LIST AND RETURN A LIST WITH ONLY THE SECOND VARIABLE OF EACH TUPLE
extract_second([], []).
extract_second([(_, P1) | InRest], [P1 | OutRest]) :-
  extract_second(InRest, OutRest).

% REDUCE THE PARITY INDEX
redParityIndex(ParityIndexOld, ParityIndexNew, PrefixParityArray) :-
  ( ParityIndexOld > 0, lists:nth0_det(ParityIndexOld, PrefixParityArray, B1), B1 == 1 -> ParityIndexOld1 is (ParityIndexOld - 1),
    redParityIndex(ParityIndexOld1, ParityIndexNew1, PrefixParityArray), ParityIndexNew is ParityIndexNew1
  ; ParityIndexNew is ParityIndexOld
  ).

% TRAVERSES SORTED INDEXES AND CALCULATES THE MAX DISTANCE
% prefix_traverse(sorted_indexes_list, current_max_length, parity_index, parity_bit_array)
prefix_traverse([], MaxLen, _, _) :- MaxLen is 0.
prefix_traverse([Z | Arr3], MaxLen, ParityIndex, PrefixParity1) :-
  lists:nth0_det(Z, PrefixParity1, 1),
  redParityIndex(ParityIndex, ParityIndex2, PrefixParity1),
  prefix_traverse(Arr3, MaxLen2, ParityIndex2, PrefixParity1),
  MaxLen is max(ParityIndex - Z, MaxLen2).

% MAIN PROGRAM
longest(File, Answer) :-
  read_input(File, M, N, Arr),  %READ INPUT (FILENAME, No OF DAYS, No OF HOSPITALS, BEDS DAILY DIFFERENCE)
  make_prefixDiff(Arr, 0, PrefixDiff, N, 1), %CREATE PREFIX ARRAY WITH INCREMENT (N) -> PrefixDiff(i+1) = sum + Arr(i) + N
  append([(0,0)], PrefixDiff, PrefixDiff0), %APPEND (0,0) TUPLE AT THE BEGINNING OF THE PrefixDiff List
  msort(PrefixDiff0, SortedPrefixDiff), %SORT PrefixDiff List of tuples (a,b) based on a and then on b
  extract_second(SortedPrefixDiff, SortedPrefixDiffNew), % Take only the sorted indexes
  reverse(SortedPrefixDiffNew, SortedPrefixDiffRev),
  M1 is M + 1,
  length(PrefixParity, M1),  %INITIALIZE ARRAY OF ZEROS (PARITY BITS)
  prefix_traverse(SortedPrefixDiffRev, MaxLen1, M, PrefixParity),
  Answer is MaxLen1.
