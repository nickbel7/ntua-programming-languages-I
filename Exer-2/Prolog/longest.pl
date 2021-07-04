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
make_prefixDiff([], _, [], _).
make_prefixDiff([X | Arr2], Sum, [X2 | PrefixDiff2], Value) :-
  X2 is (Sum + X + Value),
  make_prefixDiff(Arr2, X2, PrefixDiff2, Value).

/******* CREATE LIST OF CURRENT MAXs STARTING FROM RIGHT *******/
% make_prefixMax(prefix_diff_array, prefix_max_array, current_max)
make_prefixMax([], [], _).
make_prefixMax([Y1 | PrefixDiffIn1], [Max1 | PrefixDiffMaxOut], CurrMax) :-
  CurrMax1 is max(Y1, CurrMax),
  Max1 is CurrMax1,
  make_prefixMax(PrefixDiffIn1, PrefixDiffMaxOut, CurrMax1).

/******* CREATE LIST OF CURRENT MINs STARTING FROM LEFT *******/
% make_prefixMax(prefix_diff_array, prefix_max_array, current_min)
make_prefixMin([], [], _).
make_prefixMin([Y2 | PrefixDiffIn2], [Min1 | PrefixDiffMinOut], CurrMin) :-
  CurrMin1 is min(Y2, CurrMin),
  Min1 is CurrMin1,
  make_prefixMin(PrefixDiffIn2, PrefixDiffMinOut, CurrMin1).

% CALCULATE MAX DISTANCE TRAVERSING MAX_ARRAY AND MIN_ARRAY
calculate_MaxDiff([], _, [], _, MaxLen) :- MaxLen is 0.
calculate_MaxDiff([], IMax, _, IMin, MaxLen) :- MaxLen is IMax - IMin - 1.
calculate_MaxDiff(_, IMax, [], IMin, MaxLen) :- MaxLen is IMin - IMax - 1.
calculate_MaxDiff([MaxN | MaxArray], IMax, [MinN | MinArray], IMin, MaxLen) :-
  ( MaxN >= MinN -> IMin1 is IMin + 1, calculate_MaxDiff([MaxN | MaxArray], IMax, MinArray, IMin1, MaxLen1), MaxLen is max(IMin - IMax - 1, MaxLen1)
  ; IMax1 is IMax + 1, calculate_MaxDiff(MaxArray, IMax1, [MinN | MinArray], IMin, MaxLen1), MaxLen is max(IMin - IMax - 1, MaxLen1)
  ).

% MAIN PROGRAM
longest(File, Answer) :-
  read_input(File, _, N, Arr),  %READ INPUT (FILENAME, No OF DAYS, No OF HOSPITALS, BEDS DAILY DIFFERENCE)
  make_prefixDiff(Arr, 0, PrefixDiff, N), %CREATE PREFIX ARRAY WITH INCREMENT (N) -> PrefixDiff(i+1) = sum + Arr(i) + N
  append([0], PrefixDiff, PrefixDiff0), %APPEND (0,0) TUPLE AT THE BEGINNING OF THE PrefixDiff List
  make_prefixMax(PrefixDiff0, PrefixDiffMax, 0),
  reverse(PrefixDiff0, PrefixDiff0Rev),
  nth0(0, PrefixDiff0Rev, MaxTemp),
  make_prefixMin(PrefixDiff0Rev, PrefixDiffMin, MaxTemp),
  reverse(PrefixDiffMin, PrefixDiffMinRev),
  calculate_MaxDiff(PrefixDiffMax, 0, PrefixDiffMinRev, 0, MaxOutput),
  Answer is MaxOutput.
