import java.io.*;
import java.util.*;

public class Qssort {
    public static Integer n;
    public static Queue<Integer> array = new ArrayDeque<>();
    public static Stack<Integer> stack = new Stack<>();
    public static void main(String[] args) {
        // readInput(args[0]);
        readInput();
        List<Integer> sortedArray = new ArrayList<>(array);
        Collections.sort(sortedArray);
        
        Solver solver = new BFSolver();
        State initial = new QssortState(array, stack, sortedArray.toString(), null, "");
        State result = solver.solve(initial);
        if (result.getPrevious() == null) {
            System.out.println("empty");
        } else {
            printAnswer(result);
        }
    }

    //READ INPUT
    public static void readInput() {
        String fileName = "Exer_sets/3_1-qssort/Testcases/qssort.in20";
        String line = null;
        try {
            BufferedReader reader = new BufferedReader(new FileReader(fileName));
            line = reader.readLine();
            Qssort.n = Integer.parseInt(line);
            line = reader.readLine();
            String[] buffer = line.split(" ");
            for (String x : buffer) {
                Qssort.array.add(Integer.parseInt(x));
            }
            reader.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // PRINTS RESULT
    private static void printAnswer(State s) {
        if (s.getPrevious() != null) {
            printAnswer(s.getPrevious());
        }
        System.out.print(s);
    }
} 
