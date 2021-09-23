(***************************************************************************
  Project     : Programming Languages 1 - Assignment 3 - Exercise 2
  Date        : August 10, 2021
  Description : Round
  -----------
  School of ECE, National Technical University of Athens.
***************************************************************************)

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
   	    (m, n, readInts n [])
    end

fun min (x:int, y:int, xTown:int, yTown:int) = if x < y then (x, xTown) else (y, yTown)

fun round fileName = 
  let 
    val data = parse (fileName)
    val m = #1 data
    val n = #2 data
    val arr = #3 data

    (* Turn List into an Array *)
    val arr = Array.fromList arr
    (* Initialize array of towns *)
    val towns_array = Array.array(m, 0)

    (* FUNCTION to update each town when a car is located in it *)
    fun transposeArray i = Array.update(towns_array, Array.sub(arr, i), Array.sub(towns_array, Array.sub(arr,i))+1)
    (* transpose the initial 'array of cars' to an 'array of towns' *)
    val void = Array.tabulate(Array.length arr, transposeArray)

    (* FUNCTION to move the cursor of the furthest town *)
    fun moveFurthest (i:int) =
      if (Array.sub(towns_array, i) = 0) then
        (moveFurthest ((i + 1) mod m))
      else 
        (i)

    (* FUNCTION to calculate the distance from one town to another *)
    fun calcDistance (start:int) (finish:int) = 
      ((finish - start + m) mod m)

    (* FUNCTION to check if a town is valid *)
    fun isValid (distance:int) (currentSum:int) = 
      if (currentSum - 2 * distance + 1 >= 0) then 
        true
      else 
        false

    (* FUNCTION to calculate the next Sum of Distances (based on first sum) *)
    fun calcNextSum (previousSum:int) (i:int) = 
      previousSum + n - Array.sub(towns_array, i) * m

    (* FUNCTION to calculate the Sum of Distances for first town *)
    fun firstSum i =
      if (i < m) then 
        (Array.sub(towns_array, i) * calcDistance i 0) + firstSum (i+1)
      else 0

    val current_sum = firstSum 1

    (* FUNCTION to set the initial TotalMin sum of distances **checks if first town is valid *)
    fun setFirstMinSum (currSum:int) (start:int) (finish:int) =
      if (isValid (calcDistance start finish) currSum) then
        currSum
      else
        Option.valOf Int.maxInt

    val furthestTown = moveFurthest 1
    val min_sum = setFirstMinSum current_sum furthestTown 0

    (* FUNCTION to calculate the rest of sums and output the min valid town *)
    fun calcSum currSum currMinSum =
      let
        fun iterate 0 i previousSum currentMinSum currentMinTown = (currentMinSum, currentMinTown)
          | iterate counter i previousSum currentMinSum currentMinTown = 
            (
              if (isValid (calcDistance (moveFurthest ((i+1) mod m)) i) (calcNextSum previousSum i)) then 
                (iterate (counter-1) (i+1) (calcNextSum previousSum i) (#1 (min((calcNextSum previousSum i), currentMinSum, i, currentMinTown))) (#2 (min((calcNextSum previousSum i), currentMinSum, i, currentMinTown))))
              else
                (iterate (counter-1) (i+1) (calcNextSum previousSum i) currentMinSum currentMinTown)
            )
      in 
        iterate (m-1) 1 currSum currMinSum 0
      end;

    val answer = calcSum current_sum min_sum
  in
    print(Int.toString (#1 answer) ^ " " ^ Int.toString (#2 answer) ^ "\n")
  end;