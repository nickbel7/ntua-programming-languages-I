(***************************************************************************
  Project     : Programming Languages 1 - Assignment 1 - Exercise 2
  Date        : April 20, 2021
  Description : Longest
  -----------
  School of ECE, National Technical University of Athens.
*)

(* INPUT FILE PARSING *)
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

(* MERGE SORT *)
fun first (x,_) = x
fun second(_,x) = x

(* comparator *)
fun compare a b =
    if (first a = first b) then second a < second b
    else first a < first b

(* separates list into two - works recursively *)
fun halve nil = (nil, nil)
|   halve [a] = ([a], nil)
|   halve (a :: b :: cs) =
      let
        val (x, y) = halve cs
      in
        (a :: x, b :: y)
      end;

(* merges two lists *)
fun merge (nil, ys) = ys
|   merge (xs, nil) = xs
|   merge (x :: xs, y :: ys) =
      if (compare x y) then x :: merge(xs, y :: ys)
      else y :: merge(x :: xs, ys);

(* applies merge sort recursively *)
fun mergeSort nil = nil
|   mergeSort [a] = [a]
|   mergeSort theList =
      let
        val (x, y) = halve theList
      in
        merge(mergeSort x, mergeSort y)
      end;

fun max (x:int, y:int) = if x < y then y else x

fun longest fileName =
    let
        (* read data from file *)
        val data = parse (fileName)
        val m = #1 data
        val n = #2 data
        val arr = #3 data

        fun incList [] = []
          | incList (x::xs) = (x+n) :: (incList xs)

        fun prefixList (sum:int) [] = []
          | prefixList (sum:int) (h::t) = (sum+h) :: (prefixList (sum+h) t)

        val arr_new = 0 :: List.rev (incList arr)
        val prefix_arr = prefixList 0 arr_new

        fun ascendingList i m =
            if i <= m then (i :: ascendingList (i+1) m)
            else []

        val index_arr = ascendingList 0 m
        val indexed_prefix = ListPair.zip(prefix_arr, index_arr)
        val sorted_prefix = mergeSort indexed_prefix
        val sorted_indexes = List.rev(second (ListPair.unzip(sorted_prefix)))
        val prefix_parity = Array.array(m+1, 0)
        val parity_index = m
        val max_len = 0

        fun redParityIndex i =
            if (i>=0 andalso Array.sub(prefix_parity, i) = 1) then
                (redParityIndex (i-1))
            else
                (i)

        fun prefixTraverse sorted_indexes =
            let
                fun updateParity (parity_index:int) (max_len:int) [] = (max_len)
                    | updateParity (parity_index:int) (max_len:int) (h::t) = (Array.update(prefix_parity, h, 1);
                        updateParity (redParityIndex parity_index) (max((parity_index-h), max_len)) t
                    )
            in
                updateParity parity_index max_len sorted_indexes
            end;


        val result = prefixTraverse sorted_indexes

    in
        print(Int.toString result ^ "\n")
    end;
