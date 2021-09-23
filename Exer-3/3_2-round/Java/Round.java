import java.io.*;
import java.util.*;

public class Round {
    private static Integer towns;
    private static Integer cars;
    private static List<Integer> carsArray;
    private static List<Integer> carsSum = new ArrayList<>();
    private static List<Boolean> validTowns;
    public static void main(String[] args) {
        readInput(args[0]);
        int minSum = Integer.MAX_VALUE;
        // ALGORITHM FOR carsSum : carsSum[i+1] = carsSum[i] + cars - carsArray[i+1] * towns
        // CALCULATE SUM FOR FIRST TOWN
        int tempSum = 0;
        int furthestTown = moveFurthest(1);
        for (int i=1; i<towns; i++) {
            tempSum += carsArray.get(i) * calcDistance(i, 0);
        }
        carsSum.add(tempSum);
        // if (tempSum - 2 * calcDistance(furthestTown, 0) + 1 >= 0)
        if (isValid(calcDistance(furthestTown, 0), 0))
            validTowns.set(0, true);
        minSum = (validTowns.get(0) == true ? Math.min(minSum, tempSum) : minSum);

        // CALCULATE REST OF TOWNS
        for (int i=1; i<towns; i++) {
            int previousSum = carsSum.get(i-1);
            tempSum = previousSum + cars - carsArray.get(i) * towns;
            carsSum.add(tempSum);
            if (furthestTown == i)
                furthestTown = moveFurthest((furthestTown + 1) % towns);
            // if (tempSum - 2 * calcDistance(furthestTown, i) + 1 >= 0)
            if (isValid(calcDistance(furthestTown, i), i))
                validTowns.set(i, true);
            minSum = (validTowns.get(i) == true ? Math.min(minSum, tempSum) : minSum);
        }

        System.out.println(minSum + " " + carsSum.indexOf(minSum));
    }

    // CALCULATES THE DISTANCE FROM ONE START NODE TO ONE FINISH NODE
    private static Integer calcDistance(Integer start, Integer finish) {
        return (finish - start + Round.towns) % Round.towns;
    }

    private static boolean isValid(Integer distance, Integer currentNode) {
        return (Round.carsSum.get(currentNode) - 2 * distance + 1 >= 0 ? true : false);
    }

    private static Integer moveFurthest(Integer index) {
        while (carsArray.get(index) == 0) {
            index = (index + 1) % Round.towns;
        }
        return index;
    }

    private static void readInput(String fileName) {
        // String fileName = "Exer_sets/3_2-round/Testcases/round.in2";
        String line = null;
        try {
            BufferedReader reader = new BufferedReader(new FileReader(fileName));
            line = reader.readLine();
            String[] buffer = line.split(" ");
            Round.towns = Integer.parseInt(buffer[0]);
            Round.cars = Integer.parseInt(buffer[1]);
            Round.carsArray = new ArrayList<>(Collections.nCopies(Round.towns, 0));
            Round.validTowns = new ArrayList<>(Collections.nCopies(Round.towns, false));
            line = reader.readLine();
            buffer = line.split(" ");
            for (String x : buffer) {
                int value = Round.carsArray.get(Integer.parseInt(x));
                Round.carsArray.set(Integer.parseInt(x), value + 1);
                // Round.carsArray.add(Integer.parseInt(x));
                
            }
            reader.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
