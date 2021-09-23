/******* READ INPUT *******/
% T : NUMBER OF TOWNS
% C : NUMBER OF CARS
% Arr : NUMBER OF CARS IN EACH TOWN
read_input(File, T, C, Arr) :-
    open(File, read, Stream),
    read_line(Stream, [T, C]),
    read_line(Stream, Arr).
  
read_line(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).

/******* CREATE TRANSPOSED ARRAY WHICH CONTAINS THE NUMBER OF CARS IN EACH TOWN *******/
transpose_array([], [], Towns, _, Towns) :- !.
transpose_array([], [Y | Arr], CurrI, Count, Towns) :- CurrI =\= Towns, Y is Count, CurrI2 is CurrI + 1, transpose_array([], Arr, CurrI2, 0, Towns).
transpose_array([X | ArrIn], [Y | Arr], CurrI, Count, Towns) :-
    ( CurrI =:= X -> Count2 is Count + 1, transpose_array(ArrIn, [Y | Arr], CurrI, Count2, Towns)
    ; Y is Count, CurrI2 is CurrI + 1, transpose_array([X | ArrIn], Arr, CurrI2, 0, Towns)
    ).

% CALCULATE THE SUM OF DISTANCES FOR THE FIRST TOWN
first_sum([], _, _, 0).
first_sum([X | Arr], Towns, Counter, Sum) :-
    Counter2 is Counter + 1,
    first_sum(Arr, Towns, Counter2, Sum2),
    calc_distance(Counter, 0, Towns, Distance),
    Sum is Sum2 + X * Distance.

% % ALGORITHM FOR carsSum : carsSum[i+1] = carsSum[i] + cars - carsArray[i+1] * towns
sum_array([], _, _, _, _, _, _,TotalMin, TotalMin, []).
sum_array([X | Arr], [X2 | Arr2], Towns, Cars, PreviousSum, Counter, CurrentIndex, CurrentMin, TotalMin, [Y | ArrSum]) :-
    % CALCULATE THE NEXT SUM
    Y is (PreviousSum + Cars - X * Towns),
    % MOVE THE FURTHEST TOWN CURSOR
    ( Counter =:= CurrentIndex -> CurrentIndexNew is mod((CurrentIndex + 1), Towns),
        move_furthest(Arr2, CurrentIndexNew, Arr2New, CurrentIndex2) 
    ; CurrentIndex2 is CurrentIndex, Arr2New = [X2 | Arr2]),
    % CALCULATE IF SUM IS VALID
    calc_distance(CurrentIndex2, Counter, Towns, CurrentMaxDistance),
    isValid(CurrentMaxDistance, Y, CurrentValid),
    (CurrentValid == true -> Min1 is min(CurrentMin, Y) ; Min1 is CurrentMin),
    % CALL SUM ARRAY UNTIL THE ARRAY IS EMPTY
    Counter2 is mod((Counter + 1), Towns),
    sum_array(Arr, Arr2New, Towns, Cars, Y, Counter2, CurrentIndex2, Min1, TotalMin, ArrSum).

/****** CALCULATES THE DISTANCE FROM A START TOWN TO A FINISH TOWN ********/
calc_distance(Start, Finish, Towns, Distance) :-
    Distance is mod((Finish - Start + Towns), Towns).

/****** CHECKES IF A TOWN IS VALID *******/
isValid(Distance, CurrentSum, Answer) :-
    ( CurrentSum - 2 * Distance + 1 >= 0 -> Answer = true
    ; Answer = false 
    ).

/****** MOVES THE VALIDITY ARRAY INDEX *******/
% move_furthest([], _, _, 0).
move_furthest([X | Arr], IndexOld, ArrNew, IndexNew) :- X =:= 0, move_furthest(Arr, IndexOld, ArrNew, IndexNew2), IndexNew is IndexNew2 + 1.
move_furthest([X | Arr], IndexNew, [X | Arr], IndexNew) :- X =\= 0.

% MAIN PROGRAM
round(File, MinSum, MinTown) :-
    read_input(File, T, C, ArrIn),  % READ INPUT (FILENAME, No OF TOWNS, No OF CARS, CARS IN EACH TOWN)
    msort(ArrIn, ArrS), % SORT ARRAY FOR BETTER TIME COMPLEXITY
    transpose_array(ArrS, Arr, 0, 0, T), % TURN ARRAY OF CARS TO ARRAY OF TOWNS 
    first_sum(Arr, T, 0, FirstSum), % FIND SUM OF FIRST TOWN AS TARGET
    nth0(0, Arr, Town1, ArrRest),  % EXCLUDE FIRST ELEMENT FROM ARRAY OF TOWNS
    append(ArrRest, [Town1], ArrRest2), % INITIALIZE VALIDITY ARRAY
    move_furthest(ArrRest2, 1, _, FirstIndexN), % INITIALIZE VALIDITY ARRAY POINTER
    InitMin is 100000000,
    calc_distance(FirstIndexN, 0, T, FirstMaxDistance), 
    isValid(FirstMaxDistance, FirstSum, FirstValid),
    (FirstValid == true -> CurrentMin is min(FirstSum, InitMin) ; CurrentMin is InitMin),
    append(ArrRest, Arr, ArrRest3),
    sum_array(ArrRest, ArrRest3, T, C, FirstSum, 1, FirstIndexN, CurrentMin, MinSum, ArrSum), % CREATE ARRAY OF SUMS FOR ALL TOWNS
    append([FirstSum], ArrSum, ArrSum2),  % ADD SUM OF FIRST CITY
    nth0(MinTown, ArrSum2, MinSum),
    !. 