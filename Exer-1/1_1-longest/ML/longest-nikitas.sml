(***************************************************************************
  Project     : Programming Languages 1 - Assignment 1 - Exercise 1
  Author(s)   : Nick Bellos (nikolas.bellos@gmail.com)
  Date        : April 20, 2021
  Description : Longest
  -----------
  School of ECE, National Technical University of Athens.
*)


(* Dummy solver & requested interface. *)
(* fun solve (m, n, arr) = (
    let
        (* val arrDiff = array (m+1, 1) *)
        fun loop i m = 
            if i <= m then 
                (print (Int.toString List.nth(arr, i) ^ "\n"); loop (i+1) m)
                (* Array.update (arrDiff, i, h)
                (print (Int.toString h ^ "\n");) *)
            else
                ()
    in
        loop 1 m
    end
)
fun longest fileName = solve (parse fileName) *)
fun longest fileName =
let
fun first (x,_) = x
fun second(_,x) = x

fun comp_tuple a b =
    if (first a = first b) then second a < second b 
    else first a < first b

fun halve nil = (nil, nil)
|   halve [a] = ([a], nil)
|   halve (a :: b :: cs) =
      let
        val (x, y) = halve cs
      in
        (a :: x, b :: y)
      end;

fun merge (nil, ys) = ys
|   merge (xs, nil) = xs
|   merge (x :: xs, y :: ys) =
      if (comp_tuple x y) then x :: merge(xs, y :: ys)
      else y :: merge(x :: xs, ys);

fun mergeSort nil = nil
|   mergeSort [a] = [a]
|   mergeSort theList =
      let
        val (x, y) = halve theList
      in
        merge(mergeSort x, mergeSort y)
      end;

fun parse file =
    let
	(* A function to read an integer from specified input. *)
        fun readInt input = 
	    Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

	(* Open input file. *)
    	val inStream = TextIO.openIn file

    (* Read two integers (number of days, number of hospitals) and consume newline. *)
	val m = readInt inStream
    val n = readInt inStream
	val _ = TextIO.inputLine inStream

        (* A function to read N integers from the open file. *)
	fun readInts 0 acc = acc (* Replace with 'rev acc' for proper order. *)
	  | readInts i acc = readInts (i - 1) (readInt inStream :: acc)
    in
   	(m, n, readInts m [])
    end

val input = parse fileName (* input = (int, int, int*int list) *)
val M = (#1 input) (* M = #days *)
val N = (#2 input) (* N = #hospitals *)
val d = (#3 input) (* d = day beds in list d *)

fun addN x = x+(N); 

fun map (f, l) =
    if null l then nil
    else f (hd l) :: map (f, tl l);

val new_arr = map (addN, d); (*new_arr = d[]+N *)
val new_arr = Vector.fromList(new_arr);

(* fun printList xs = print(String.concatWith ", " (map Int.toString xs)); *)

fun makef (x:int vector) lim acc=
(* function to calculate integrated array of d[] *)
    if lim=0 then acc
    else makef x (lim-1) ((List.nth(acc,0)+Vector.sub(x,(lim-1)))::acc);

val f = makef new_arr M [0];

fun range x lim =
(* function to make a counting array *) 
    if lim<0 then x
    else range (M-lim::x) (lim-1);
    
val pair = ListPair.zipEq (f,range [] M) (*make int pair list of (f[] + index) *)
val pair_sorted = mergeSort pair (* sort int pait list in respect to 1st element *) 
val fin_list = second (ListPair.unzip pair_sorted) (* list of final sub-problem *)
val fin_list = Vector.fromList(fin_list)

fun zeros x lim =
(* function to make a zero list *) 
    if lim=0 then x
    else zeros (0::x) (lim-1);

val prefixParity = Vector.fromList (zeros [] (M+1))
val maxLen = 0
val parityIndex = M

fun while_loop (prefixParity:int vector) (parityIndex:int) =
    if Vector.sub(prefixParity,parityIndex)=1 then while_loop prefixParity (parityIndex-1)
    else parityIndex;

fun max_int (x,y) = if x<=y then y else x;

fun for_loop (i:int) (prefixParity: int vector) (maxLen:int) (parityIndex:int) (prefixDiff:int vector) = 
    let 
        val maxLen = if i<0 then maxLen else max_int((parityIndex-Vector.sub(prefixDiff, i)), maxLen)
        val prefixParity =  if i<=0 then prefixParity else Vector.update(prefixParity, Vector.sub(prefixDiff, i), 1)
        val parityIndex =  if i<=0 then parityIndex else while_loop prefixParity parityIndex
        val out = if i<0 then maxLen
               else for_loop (i-1) prefixParity maxLen parityIndex prefixDiff; 
    in
    out
    end


val solution = for_loop M prefixParity maxLen parityIndex fin_list
in
print(Int.toString(solution) ^ "\n")
end    