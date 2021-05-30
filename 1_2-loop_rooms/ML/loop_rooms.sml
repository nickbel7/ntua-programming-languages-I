(***************************************************************************
  Project     : Programming Languages 1 - Assignment 1 - Exercise 2
  Date        : April 28, 2021
  Description : Loop rooms
  -----------
  School of ECE, National Technical University of Athens.
*)

(* INPUT FILE PARSING *)
fun parse file =
    let
        fun readInt input =
	        Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

    	  val inStream = TextIO.openIn file

        val (n, m) = (readInt inStream, readInt inStream)
        val _ = TextIO.inputLine inStream
        fun readLines acc =
            case TextIO.inputLine inStream of
                NONE => rev acc
              | SOME line => readLines (explode (String.substring (line, 0, m))::acc)

        val inputList = readLines []: char list list
        val _ = TextIO.closeIn inStream
    in
        (n, m, inputList)
    end

fun loop_rooms fileName =
  let
    (* read data from file *)
    val data = parse (fileName)
    val n = #1 data
    val m = #2 data
    val arr = #3 data

    val arr = Array2.fromList arr;
    val arr_new = Array.array(n*m, 0)

    fun charToInt (c:char) (i:int) (j:int) (curr:int) =
        if (c = #"U") then (if (i = 0) then ~1 else (curr-m))
        else if (c = #"D") then (if i = (n-1) then ~1 else (curr+m))
        else if (c = #"R") then (if j = (m-1) then ~1 else (curr+1))
        else (if j = 0 then ~1 else (curr-1))

    fun traverseArray (i:int) (j:int) (curr:int) =
        if (i >= n) then ()
        else if (j >= m) then (traverseArray (i+1) 0 curr)
        else (Array.update(arr_new, curr, (charToInt (Array2.sub(arr, i, j)) i j curr)); traverseArray i (j+1) (curr+1))

    val temp = traverseArray 0 0 0
    val arr_bool = Array.array(n*m, false)
    val arr_length = n*m

    fun countPaths (i:int) (flag:bool) =
      if (i < arr_length) then (
        if (Array.sub(arr_bool, i) = false andalso Array.sub(arr_new, i) = ~1)
        then (Array.update(arr_bool, i, true); countPaths (i+1) flag)
        else if (Array.sub(arr_new,i) > ~1 andalso Array.sub(arr_new, Array.sub(arr_new,i)) = ~1)
        then (Array.update(arr_new, i, ~1); countPaths (i+1) true)
        else (countPaths (i+1) flag)
      )
      else (flag)

    fun countPathsReverse (j:int) (flag:bool) =
      if (j >= 0) then (
        if (Array.sub(arr_bool, j) = false andalso Array.sub(arr_new, j) = ~1)
        then (Array.update(arr_bool, j, true); countPathsReverse (j-1) flag)
        else if (Array.sub(arr_new, j) > ~1 andalso Array.sub(arr_new, Array.sub(arr_new, j)) = ~1)
        then (Array.update(arr_new, j, ~1); countPathsReverse (j-1) true)
        else (countPathsReverse (j-1) flag)
      )
      else (flag)

    fun loopRooms true = loopRooms (countPathsReverse (arr_length-1) (countPaths 0 false))
      | loopRooms false = false

    val temp = loopRooms true

    fun countBools i sum =
      if (i < arr_length) then (
          if (Array.sub(arr_new, i) = ~1) then (countBools (i+1) (sum+1))
          else (countBools (i+1) sum)
        )
      else (sum)

    (* val result = (arr_length - result_2); *)
    val result = (arr_length - (countBools 0 0))
  in
    print(Int.toString result ^ "\n")
  end;
